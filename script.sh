#!/bin/bash

# =======================================
# Kenneth Otero
# Scripting Languages
# October 2, 2024
# Bash Project 1
# =======================================

# Display script information
function scriptInformation() {
    echo "Bash Project 1 - Time Zone Converter"
    echo "Usage $0 -i <input-time-zone> -o <output-time-zone>"
    echo "Options:"
    echo "  -i <input-time-zone>: Time zone you wish to convert from. Choices: EST, CST, MST, and PST."
    echo "  -o <output-time-zone>: Time zone you wish to convert to. Choices: BST, CEST, and EEST."
    echo "  -h: Adding this option after the script name and omitting the other options will display this information."
}

# Display help information
if [[ $# -eq 0 || "$1" == "-h" ]]; then
    scriptInformation
    exit 0
fi

# Initialize variables
inputTimeZone=""
outputTimeZone=""
USTimeZones="USTimeZones.txt"
EUTimeZones="EUTimeZones.txt"

# Populate variables
while getopts ":i:o:h" opt; do
    case $opt in
        i) # Get input time zone
            inputTimeZone=$OPTARG
            ;;
        o) # Get output time zone
            outputTimeZone=$OPTARG
            ;;
        h) # Display help
            scriptInformation
            exit 0
            ;;
        \?) # Other arguments
            echo "Invalid option -$OPTARG."
            scriptInformation
            exit 0
            ;;
        :) # No arguments
            echo "Option -$OPTARG requires an argument."
            scriptInformation
            exit 1
            ;; 
    esac
done

# Check for empty arguments
if [[ -z $inputTimeZone || -z $outputTimeZone ]]; then
    echo "Missing input or output time zone arguments. See the following:"
    scriptInformation
    exit 1
fi

# Check for input time zone and verify against file.txt via regex
if ! grep -q -E "\b${inputTimeZone}\b" "$USTimeZones"; then
    echo "Incorrect input time zone argument: $inputTimeZone. See the following:"
    scriptInformation
    exit 1
fi

# Check for output time zone and verify against file.txt via regex
if ! grep -q -E "\b${outputTimeZone}\b" "$EUTimeZones"; then
    echo "Incorrect output time zone argument: $outputTimeZone. See the following:"
    scriptInformation
    exit 1
fi

# Get current timestamp and convert to output time zone
currentTime=""
convertedTime=""
case $inputTimeZone in
    "PST")
        currentTime=$(TZ="CEST+7" date +"%H:%M")
        case $outputTimeZone in
            "BST")
                convertedTime=$(date -d "$currentTime -11 hours" +"%H:%M")
                ;;
            "CEST")
                convertedTime=$(date -d "$currentTime -12 hours" +"%H:%M")
                ;;
            "EEST")
                convertedTime=$(date -d "$currentTime -13 hours" +"%H:%M")
                ;;
        esac
        ;;
    "MST")
        currentTime=$(TZ="CEST+6" date +"%H:%M")
        case $outputTimeZone in
            "BST")
                convertedTime=$(date -d "$currentTime -10 hours" +"%H:%M")
                ;;
            "CEST")
                convertedTime=$(date -d "$currentTime -11 hours" +"%H:%M")
                ;;
            "EEST")
                convertedTime=$(date -d "$currentTime -12 hours" +"%H:%M")
                ;;
        esac
        ;;
    "CST")
        currentTime=$(TZ="CEST+5" date +"%H:%M")
        case $outputTimeZone in
            "BST")
                convertedTime=$(date -d "$currentTime -9 hours" +"%H:%M")
                ;;
            "CEST")
                convertedTime=$(date -d "$currentTime -10 hours" +"%H:%M")
                ;;
            "EEST")
                convertedTime=$(date -d "$currentTime -11 hours" +"%H:%M")
                ;;
        esac
        ;;
    "EST")
        currentTime=$(TZ="CEST+4" date +"%H:%M")
        case $outputTimeZone in
            "BST")
                convertedTime=$(date -d "$currentTime -8 hours" +"%H:%M")
                ;;
            "CEST")
                convertedTime=$(date -d "$currentTime -9 hours" +"%H:%M")
                ;;
            "EEST")
                convertedTime=$(date -d "$currentTime -10 hours" +"%H:%M")
                ;;
        esac
esac

# Display result and save it in a text file
result="Thank you for using this script. You have converted $currentTime $inputTimeZone to $convertedTime $outputTimeZone."
echo $result
echo $result > "result.txt"
echo "These results have also been saved within the result.txt file."
exit 0