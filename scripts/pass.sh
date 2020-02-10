#!/bin/bash
# arguments.sh

# Default values of arguments
PASSWORD=""
IP_ADDR=""
FILE=""
CATALINA_HOME=""
# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -p|--password)
        PASSWORD="$2"
        shift # Remove --initialize from processing
        ;;
    		-a|--ip-addr)
				IP_ADDR="$3"
				shift
				;;
				-f|--file)
				FILE="$4"
				shift
				;;
				-c|--catalina-home)
				CATALINA_HOME="$5"
				shift
				;;
    esac
done

createFile() {
	echo "$PASSWORD" > "$FILE"
}

genKey() {
	ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsaTemp <<< y
}

keyScan() {
	ssh-keyscan -H "$IP_ADDR" >> ~/.ssh/known_hostsTemp
}

keyCopy() {
	sshpass -f "$FILE" ssh-copy-id "$IP_ADDR":"$CATALINA_HOME"/webapps
}

createFile
genKey
keyScan
keyCopy