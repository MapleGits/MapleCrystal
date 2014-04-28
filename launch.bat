@echo off
@title RoyalMS v117
set CLASSPATH=.;dist\RoyalMS.jar;dist\mina-core.jar;dist\slf4j-api.jar;dist\slf4j-jdk14.jar;dist\mysql-connector-java-bin.jar
java -client -Dnet.sf.odinms.wzpath=wz server.Start
pause