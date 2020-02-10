#!/bin/bash

getAppVersion() {

	for fname in test-v*.war; do 
    [[ $fname =~ test-v(.*).war ]];
    echo "${BASH_REMATCH[1]}";
	done
}

version=$(getAppVersion)
echo "$version"