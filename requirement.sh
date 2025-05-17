which java > /dev/null 2>&1

[ ! $? -ne 0 ] || {
sudo apt update && sudo apt install openjdk-11-jdk
cat >> ~/.bashrc << 'EOF'
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
EOF
}

source ~/.bashrc
