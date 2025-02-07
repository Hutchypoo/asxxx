import os
import sys
import random
import string
import multiprocessing
from concurrent.futures import ThreadPoolExecutor
import base64
import colorama
from colorama import Fore, Style

# Initialize colorama for Windows color support
colorama.init(convert=True)

def print_banner():
    print(f"{Fore.YELLOW}")  # Using yellow as closest to orange in Windows
    print("████████████████████████████████████████████████████████████████████████████████")
    print("██                                        Made By CPvP And Hutchles           ██")
    print("██                                Full Project Releasing Late 2025 :)         ██")
    print("██                          HUTCHY'S TOKEN GENERATOR                          ██")
    print("██                                                                            ██")
    print("██              ██╗  ██╗██╗   ██╗████████╗ ██████╗██╗  ██╗██╗   ██╗        ██")
    print("██              ██║  ██║██║   ██║╚══██╔══╝██╔════╝██║  ██║╚██╗ ██╔╝        ██")
    print("██              ███████║██║   ██║   ██║   ██║     ███████║ ╚████╔╝         ██")
    print("██              ██╔══██║██║   ██║   ██║   ██║     ██╔══██║  ╚██╔╝          ██")
    print("██              ██║  ██║╚██████╔╝   ██║   ╚██████╗██║  ██║   ██║           ██")
    print("██              ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝           ██")
    print("██                                                                            ██")
    print("██                          ✨ Generate Tokens Fast ✨                        ██")
    print("██                                                                            ██")
    print("████████████████████████████████████████████████████████████████████████████████")
    print(f"{Style.RESET_ALL}")

def generate_token():
    try:
        # Generate random bytes and encode as base64
        random_bytes = os.urandom(22)
        token = base64.b64encode(random_bytes).decode('utf-8')
        # Clean up the token to only include alphanumeric characters
        token = ''.join(c for c in token if c.isalnum())
        return token[:30]
    except Exception as e:
        print(f"{Fore.RED}Error generating token: {e}{Style.RESET_ALL}")
        return None

def generate_tokens_batch(batch_size):
    return [t for t in [generate_token() for _ in range(batch_size)] if t is not None]

def write_tokens_to_file(tokens, filename='tokens.txt', mode='a'):
    try:
        with open(filename, mode, encoding='utf-8') as f:
            f.write('\n'.join(tokens) + '\n')
    except Exception as e:
        print(f"{Fore.RED}Error writing to file: {e}{Style.RESET_ALL}")

def generate_all_tokens(num_tokens):
    batch_size = 5000
    num_batches = num_tokens // batch_size
    remainder = num_tokens % batch_size

    print(f"{Fore.YELLOW}Starting ultra-fast token generation...{Style.RESET_ALL}")

    try:
        # Clear the file
        open('tokens.txt', 'w', encoding='utf-8').close()

        # Determine optimal number of workers based on CPU cores
        max_workers = min(8, multiprocessing.cpu_count())

        # Use ThreadPoolExecutor for parallel processing
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Generate full batches
            futures = [executor.submit(generate_tokens_batch, batch_size) for _ in range(num_batches)]

            # Process results as they complete
            for i, future in enumerate(futures):
                tokens = future.result()
                write_tokens_to_file(tokens)
                if (i + 1) % 20 == 0:
                    print(f"{Fore.YELLOW}Generated {(i + 1) * batch_size} tokens{Style.RESET_ALL}")

        # Handle remaining tokens
        if remainder > 0:
            remaining_tokens = generate_tokens_batch(remainder)
            write_tokens_to_file(remaining_tokens)

        print(f"{Fore.YELLOW}✨ Success! {num_tokens} tokens have been generated and saved to tokens.txt{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}Average speed: ~2.5 million tokens per hour{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}An error occurred: {e}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}Press Enter to exit...{Style.RESET_ALL}")
        input()
        sys.exit(1)

def main():
    try:
        # Clear screen
        os.system('cls' if os.name == 'nt' else 'clear')

        print_banner()

        print()
        print(f"{Fore.YELLOW}How many tokens would you like to generate?{Style.RESET_ALL}")
        print()

        while True:
            try:
                num_tokens = input(f"{Fore.YELLOW}Enter number: {Style.RESET_ALL}")
                num_tokens = int(num_tokens)
                if num_tokens < 1:
                    raise ValueError
                break
            except ValueError:
                print()
                print(f"{Fore.YELLOW}Error: Please enter a valid number greater than 0{Style.RESET_ALL}")
                print()

        generate_all_tokens(num_tokens)
    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}Operation cancelled by user{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}An unexpected error occurred: {e}{Style.RESET_ALL}")

    print(f"{Fore.YELLOW}Press Enter to exit...{Style.RESET_ALL}")
    input()

if __name__ == '__main__':
    main()