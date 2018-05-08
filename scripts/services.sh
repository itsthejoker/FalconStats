#!/bin/bash

# @author   https://www.reddit.com/user/LookAtMyKeyboard
# Modifications for OSX by https://github.com/itsthejoker

# Declare array of services and pretty human readable names
declare -a services=(
"redis-server"
"docker"
)
declare -a serviceName=(
"Redis"
"Docker"
)
declare -a serviceStatus=()

# Get status of all my services
for service in "${services[@]}"
do
    servStat=$(launchctl list | grep "$service")
    serviceStatus+=($([ -z "$servStat" ] && echo "inactive\n" || echo "active\n"))
done

# Maximum column width
#width=$((49-2))
width=$((72))

# Current line and line length
line=" "
lineLen=0

echo " "
echo -e "Services running:\n"

for i in ${!serviceStatus[@]}
do
    # Next line and next line length
    next="${serviceName[$i]}: ${serviceStatus[$i]}"
    nextLen=$((1+${#next}))

    # If the current line will exceed the max column with then echo the current line and start a new line
    if [[ $((lineLen+nextLen)) -gt width ]]; then
        echo -e "$line"
        lineLen=0
        line="  "
    fi

    lineLen=$((lineLen+nextLen))

    # Color the next line green if it's active, else red
    # does this even work on OSX? I'm really not sure.
    if [[ "${serviceStatus[$i]}" == "active" ]]; then
    line+="\e[32m\e[0m${serviceName[$i]}: ${serviceStatus[$i]} "
    else
    line+="${serviceName[$i]}: ${serviceStatus[$i]} "
    fi
done

# echo what is left
echo -e "$line"
