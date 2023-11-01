#!/usr/bin/env python3
import sys

import subprocess

ONLY_ONCE_FLAGS = ["-L", "--line-number", "-l", "--with-filename", "--column", "-c"]

# Seperates arguments to three lists:
# 1. rg options that can be used multiple times
# 2. rg options that should only be used in the first rg call
# 3. words to find
def separate_args(args: list[str]) -> tuple[list[str], list[str], list[str]]:
    rg_second_run_options = []
    rg_first_options = []
    words_to_find = []
    encountered_separator = False

    for arg in args:
        if arg == "--":
            encountered_separator = True
            continue

        if encountered_separator:
            words_to_find += arg.split(" ")
        elif arg in ONLY_ONCE_FLAGS:
            rg_first_options.append(arg)
        else:
            rg_first_options.append(arg)
            rg_second_run_options.append(arg)

    return rg_second_run_options, rg_first_options, words_to_find


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
    rg_second_options, rg_first_options, words_to_find = separate_args(sys.argv[1:])
    if len(words_to_find) == 0:
        return
    if len(words_to_find) == 1:
        last_process = subprocess.Popen([*rg_first_options, words_to_find[0]])
        last_process.wait()
        return

    rg_commands = build_rg_command_list(
        rg_first_options, rg_second_options, words_to_find
    )

    prev_process = subprocess.Popen(rg_commands[0], stdout=subprocess.PIPE)

    for rg_command in rg_commands[1:-1]:
        process = subprocess.Popen(
            rg_command, stdin=prev_process.stdout, stdout=subprocess.PIPE
        )
        prev_process = process

    last_process = subprocess.Popen(rg_commands[-1], stdin=prev_process.stdout)
    last_process.wait()


if __name__ == "__main__":
    main()


def stress_test():
    for i in range(1000):
        a, b, c = separate_args(
            [
                "rg",
                "-L",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--",
                "canon",
                "abi",
            ]
        )
        build_rg_command_list(a, b, c)


def profiling():
    from cProfile import Profile

    with Profile() as profile:
        stress_test()
    profile.print_stats(sort="time")
