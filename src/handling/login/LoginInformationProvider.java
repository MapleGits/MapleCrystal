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
package handling.login;

import constants.GameConstants;
import java.io.File;
import java.util.List;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.Map;
import provider.MapleData;
import provider.MapleDataProvider;
import provider.MapleDataProviderFactory;
import provider.MapleDataTool;
import tools.Triple;

public class LoginInformationProvider {

    public enum JobType { 
        UltimateAdventurer(-1, "Ultimate", 0, /*130000000*/ 931030000),
        Resistance(0, "Resistance", 3000, /*931000000*/ 931030000),
        Adventurer(1, "", 0, /*10000*/ 931030000),
        Cygnus(2, "Premium", 1000, /*130030000*/ 931030000), //913040000
        Aran(3, "Orient", 2000, /*914000000*/ 931030000),
        Evan(4, "Evan", 2001, /*900090000*/ 931030000),
        Mercedes(5, "", 2002, /*910150000*/ 931030000),
        Demon(6, "", 3001, /*931050310*/ 931030000),
        Phantom(7, "", 2003,/* 915000000*/ 931030000),//2003
        DualBlade(8, "", 0, /*103050900*/ 931030000),
        Mihile(9, "", 5000, /*913070000*/ 931030000), //whatever
        Jett(10, "", 0, /*552000010*/ 931030000),
        Cannoneer(11, "", 0, /*3000000*/ 931030000);
        public int type, id, map;
        public String job;

        private JobType(int type, String job, int id, int map) {
            this.type = type;
            this.job = job;
            this.id = id;
            this.map = map;
        }

        public static JobType getByJob(String g) {
            for (JobType e : JobType.values()) {
                if (e.job.length() > 0 && g.startsWith(e.job)) {
                    return e;
                }
            }
            return Adventurer;
        }

        public static JobType getByType(int g) {
            for (JobType e : JobType.values()) {
                if (e.type == g) {
                    return e;
                }
            }
            return Adventurer;
        }
 public static JobType getById(int g) {
            for (JobType e : JobType.values()) {
                if (e.id == g || (g == 508 && e.type == 8)) {
                    return e;
                }
            }
            return Adventurer;
        }
    }
    private final static LoginInformationProvider instance = new LoginInformationProvider();
    protected final List<String> ForbiddenName = new ArrayList<String>();
    //gender, val, job
    protected final Map<Triple<Integer, Integer, Integer>, List<Integer>> makeCharInfo = new HashMap<Triple<Integer, Integer, Integer>, List<Integer>>();
    //0 = eyes 1 = hair 2 = haircolor 3 = skin 4 = top 5 = bottom 6 = shoes 7 = weapon

    public static LoginInformationProvider getInstance() {
        return instance;
    }

    protected LoginInformationProvider() {
        final String WZpath = System.getProperty("net.sf.odinms.wzpath");
        final MapleDataProvider prov = MapleDataProviderFactory.getDataProvider(new File(WZpath + "/Etc.wz"));
        MapleData nameData = prov.getData("ForbiddenName.img");
        for (final MapleData data : nameData.getChildren()) {
            ForbiddenName.add(MapleDataTool.getString(data));
        }
        nameData = prov.getData("Curse.img");
        for (final MapleData data : nameData.getChildren()) {
            ForbiddenName.add(MapleDataTool.getString(data).split(",")[0]);
        }
        final MapleData infoData = prov.getData("MakeCharInfo.img");
        final MapleData data = infoData.getChildByPath("Info");
        for (MapleData dat : data) {
            int val = -1;
            if (dat.getName().endsWith("Female")) { // comes first..
                val = 1;
            } else if (dat.getName().endsWith("Male")) {
                val = 0;
            }
            final int job = JobType.getByJob(dat.getName()).type;
            for (MapleData da : dat) {
                final Triple<Integer, Integer, Integer> key = new Triple<Integer, Integer, Integer>(val, Integer.parseInt(da.getName()), job);
                List<Integer> our = makeCharInfo.get(key);
                if (our == null) {
                    our = new ArrayList<Integer>();
                    makeCharInfo.put(key, our);
                }
                for (MapleData d : da) {
                    our.add(MapleDataTool.getInt(d, -1));
                }
            }
        }
        if (GameConstants.GMS) { //TODO LEGEND
            for (MapleData dat : infoData) {
                try {
                    final int type = JobType.getById(Integer.parseInt(dat.getName())).type;
                    for (MapleData d : dat) {
                        int val;
                        if (d.getName().endsWith("female")) {
                            val = 1;
						} else if (d.getName().endsWith("male")) {
                            val = 0;
                        } else {
                            continue;
                        }
                        for (MapleData da : d) {
                            final Triple<Integer, Integer, Integer> key = new Triple<Integer, Integer, Integer>(val, Integer.parseInt(da.getName()), type);
                            List<Integer> our = makeCharInfo.get(key);
                            if (our == null) {
                                our = new ArrayList<Integer>();
                                makeCharInfo.put(key, our);
                            }
                            for (MapleData dd : da) {
                                our.add(MapleDataTool.getInt(dd, -1));
                            }
                        }
                    }
                } catch (NumberFormatException e) {
                }
            }
        }
        final MapleData uA = infoData.getChildByPath("UltimateAdventurer");
        for (MapleData dat : uA) {
            final Triple<Integer, Integer, Integer> key = new Triple<Integer, Integer, Integer>(-1, Integer.parseInt(dat.getName()), JobType.UltimateAdventurer.type);
            List<Integer> our = makeCharInfo.get(key);
            if (our == null) {
                our = new ArrayList<Integer>();
                makeCharInfo.put(key, our);
            }
            for (MapleData d : dat) {
                our.add(MapleDataTool.getInt(d, -1));
            }
        }
    }

    public static boolean isExtendedSpJob(int jobId) {
        return jobId >= 5000 && jobId <= 5112 || jobId >= 3100 && jobId <= 3512 || jobId/100 == 22 || jobId / 100 == 23 
           || jobId ==2002 ||jobId ==2001 || jobId == 3000 || jobId == 3001
              || jobId == 508 || jobId == 2003 || jobId / 100 == 24 || jobId / 10 == 57;
    }
    
    
    public final boolean isForbiddenName(final String in) {
        for (final String name : ForbiddenName) {
            if (in.toLowerCase().contains(name.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    public final boolean isEligibleItem(final int gender, final int val, final int job, final int item) {
        if (item < 0) {
            return false;
        }
        final Triple<Integer, Integer, Integer> key = new Triple<Integer, Integer, Integer>(gender, val, job);
        final List<Integer> our = makeCharInfo.get(key);
        if (our == null) {
			return false;
        }
        return our.contains(item);
    }
}
