#!/bin/bash
# pass.sh

# Variables to hold the arguments to pass
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
        shift
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

# Functions:

# Creates a local file to store the password (clear text)
createFile() {
	echo "$PASSWORD" > "$FILE"
}

# Generate the private key
genKey() {
	ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y
}

# Add the remote host to the list of known hosts for SSH operations
keyScan() {
	ssh-keyscan -H "$IP_ADDR" >> ~/.ssh/known_hosts
}

# Copy the public key to remote host for SSH operations using 'sshpass' with provided password
keyCopy() {
	sshpass -f "$FILE" ssh-copy-id "$IP_ADDR"
}

# Copy the artifacts to Tomcat web app home
copyArtifact() {
	scp "$ARTIFACT" "$IP_ADDR":"$CATALINA_HOME"/webapps
}

# Call all the functions
createFile
genKey
keyScan
keyCopy
copyArtifact