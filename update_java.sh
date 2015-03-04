#!/bin/bash

#Instructions: http://www.wikihow.com/Upgrade-Oracle-Java-on-Ubuntu-Linux

#NEED TO PROVIDE INPUT ON WHERE THE JDK AND JRE ARE LOCATED
JDK_PATH=$1
echo "JDK_PATH: $JDK_PATH"
JRE_PATH=$2
echo "JRE_PATH: $JRE_PATH"
JAVA_HOME=/usr/lib/jvm
echo "JAVA_HOME: $JAVA_HOME" 
TMP=/tmp/JAVA_UPGRADE
echo "TMP: $TMP"

mkdir -p $TMP 
sudo tar zxf $JDK_PATH -C $TMP 
sudo tar zxf $JRE_PATH -C $TMP

JDK_VERSION=`sudo ls $TMP | grep jdk`
echo "JDK_VERSION: $JDK_VERSION"
JRE_VERSION=`sudo ls $TMP | grep jre`
echo "JRE_VERSION: $JRE_VERSION"
sudo mv $TMP/$JDK_VERSION $JAVA_HOME
sudo mv $TMP/$JRE_VERSION $JAVA_HOME
sudo chown -R root:root $JAVA_HOME

sudo cp /etc/profile /etc/profile.bak
sudo grep "JAVA_HOME=$JAVA_HOME" /etc/profile | sed 's/\//\\\//g' > $TMP/old_jdk.txt
OLD_JDK=`cat $TMP/old_jdk.txt`
echo "OLD_JDK: $OLD_JDK"


sudo echo $JAVA_HOME/$JDK_VERSION | sed 's/\//\\\//g' > $TMP/new_jdk.txt
NEW_JDK=`cat $TMP/new_jdk.txt`
echo "NEW_JDK: $NEW_JDK"
sudo cat /etc/profile | sed -e 's/$OLD_JDK/$NEW_JDK/' > $TMP/profile.tmp

sudo grep "JRE_HOME=$JAVA_HOME" /etc/profile | sed 's/\//\\\//g' > $TMP/old_jre.txt
OLD_JRE=`cat $TMP/old_jre.txt`
echo "OLD_JRE: $OLD_JRE"
sudo echo $JAVA_HOME/$JRE_VERSION | sed 's/\//\\\//g' > $TMP/new_jre.txt
NEW_JRE=`cat $TMP/new_jre.txt`
echo "NEW_JRE: $NEW_JRE"
sudo cat $TMP/profile.tmp | sed -e 's/$OLD_JRE/$NEW_JRE/' > $TMP/profile.tmp.1

sudo cp $TMP/profile.tmp.1 /etc/profile

JAVA_BIN="$JAVA_HOME/$JRE_VERSION/bin/java"
echo "JAVA_BIN: $JAVA_BIN"
JAVAC_BIN="$JAVA_HOME/$JDK_VERSION/bin/javac"
echo "JAVAC_BIN: $JAVAC_BIN"
JAVAWS_BIN="$JAVA_HOME/$JRE_VERSION/bin/javaws"
echo "JAVAWS_BIN: $JAVAWS_BIN"

sudo update-alternatives --install "/usr/bin/java" "java" "$JAVA_BIN" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "$JAVAC_BIN" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "$JAVAWS_BIN" 1

sudo update-alternatives --set java $JAVA_BIN
sudo update-alternatives --set javac $JAVAC_BIN
sudo update-alternatives --set javaws $JAVAWS_BIN

. /etc/profile

java -version
javac -version

rm -rf /tmp/JAVA_UPGRADE

#Updating Firefox with new Java
LIBNPJP2_PATH="/home/carroll/.mozilla/plugins/libnpjp2.so"
sudo rm -f $LIBNPJP2 
sudo ln -s /usr/lib/jvm/$JRE_VERSION/lib/i386/libnpjp2.so $LIBNPJP2_PATH
