#!/bin/bash
SQL_ZIP=sqldeveloper-*.zip
MVN=apache-maven-3.3.9
ECL_TAR=eclipse-*.tar.gz

cd /opt
cp $PROVISION_DIR/files/3pp/* .

#
# Maven
#
echo Setting up $MVN
unzip $MVN-bin.zip > /dev/null
ln -s /opt/$MVN/bin/mvn /usr/local/bin
rm -fr $$MVN-bin.zip

#
# unzip eclipse, make executable link
#
echo Unpacking Eclipse
cd /opt
tar xzf $ECL_TAR
ln -s /opt/eclipse/eclipse /usr/local/bin
rm -fr $ECL_TAR

#
# Install sublime text editor
#
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get -y install sublime-text-installer

#
# SQL developer
#
echo Setting up SQL Developer
cd /opt
unzip $SQL_ZIP > /dev/null
chmod +x /opt/sqldeveloper/sqldeveloper/bin/sqldeveloper
ln -s /opt/sqldeveloper/sqldeveloper/bin/sqldeveloper /usr/local/bin
mkdir -p /home/vagrant/.sqldeveloper/4.0.0
echo "SetJavaHome /usr/lib/jvm/java-8-oracle" > /home/vagrant/.sqldeveloper/4.0.0/product.conf
rm -fr $SQL_ZIP

# chown
chown vagrant:vagrant /opt -R
chown vagrant:vagrant /home/vagrant -R
