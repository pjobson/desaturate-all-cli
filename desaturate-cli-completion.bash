#!/bin/bash
# Bash completion script for desaturate-cli

_desaturate_cli_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Main commands
    local commands="on off toggle status saturation auto schedule unschedule init test help"

    case $prev in
        desaturate-cli)
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
            return 0
            ;;
        saturation)
            # Check if we're completing the second parameter (duration)
            if [[ ${#COMP_WORDS[@]} -eq 4 ]]; then
                # Suggest common duration values in seconds
                COMPREPLY=($(compgen -W "1 2 3 5 10 15 30" -- "$cur"))
            else
                # Suggest common saturation values including floating point
                COMPREPLY=($(compgen -W "0 5.5 10 15.5 20 25.5 30 40 50 60 70 75.5 80 90 95.5 100" -- "$cur"))
            fi
            return 0
            ;;
        auto)
            COMPREPLY=($(compgen -W "on off" -- "$cur"))
            return 0
            ;;
        schedule)
            # Suggest common time formats for start time
            if [[ ${#COMP_WORDS[@]} -eq 3 ]]; then
                COMPREPLY=($(compgen -W "22:00 21:00 20:00 23:00" -- "$cur"))
            elif [[ ${#COMP_WORDS[@]} -eq 4 ]]; then
                # Suggest common end times
                COMPREPLY=($(compgen -W "06:00 07:00 08:00 05:00" -- "$cur"))
            fi
            return 0
            ;;
    esac

    # Default completion for first argument
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
}

# Register the completion function
complete -F _desaturate_cli_completions desaturate-cli