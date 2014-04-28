/*
 This file is part of the OdinMS Maple Story Server
 Copyright (C) 2008 ~ 2010 Patrick Huy <patrick.huy@frz.cc> 
 Matthias Butz <matze@odinms.de>
 Jan Christian Meyer <vimes@odinms.de>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License version 3
 as published by the Free Software Foundation. You may not use, modify
 or distribute this program under any other version of the
 GNU Affero General Public License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package handling.login.handler;

import java.util.List;
import java.util.LinkedHashMap;
import java.util.Calendar;

import client.inventory.Item;
import client.MapleClient;
import client.MapleCharacter;
import client.MapleCharacterUtil;
import client.Skill;
import client.SkillEntry;
import client.inventory.MapleInventory;
import client.inventory.MapleInventoryType;
import constants.GameConstants;
import client.SkillFactory;
import constants.ServerConstants;
import handling.channel.ChannelServer;
import handling.login.LoginInformationProvider;
import handling.login.LoginInformationProvider.JobType;
import handling.login.LoginServer;
import handling.login.LoginWorker;
import handling.world.World;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import server.MapleItemInformationProvider;
import server.quest.MapleQuest;
import tools.packet.CField;
import tools.packet.LoginPacket;
import tools.data.LittleEndianAccessor;
import tools.packet.CWvsContext;
import tools.packet.PacketHelper;

public class CharLoginHandler {

    private static final boolean loginFailCount(final MapleClient c) {
        c.loginAttempt++;
        if (c.loginAttempt > 5) {
            return true;
        }
        return false;
    }

    public static final void login(final LittleEndianAccessor slea, final MapleClient c) {
         String login = c.isLocalhost() ? "admin" : slea.readMapleAsciiString();
        String pwd = c.isLocalhost() ? "admin" : slea.readMapleAsciiString();
       
        int loginok = 0;
        final boolean ipBan = c.hasBannedIP();
        final boolean macBan = c.hasBannedMac();
        
        if(AutoRegister.autoRegister){
                if (AutoRegister.getAccountExists(login) == true) {
                loginok = c.login(login, pwd, ipBan || macBan);
            } else if (AutoRegister.autoRegister == true && (!c.hasBannedIP() || !c.hasBannedMac())) {
                AutoRegister.createAccount(login, pwd, c.getSession().getRemoteAddress().toString());
                if (AutoRegister.success != false) {
                        loginok = c.login(login, pwd, ipBan || macBan);
                        c.getSession().write(CWvsContext.serverNotice(1, "[System]\r\nAutomatic registration successful."));
                }
            }
        } else {
            loginok = c.login(login, pwd, ipBan || macBan);
        }
        
        final Calendar tempbannedTill = c.getTempBanCalendar();

        if (loginok == 0 && (ipBan || macBan) && !c.isGm()) {
            loginok = 3;
            if (macBan) {
                MapleCharacter.ban(c.getSession().getRemoteAddress().toString().split(":")[0], "Enforcing account ban, account " + login, false, 4, false);
            }
        }
        if (loginok == 3){
            c.getSession().write(CWvsContext.serverNotice(1, "You have been permanently banned for the following reason: " + c.getBanReason()));
            c.getSession().write(LoginPacket.getLoginFailed(3));
        }
        else if (loginok != 0) {
            if (!loginFailCount(c)) {
                c.clearInformation();
                c.getSession().write(LoginPacket.getLoginFailed(loginok));
            } else {
                c.getSession().close();
            }
        } else if (tempbannedTill.getTimeInMillis() != 0) {
            if (!loginFailCount(c)) {
                c.clearInformation();
                c.getSession().write(LoginPacket.getTempBan(PacketHelper.getTime(tempbannedTill.getTimeInMillis()), c.getGBanReason()));
            } else {
                c.getSession().close();
            }
        } else {
            c.loginAttempt = 0;
            LoginWorker.registerClient(c);
        }
    }

    public static final void ServerListRequest(final MapleClient c) {
        //c.getSession().write(LoginPacket.getLoginWelcome());
        c.getSession().write(LoginPacket.getServerList(0, LoginServer.getLoad()));
        if(ServerConstants.hcEnabled){
            //c.getSession().write(LoginPacket.getServerList(1, LoginServer.getLoad())); //CUSTOM: Show heartcore server, also TODO: show the load of the HC server, not login
        }
        //c.getSession().write(CField.getServerList(1, "Scania", LoginServer.getInstance().getChannels(), 1200));
        //c.getSession().write(CField.getServerList(2, "Scania", LoginServer.getInstance().getChannels(), 1200));
        //c.getSession().write(CField.getServerList(3, "Scania", LoginServer.getInstance().getChannels(), 1200));
        c.getSession().write(LoginPacket.getEndOfServerList());
        c.getSession().write(LoginPacket.enableRecommended());
        c.getSession().write(LoginPacket.sendRecommended(0, LoginServer.getEventMessage()));
    }

    public static final void ServerStatusRequest(final MapleClient c) {
        // 0 = Select world normally
        // 1 = "Since there are many users, you may encounter some..."
        // 2 = "The concurrent users in this world have reached the max"
        final int numPlayer = LoginServer.getUsersOn();
        final int userLimit = LoginServer.getUserLimit();
        if (numPlayer >= userLimit) {
            c.getSession().write(LoginPacket.getServerStatus(2));
        } else if (numPlayer * 2 >= userLimit) {
            c.getSession().write(LoginPacket.getServerStatus(1));
        } else {
            c.getSession().write(LoginPacket.getServerStatus(0));
        }
    }

    public static final void CharlistRequest(final LittleEndianAccessor slea, final MapleClient c) {
        if (!c.isLoggedIn()) {
            c.getSession().close();
            return;
        }
        if (GameConstants.GMS) {
            slea.readByte(); //2?
        }
        final int server = slea.readByte();
        final int channel = slea.readByte() + 1;
        if (!World.isChannelAvailable(channel) || server > 1) { //TODOO: MULTI WORLDS
            c.getSession().write(LoginPacket.getLoginFailed(10)); //cannot process so many
            return;
        }

        //System.out.println("Client " + c.getSession().getRemoteAddress().toString().split(":")[0] + " is connecting to server " + server + " channel " + channel + "");

        final List<MapleCharacter> chars = c.loadCharacters(server);
        if (chars != null && ChannelServer.getInstance(channel) != null) {
            c.setWorld(server);
            c.setChannel(channel);
            c.getSession().write(LoginPacket.getSecondAuthSuccess(c));
            c.getSession().write(LoginPacket.getCharList(c.getSecondPassword(), chars, c.getCharacterSlots()));
            /*if(chars.isEmpty()){ //apparently you can't place this here, need to do it ingame
                StringBuilder hcText = new StringBuilder("You have selected the Heartcore server.\r\n");
                hcText.append("Be warned that the Heartcore server is PERMA-DEATH: If your character's HP reaches 0, it is deleted.\r\n");
                hcText.append("In addition to this, Heartcore is many times more difficult than the normal game, and is not recommended to those new to the server.\r\n");
                hcText.append("However, Heartcore mode possesses increased EXP, MESO, and DROP rates: 3x, 2x, and 2x, respectively.\r\n");
                hcText.append("Heartcore is linked to the main server, so characters in Heartcore mode can freely see and interact with characters that are not.\r\n");
                hcText.append("A more complete overview of Heartcore mechanics is available in the forum.\r\n");
                hcText.append("Good luck!");
                c.getSession().write(CWvsContext.serverNotice(1, hcText.toString()));
            }*/
        } else {
            c.getSession().close();
        }
    }

    public static final void updateCCards(final LittleEndianAccessor slea, final MapleClient c) {
        if (slea.available() != 24 || !c.isLoggedIn()) {
            c.getSession().close();
            return;
        }
        final Map<Integer, Integer> cids = new LinkedHashMap<>();
        for (int i = 1; i <= 6; i++) { // 6 chars
            final int charId = slea.readInt();
            if ((!c.login_Auth(charId) && charId != 0)|| ChannelServer.getInstance(c.getChannel()) == null || c.getWorld() != 0) {
                c.getSession().close();
                return;
            }
            cids.put(i, charId);
        }
        c.updateCharacterCards(cids);
    }

    public static final void CheckCharName(final String name, final MapleClient c) {
        c.getSession().write(LoginPacket.charNameResponse(name,
                !(MapleCharacterUtil.canCreateChar(name, c.isGm()) && (!LoginInformationProvider.getInstance().isForbiddenName(name) || c.isGm()))));
    }


    public static void CreateChar(final LittleEndianAccessor slea, final MapleClient c) {
        if (!c.isLoggedIn()) {
            c.getSession().close();
            return;
        }
        final String name = slea.readMapleAsciiString();
        final JobType jobType = JobType.getByType(slea.readInt()); // BIGBANG: 0 = Resistance, 1 = Adventurer, 2 = Cygnus, 3 = Aran, 4 = Evan, 5 = mercedes
        final short db = slea.readShort(); //whether dual blade = 1 or adventurer = 0
        final byte gender = slea.readByte(); //??idk corresponds with the thing in addCharStats
        byte skinColor = slea.readByte(); // 01
        int hairColor = 0;
        final byte unk2 = slea.readByte(); // 08
        final boolean mercedes = (jobType == JobType.Mercedes);
        final boolean demon = (jobType == JobType.Demon);
        final boolean mihile = (jobType == JobType.Mihile);
        final boolean aran = (jobType == JobType.Aran);
        final boolean evan = (jobType == JobType.Evan);
        final boolean resist = (jobType == JobType.Resistance);
        final boolean cygnus = (jobType == JobType.Cygnus);
        final boolean adv = (jobType == JobType.Adventurer);
        boolean jettPhantom = (jobType == LoginInformationProvider.JobType.Jett) || (jobType == LoginInformationProvider.JobType.Phantom) || (jobType == LoginInformationProvider.JobType.DualBlade);
        final int face = slea.readInt();
        final int hair = slea.readInt();
        if (!mercedes && !mihile && !demon && !jettPhantom) { //mercedes/demon dont need hair color since its already in the hair
            hairColor = slea.readInt();
            skinColor = (byte) slea.readInt();
        }
        if(mihile){ //For some reason an int was missing.
            final int unk3 = slea.readInt();
        }
        final int demonMark = (aran ? 0 : evan ? 0 : resist ? 0 : cygnus ? 0 : adv ? 0 : slea.readInt());
        final int top = slea.readInt();
        final int bottom =  slea.readInt();
        final int shoes = slea.readInt();
        final int weapon = jobType == LoginInformationProvider.JobType.Phantom ? 1362046 : mercedes ? 1522038 : evan ? 1372005 : slea.readInt();
        int shield = jobType == LoginInformationProvider.JobType.Phantom ? 1352100 : jobType == LoginInformationProvider.JobType.Mihile ? 1098000 : mercedes ? 1352000 : demon ? slea.readInt() : 0;

       // System.out.println("Name:" + name + " jobType: " +jobType.toString() + " db: " + db + " gender: " + gender + " skinColor: " + skinColor + " unk2: " + unk2 + "face: " + face + " hair: " + hair
        //        + " demon: " + demonMark + " Top: "+ top + " bottom: " + bottom + " shoes: " + shoes + " wep: " + weapon + " shield: " + shield);
        
        MapleCharacter newchar = MapleCharacter.getDefault(c, jobType);
        newchar.setWorld((byte) c.getWorld());
        newchar.setFace(face);
        newchar.setHair(hair + hairColor);
        newchar.setGender(gender);
        newchar.setName(name);
        newchar.setSkinColor(skinColor);
        newchar.setDemonMarking(demonMark);
        newchar.setHcMode((short)c.getWorld());

        final MapleItemInformationProvider li = MapleItemInformationProvider.getInstance();
        final MapleInventory equip = newchar.getInventory(MapleInventoryType.EQUIPPED);

        Item item = li.getEquipById(top);
        item.setPosition((byte) -5);
        equip.addFromDB(item);

        if (bottom > 0) { //resistance have overall
            item = li.getEquipById(bottom);
            item.setPosition((short)(byte)(jettPhantom ? -9 : -6));
            equip.addFromDB(item);
        }
        
        item = li.getEquipById(shoes);
        item.setPosition((byte) -7);
        equip.addFromDB(item);

        item = li.getEquipById(weapon);
        item.setPosition((byte) -11);
        equip.addFromDB(item);

        if (shield > 0) {
            item = li.getEquipById(shield);
            item.setPosition((byte) -10);
            equip.addFromDB(item);
        }

        //blue/red pots
        switch (jobType) {
            case Resistance: // Resistance
                //newchar.getInventory(MapleInventoryType.ETC).addItem(new Item(4161001, (byte) 0, (short) 1, (byte) 0));
                final Map<Skill, SkillEntry> ss = new HashMap<>();
                //ss.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss, false);
                break;
            case Adventurer: // Adventurer
                //newchar.getInventory(MapleInventoryType.ETC).addItem(new Item(4161001, (byte) 0, (short) 1, (byte) 0));
                final Map<Skill, SkillEntry> ss1 = new HashMap<>();
                //ss1.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss1, false);
                break;
            case Cygnus: // Cygnus
                //newchar.getInventory(MapleInventoryType.ETC).addItem(new Item(4161047, (byte) 0, (short) 1, (byte) 0));
                newchar.setQuestAdd(MapleQuest.getInstance(20022), (byte) 1, "1");
                newchar.setQuestAdd(MapleQuest.getInstance(20010), (byte) 1, null); //>_>_>_> ugh
                final Map<Skill, SkillEntry> ss2 = new HashMap<>();
                //ss2.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss2, false);
                break;
            case Aran: // Aran
                newchar.setJob(2100);
                final Map<Skill, SkillEntry> ss3 = new HashMap<>();
                //ss3.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss3, false);
                break;
            case Evan: //Evan
                newchar.setLevel((short) 10);
                newchar.setJob(2200);
                newchar.getStat().maxhp += 140; //Beginner 10 levels
                newchar.getStat().maxmp += 210;
                newchar.getStat().hp += 140; //Beginner 10 levels
                newchar.getStat().mp += 210;
                newchar.getStat().str = 4;
                newchar.getStat().dex = 4;
                newchar.getStat().int_ = 4; //Why is int_ and luk switched?
                newchar.getStat().luk = 4;
                newchar.setRemainingAp((short) 54); 
                newchar.setRemainingSp(5); 
                final Map<Skill, SkillEntry> ss4= new HashMap<>();
                //ss4.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss4, false);
                break;
            case Mercedes: // Mercedes
                //newchar.getInventory(MapleInventoryType.ETC).addItem(new Item(4161079, (byte) 0, (short) 1, (byte) 0));
		final Map<Skill, SkillEntry> ss5 = new HashMap<>();
		ss5.put(SkillFactory.getSkill(20021000), new SkillEntry((byte) 0, (byte) 0, -1));
		ss5.put(SkillFactory.getSkill(20021001), new SkillEntry((byte) 0, (byte) 0, -1));
		ss5.put(SkillFactory.getSkill(20020002), new SkillEntry((byte) 0, (byte) 0, -1));				
		//ss5.put(SkillFactory.getSkill(20020022), new SkillEntry((byte) 1, (byte) 1, -1)); //wrong skill, fag
		ss5.put(SkillFactory.getSkill(20020109), new SkillEntry((byte) 1, (byte) 1, -1));
		ss5.put(SkillFactory.getSkill(20021110), new SkillEntry((byte) 1, (byte) 1, -1));
		ss5.put(SkillFactory.getSkill(20020111), new SkillEntry((byte) 1, (byte) 1, -1));
		ss5.put(SkillFactory.getSkill(20020112), new SkillEntry((byte) 1, (byte) 1, -1));
		ss5.put(SkillFactory.getSkill(20021181), new SkillEntry((byte) -1, (byte) 0, -1));
                ss5.put(SkillFactory.getSkill(20021166), new SkillEntry((byte) -1, (byte) 0, -1));
                //ss5.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
		newchar.changeSkillLevel_Skip(ss5, false);
                break;
            case Demon: //Demon
                //newchar.getInventory(MapleInventoryType.ETC).addItem(new Item(4161054, (byte) 0, (short) 1, (byte) 0));
                final Map<Skill, SkillEntry> ss6 = new HashMap<>();
                //ss6.put(SkillFactory.getSkill(30011000), new SkillEntry((byte) 0, (byte) 0, -1));
                //ss6.put(SkillFactory.getSkill(30011001), new SkillEntry((byte) 0, (byte) 0, -1));
                //ss6.put(SkillFactory.getSkill(30010002), new SkillEntry((byte) 0, (byte) 0, -1));				
                ss6.put(SkillFactory.getSkill(30010185), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30010112), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30010111), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30010110), new SkillEntry((byte) 1, (byte) 1, -1));
                //ss6.put(SkillFactory.getSkill(30010022), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30011109), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30011170), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30011169), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30011168), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30011167), new SkillEntry((byte) 1, (byte) 1, -1));
                ss6.put(SkillFactory.getSkill(30010166), new SkillEntry((byte) 1, (byte) 1, -1));
                //ss6.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
                newchar.changeSkillLevel_Skip(ss6, false);
                break;

            case Phantom:
                newchar.setLevel((short) 10);
                newchar.setJob(2400);
                newchar.getStat().maxhp += 294; //Beginner 10 levels
                newchar.getStat().maxmp += 113;
                newchar.getStat().hp += 294; //Beginner 10 levels
                newchar.getStat().mp += 113;
                newchar.getStat().str = 4;
                newchar.getStat().dex = 4;
                newchar.getStat().int_ = 30; //Why is int_ and luk switched?
                newchar.getStat().luk = 4;
                newchar.setRemainingAp((short) 28); 
                newchar.setRemainingSp(5); 
                final Map<Skill, SkillEntry> ss7 = new HashMap<>();
                ss7.put(SkillFactory.getSkill(20031203), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20030204), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20031205), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20030206), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20031207), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20031208), new SkillEntry((byte) 1, (byte) 1, -1));
                ss7.put(SkillFactory.getSkill(20031209), new SkillEntry((byte) 1, (byte) 1, -1)); //Judgement Draw I
	        //ss7.put(SkillFactory.getSkill(20031210), new SkillEntry((byte) 1, (byte) 1, -1)); //Judgement Draw II is at 4th Job.
                //ss7.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss7, false);
               break;	
                
              case Jett:
                newchar.setLevel((short) 10);
                newchar.setJob(508);
                newchar.getStat().maxhp += 294; //Beginner 10
                newchar.getStat().maxmp += 113;
                newchar.getStat().hp += 294; //Beginner 10
                newchar.getStat().mp += 113;
                newchar.getStat().str -= 8;
                newchar.getStat().dex += 15;
                newchar.setRemainingAp((short) 38); 
                newchar.setRemainingSp(1); 
                final Map<Skill, SkillEntry> ss8 = new HashMap<>();
                ss8.put(SkillFactory.getSkill(228), new SkillEntry((byte) 1, (byte) 1, -1));
                //ss8.put(SkillFactory.getSkill(80001152), new SkillEntry((byte) 1, (byte) 1, -1));
                //ss8.put(SkillFactory.getSkill(80001151), new SkillEntry((byte) 1, (byte) 1, -1));
	         newchar.changeSkillLevel_Skip(ss8, false);
               break;	
        
               case Mihile:
                   newchar.setLevel((short) 10);
                   newchar.setJob(5100);
                    newchar.getStat().maxhp += 382; //Starting ten levels.
                    newchar.getStat().maxmp += 87;
                    newchar.getStat().hp += 382; 
                    newchar.getStat().mp += 87;
                    newchar.getStat().str = 4;
                    newchar.getStat().dex = 4;
                    newchar.getStat().int_ = 4;
                    newchar.getStat().luk = 4;
                    newchar.setRemainingAp((short) 54); 
                    newchar.setRemainingSp(5);
                    final Map<Skill, SkillEntry> ss9 = new HashMap<>();
                    ss9.put(SkillFactory.getSkill(50001214), new SkillEntry((byte) 1, (byte) 1, -1));
                    newchar.changeSkillLevel_Skip(ss9, false);
               break;	
        }

        if (MapleCharacterUtil.canCreateChar(name, c.isGm()) && (!LoginInformationProvider.getInstance().isForbiddenName(name) || c.isGm()) && (c.isGm() || c.canMakeCharacter(c.getWorld()))) {
            MapleCharacter.saveNewCharToDB(newchar, jobType, db);
            c.getSession().write(LoginPacket.addNewCharEntry(newchar, true));
            c.createdChar(newchar.getId());
        } else {
            c.getSession().write(LoginPacket.addNewCharEntry(newchar, false));
        }
    }

    public static final void CreateUltimate(final LittleEndianAccessor slea, final MapleClient c) {
        if (!c.isLoggedIn() || c.getPlayer() == null || c.getPlayer().getLevel() < 120 || c.getPlayer().getMapId() != 130000000 || c.getPlayer().getQuestStatus(20734) != 0 || c.getPlayer().getQuestStatus(20616) != 2 || !GameConstants.isKOC(c.getPlayer().getJob()) || !c.canMakeCharacter(c.getPlayer().getWorld())) {
            c.getPlayer().dropMessage(1, "You have no character slots.");
            c.getSession().write(CField.createUltimate(0));
            return;
        }
        //System.out.println(slea.toString());
        final String name = slea.readMapleAsciiString();
        final int job = slea.readInt(); //job ID
        
        final int face = slea.readInt();
        final int hair = slea.readInt();

        final int hat = slea.readInt();
        final int top = slea.readInt();
        final int glove = slea.readInt();
        final int shoes = slea.readInt();
        final int weapon = slea.readInt();

        final byte gender = c.getPlayer().getGender();
        JobType jobType = JobType.Adventurer;
        //if (!LoginInformationProvider.getInstance().isEligibleItem(gender, 0, jobType.type, face) || !LoginInformationProvider.getInstance().isEligibleItem(gender, 1, jobType.type, hair)) {
        //    c.getPlayer().dropMessage(1, "An error occurred.");
        //    c.getSession().write(CField.createUltimate(0));
        //    return;
        //}

        jobType = JobType.UltimateAdventurer;
        

        MapleCharacter newchar = MapleCharacter.getDefault(c, jobType);
        newchar.setJob(job);
        newchar.setWorld((byte) c.getPlayer().getWorld());
        newchar.setFace(face);
        newchar.setHair(hair);
        newchar.setGender(gender);
        newchar.setName(name);
        newchar.setSkinColor((byte) 3); //troll
        newchar.setLevel((short) 50);
        newchar.getStat().str = (short) 4;
        newchar.getStat().dex = (short) 4;
        newchar.getStat().int_ = (short) 4;
        newchar.getStat().luk = (short) 4;
        newchar.setRemainingAp((short) 254); //49*5 + 25 - 16
        newchar.setRemainingSp(job / 100 == 2 ? 128 : 122); //2 from job advancements. 120 from leveling. (mages get +6)
        newchar.getStat().maxhp += 150; //Beginner 10 levels
        newchar.getStat().maxmp += 125;
        newchar.getStat().hp += 150; //Beginner 10 levels
        newchar.getStat().mp += 125;
        switch (job) {
            case 110:
            case 120:
            case 130:
                newchar.getStat().maxhp += 600; //Job Advancement
                newchar.getStat().maxhp += 2000; //Levelup 40 times
                newchar.getStat().maxmp += 200;
                newchar.getStat().hp += 600; //Job Advancement
                newchar.getStat().hp += 2000; //Levelup 40 times
                newchar.getStat().mp += 200;
                break;
            case 210:
            case 220:
            case 230:
                newchar.getStat().maxmp += 600;
                newchar.getStat().maxhp += 500; //Levelup 40 times
                newchar.getStat().maxmp += 2000;
                newchar.getStat().mp += 600;
                newchar.getStat().hp += 500; //Levelup 40 times
                newchar.getStat().mp += 2000;
                break;
            case 310:
            case 320:
            case 410:
            case 420:
            case 520:
                newchar.getStat().maxhp += 500;
                newchar.getStat().maxmp += 250;
                newchar.getStat().maxhp += 900; //Levelup 40 times
                newchar.getStat().maxmp += 600;
                newchar.getStat().maxhp += 500;
                newchar.getStat().mp += 250;
                newchar.getStat().hp += 900; //Levelup 40 times
                newchar.getStat().mp += 600;
                break;
            case 510:
                newchar.getStat().maxhp += 500;
                newchar.getStat().maxmp += 250;
                newchar.getStat().maxhp += 450; //Levelup 20 times
                newchar.getStat().maxmp += 300;
                newchar.getStat().maxhp += 800; //Levelup 20 times
                newchar.getStat().maxmp += 400; 
                newchar.getStat().hp += 500;
                newchar.getStat().mp += 250;
                newchar.getStat().hp += 450; //Levelup 20 times
                newchar.getStat().mp += 300;
                newchar.getStat().hp += 800; //Levelup 20 times
                newchar.getStat().mp += 400;
                break;
            default:
                return;
        }
        for (int i = 2490; i < 2507; i++) {
            newchar.setQuestAdd(MapleQuest.getInstance(i), (byte) 2, null);
        }
        newchar.setQuestAdd(MapleQuest.getInstance(29947), (byte) 2, null);
        newchar.setQuestAdd(MapleQuest.getInstance(GameConstants.ULT_EXPLORER), (byte) 0, c.getPlayer().getName());

        final Map<Skill, SkillEntry> ss = new HashMap<>();
        ss.put(SkillFactory.getSkill(1074 + (job / 100)), new SkillEntry((byte) 5, (byte) 5, -1));
        ss.put(SkillFactory.getSkill(1195 + (job / 100)), new SkillEntry((byte) 5, (byte) 5, -1));
        ss.put(SkillFactory.getSkill(80), new SkillEntry((byte) 1, (byte) 1, -1));
        newchar.changeSkillLevel_Skip(ss, false);
        final MapleItemInformationProvider li = MapleItemInformationProvider.getInstance();

        int[] items = new int[]{1142257, hat, top, shoes, glove, weapon, hat + 1, top + 1, shoes + 1, glove + 1, weapon + 1}; //brilliant = fine+1
        for (byte i = 0; i < items.length; i++) {
            Item item = li.getEquipById(items[i]);
            item.setPosition((byte) (i + 1));
            newchar.getInventory(MapleInventoryType.EQUIP).addFromDB(item);
        }
        newchar.getInventory(MapleInventoryType.USE).addItem(new Item(2000004, (byte) 0, (short) 100, (byte) 0));
        newchar.getInventory(MapleInventoryType.USE).addItem(new Item(2000004, (byte) 0, (short) 100, (byte) 0));
        c.getPlayer().fakeRelog();
        if (MapleCharacterUtil.canCreateChar(name, c.isGm()) && (!LoginInformationProvider.getInstance().isForbiddenName(name) || c.isGm())) {
            MapleCharacter.saveNewCharToDB(newchar, jobType, (short) 0);
            MapleQuest.getInstance(20734).forceComplete(c.getPlayer(), 1101000);
            c.getSession().write(CField.createUltimate(1));
        } else {
            c.getSession().write(CField.createUltimate(0));
        }
    }

    
    public static final void DeleteChar(final LittleEndianAccessor slea, final MapleClient c) {
        String Secondpw_Client = GameConstants.GMS ? slea.readMapleAsciiString() : null;
        if (Secondpw_Client == null) {
            if (slea.readByte() > 0) { // Specific if user have second password or not
                Secondpw_Client = slea.readMapleAsciiString();
            }
            slea.readMapleAsciiString();
        }

        final int Character_ID = slea.readInt();

        if (!c.login_Auth(Character_ID) || !c.isLoggedIn() || loginFailCount(c)) {
            c.getSession().close();
            return; // Attempting to delete other character
        }
        byte state = 0;

        if (c.getSecondPassword() != null) { // On the server, there's a second password
            if (Secondpw_Client == null) { // Client's hacking
                c.getSession().close();
                return;
            } else {
                if (!c.CheckSecondPassword(Secondpw_Client)) { // Wrong Password
                    state = 20;
                }
            }
        }

        if (state == 0) {
            state = (byte) c.deleteCharacter(Character_ID);
        }
        c.getSession().write(LoginPacket.deleteCharResponse(Character_ID, state));
    }

    public static final void Character_WithoutSecondPassword(final LittleEndianAccessor slea, final MapleClient c, final boolean haspic, final boolean view) {
        slea.readByte(); // 1?
        slea.readByte(); // 1?
        final int charId = slea.readInt();
        if (view) {
            c.setChannel(1);
            c.setWorld(slea.readInt());
        }
        final String currentpw = c.getSecondPassword();
        if (!c.isLoggedIn() || loginFailCount(c) || (currentpw != null && (!currentpw.equals("") || haspic)) || !c.login_Auth(charId) || ChannelServer.getInstance(c.getChannel()) == null || c.getWorld() > 1) { // TODOO: MULTI WORLDS
            c.getSession().close();
            return;
        }
        c.updateMacs(slea.readMapleAsciiString());
        slea.readMapleAsciiString();
        if (slea.available() != 0) {
            final String setpassword = slea.readMapleAsciiString();

            if (setpassword.length() >= 6 && setpassword.length() <= 16) {
                c.setSecondPassword(setpassword);
                c.updateSecondPassword();
            } else {
                c.getSession().write(LoginPacket.secondPwError((byte) 0x14));
                return;
            }
        } else if (GameConstants.GMS && haspic) {
            return;
        }
        if (c.getIdleTask() != null) {
            c.getIdleTask().cancel(true);
        }
        final String s = c.getSessionIPAddress();
        LoginServer.putLoginAuth(charId, s.substring(s.indexOf('/') + 1, s.length()), c.getTempIP(), c.getChannel());
        c.updateLoginState(MapleClient.LOGIN_SERVER_TRANSITION, s);
        c.getSession().write(CField.getServerIP(c, Integer.parseInt(ChannelServer.getInstance(c.getChannel()).getIP().split(":")[1]), charId));
    }

    public static final void Character_WithSecondPassword(final LittleEndianAccessor slea, final MapleClient c, final boolean view) {
        final String password = slea.readMapleAsciiString();
        final int charId = slea.readInt();
        if (view) {
            c.setChannel(1);
            c.setWorld(slea.readInt());
        }
        if (!c.isLoggedIn() || loginFailCount(c) || c.getSecondPassword() == null || !c.login_Auth(charId) || ChannelServer.getInstance(c.getChannel()) == null || c.getWorld() > 1) { // TODOO: MULTI WORLDS
            c.getSession().close();
            return;
        }
        if (GameConstants.GMS) {
            c.updateMacs(slea.readMapleAsciiString());
        }
        if (c.CheckSecondPassword(password) && password.length() >= 6 && password.length() <= 16) {
            if (c.getIdleTask() != null) {
                c.getIdleTask().cancel(true);
            }
            final String s = c.getSessionIPAddress();
            LoginServer.putLoginAuth(charId, s.substring(s.indexOf('/') + 1, s.length()), c.getTempIP(), c.getChannel());
            c.updateLoginState(MapleClient.LOGIN_SERVER_TRANSITION, s);
            c.getSession().write(CField.getServerIP(c, Integer.parseInt(ChannelServer.getInstance(c.getChannel()).getIP().split(":")[1]), charId));
        } else {
            c.getSession().write(LoginPacket.secondPwError((byte) 0x14));
        }
    }

    public static void ViewChar(LittleEndianAccessor slea, MapleClient c) {
        Map<Byte, ArrayList<MapleCharacter>> worlds = new HashMap<Byte, ArrayList<MapleCharacter>>();
        List<MapleCharacter> chars = c.loadCharacters(c.getWorld()); //TODO multi world
        c.getSession().write(LoginPacket.showAllCharacter(chars.size()));
        for (MapleCharacter chr : chars) {
            if (chr != null) {
                ArrayList<MapleCharacter> chrr;
                if (!worlds.containsKey(chr.getWorld())) {
                    chrr = new ArrayList<MapleCharacter>();
                    worlds.put(chr.getWorld(), chrr);
                } else {
                    chrr = worlds.get(chr.getWorld());
                }
                chrr.add(chr);
            }
        }
        for (Entry<Byte, ArrayList<MapleCharacter>> w : worlds.entrySet()) {
            c.getSession().write(LoginPacket.showAllCharacterInfo(w.getKey(), w.getValue(), c.getSecondPassword()));
        }
    }
}
