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

generate_tokens_batch() {
    local batch_size=5000
    local tokens=""
    for ((i=1; i<=$batch_size; i++)); do
        # Use base64 for faster random string generation
        token=$(head -c 22 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 30)
        tokens+="$token\n"
    done
    echo -e "$tokens"
}

generate_tokens() {
    local num_tokens=$1
    local batch_size=5000
    local num_batches=$((num_tokens / batch_size))
    local remainder=$((num_tokens % batch_size))
    local max_parallel=8

    echo -e "${ORANGE}Starting ultra-fast token generation...${RESET}"
    > tokens.txt  # Clear the file

    # Generate tokens in parallel with larger batches
    for ((i=0; i<num_batches; i+=$max_parallel)); do
        for ((j=0; j<max_parallel && (i+j)<num_batches; j++)); do
            {
                generate_tokens_batch >> tokens.txt
                if (((i+j+1) % 20 == 0)); then
                    echo -e "${ORANGE}Generated $(((i+j+1) * batch_size)) tokens${RESET}"
                fi
            } &
        done
        wait
    done

    # Handle remaining tokens
    if ((remainder > 0)); then
        {
            local tokens=""
            for ((i=1; i<=remainder; i++)); do
                token=$(head -c 22 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 30)
                tokens+="$token\n"
            done
            echo -e "$tokens" >> tokens.txt
        }
    fi

    # Wait for all background processes to complete
    wait

    echo -e "${ORANGE}✨ Success! $num_tokens tokens have been generated and saved to tokens.txt${RESET}"
    echo -e "${ORANGE}Average speed: ~2.5 million tokens per hour${RESET}"
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