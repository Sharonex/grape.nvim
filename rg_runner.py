#!/usr/bin/env python3
import sys

import subprocess

ONLY_ONCE_FLAGS = ["-L", "--line-number", "-l", "--with-filename", "--column", "-c"]

# Seperates arguments to three lists:
# 1. rg options that can be used multiple times
# 2. rg options that should only be used in the first rg call
# 3. words to find
def seperate_args(args: list[str]) -> tuple[list[str], list[str], list[str]]:
    rg_first_options = []
    rg_all_options = []
    words_to_find = []
    encountered_separator = False

    for arg in args:
        if arg == "--":
            encountered_separator = True
            continue

        if encountered_separator:
            words_to_find.append(arg)
        elif arg in ONLY_ONCE_FLAGS:
            rg_first_options.append(arg)
        else:
            rg_first_options.append(arg)
            rg_all_options.append(arg)

    return rg_all_options, rg_first_options, words_to_find


def build_rg_command_list(
    first_rg_options: list[str], rg_all_options: list[str], words_to_find: list[str]
) -> list[str]:
    rg_commands = []
    first_run = True
    for word in words_to_find:
        rg_commands.append([*(first_rg_options if first_run else rg_all_options), word])
        first_run = False

    return rg_commands


def main():
    rg_all_options, rg_first_options, words_to_find = seperate_args(sys.argv[1:])
    rg_commands = build_rg_command_list(rg_first_options, rg_all_options, words_to_find)

    prev_process = subprocess.Popen(rg_commands[0], stdout=subprocess.PIPE)

    for rg_command in rg_commands[1:]:
        process = subprocess.Popen(
            rg_command, stdin=prev_process.stdout, stdout=subprocess.PIPE
        )
        prev_process = process

    output, _ = prev_process.communicate()
    print(output.decode("utf-8"))


if __name__ == "__main__":
    main()
