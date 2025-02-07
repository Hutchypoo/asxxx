#!/bin/bash

# ANSI color codes
ORANGE='\033[38;5;208m'
RESET='\033[0m'

print_banner() {
    echo -e "${ORANGE}"
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo "██                                        Made By CPvP And Hutchles           ██"
    echo "██                                Full Project Releasing Late 2025 :)         ██"
    echo "██                          HUTCHY'S TOKEN GENERATOR                          ██"
    echo "██                                                                            ██"
    echo "██              ██╗  ██╗██╗   ██╗████████╗ ██████╗██╗  ██╗██╗   ██╗        ██"
    echo "██              ██║  ██║██║   ██║╚══██╔══╝██╔════╝██║  ██║╚██╗ ██╔╝        ██"
    echo "██              ███████║██║   ██║   ██║   ██║     ███████║ ╚████╔╝         ██"
    echo "██              ██╔══██║██║   ██║   ██║   ██║     ██╔══██║  ╚██╔╝          ██"
    echo "██              ██║  ██║╚██████╔╝   ██║   ╚██████╗██║  ██║   ██║           ██"
    echo "██              ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝           ██"
    echo "██                                                                            ██"
    echo "██                          ✨ Generate Tokens Fast ✨                        ██"
    echo "██                                                                            ██"
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo -e "${RESET}"
}

generate_random_token() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1
}

generate_tokens() {
    local num_tokens=$1
    echo
    echo -e "${ORANGE}Generating $num_tokens random tokens...${RESET}"
    echo
    > tokens.txt  # Clear the file

    for ((i=1; i<=$num_tokens; i++)); do
        token=$(generate_random_token)
        echo "$token" >> tokens.txt
        echo -e "${ORANGE}[$i] Generated: $token${RESET}"
    done

    echo
    echo -e "${ORANGE}✨ Success! $num_tokens tokens have been saved to tokens.txt${RESET}"
    echo
}

# Clear screen and print banner
clear
print_banner

# Ask for number of tokens
echo
echo -e "${ORANGE}How many tokens would you like to generate?${RESET}"
echo
read -p $'\033[38;5;208mEnter number: \033[0m' num_tokens
echo

if ! [[ "$num_tokens" =~ ^[0-9]+$ ]] || [ "$num_tokens" -lt 1 ]; then
    echo
    echo -e "${ORANGE}Error: Please enter a valid number greater than 0${RESET}"
    echo
    exit 1
fi

generate_tokens "$num_tokens"

echo -e "${ORANGE}Press Enter to exit...${RESET}"
read