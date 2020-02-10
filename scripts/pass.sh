#!/bin/bash
# arguments.sh

# Default values of arguments
PASSWORD=""
FILE=""
IP_ADDR=""
ARTIFACT=""
CATALINA_HOME=""

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -p|--password)
        PASSWORD="$2"
        shift # Remove --initialize from processing
        ;;
        -f|--file)
				FILE="$3"
				shift
				;;
    		-i|--ip-addr)
				IP_ADDR="$4"
				shift
				;;
				-a|--artifact)
				ARTIFACT="$5"
				shift
				;;
				-c|--catalina-home)
				CATALINA_HOME="$6"
				shift
				;;
    esac
done

createFile() {
	echo "$PASSWORD" > "$FILE"
}

genKey() {
	ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
}

keyScan() {
	ssh-keyscan -H "$IP_ADDR" >> ~/.ssh/known_hosts
}

keyCopy() {
	sshpass -f "$FILE" ssh-copy-id "$IP_ADDR"
}

copyArtifact() {
	scp "$ARTIFACT" "$IP_ADDR":"$CATALINA_HOME"/webapps
}

createFile
genKey
keyScan
keyCopy
copyArtifact