#!/bin/bash
typeset -i "iterations=$2"
typeset -i "timeout=$3"
typeset -a variables=()

while IFS= read -r line
do
    variables+=("$line")
done <<< "$1"

for ((i=1; i<=iterations; i++))
do
    dnf provides "${variables[@]}" && break
    sleep "${timeout}"
done
