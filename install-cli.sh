#!/bin/bash

# Installation script for Desaturate All CLI
# This script installs the CLI tool to make it globally accessible

CLI_SCRIPT="desaturate-cli"
INSTALL_DIR="$HOME/.local/bin"
GLOBAL_INSTALL_DIR="/usr/local/bin"

show_help() {
    cat << EOF
Desaturate All CLI Installer

Usage: $0 [OPTIONS]

Options:
    --user      Install to user directory (~/.local/bin) [default]
    --global    Install to system directory (/usr/local/bin) [requires sudo]
    --uninstall Remove the installed CLI tool
    --help      Show this help message

Examples:
    $0                  # Install to ~/.local/bin
    $0 --global         # Install to /usr/local/bin (requires sudo)
    $0 --uninstall      # Remove installed CLI tool

EOF
}

install_cli() {
    local target_dir="$1"
    local target_file="$target_dir/desaturate-cli"

    # Create target directory if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir" || {
            echo "Error: Failed to create directory $target_dir" >&2
            return 1
        }
    fi

    # Copy the CLI script
    echo "Installing desaturate-cli to $target_dir"
    cp "$CLI_SCRIPT" "$target_file" || {
        echo "Error: Failed to copy $CLI_SCRIPT to $target_file" >&2
        return 1
    }

    # Make it executable
    chmod +x "$target_file" || {
        echo "Error: Failed to make $target_file executable" >&2
        return 1
    }

    echo "Successfully installed desaturate-cli to $target_file"

    # Check if target directory is in PATH
    if [[ ":$PATH:" != *":$target_dir:"* ]]; then
        echo ""
        echo "WARNING: $target_dir is not in your PATH"
        echo "Add the following line to your ~/.bashrc or ~/.profile:"
        echo "export PATH=\"\$PATH:$target_dir\""
        echo ""
        echo "Or run: echo 'export PATH=\"\$PATH:$target_dir\"' >> ~/.bashrc"
        echo "Then restart your terminal or run: source ~/.bashrc"
    else
        echo "You can now use 'desaturate-cli' from anywhere in your terminal"
    fi
}

uninstall_cli() {
    local removed=false

    # Check user directory
    if [ -f "$INSTALL_DIR/desaturate-cli" ]; then
        echo "Removing $INSTALL_DIR/desaturate-cli"
        rm "$INSTALL_DIR/desaturate-cli"
        removed=true
    fi

    # Check global directory
    if [ -f "$GLOBAL_INSTALL_DIR/desaturate-cli" ]; then
        echo "Removing $GLOBAL_INSTALL_DIR/desaturate-cli (requires sudo)"
        sudo rm "$GLOBAL_INSTALL_DIR/desaturate-cli"
        removed=true
    fi

    if [ "$removed" = true ]; then
        echo "Successfully uninstalled desaturate-cli"
    else
        echo "desaturate-cli was not found in standard installation directories"
    fi
}

# Check if CLI script exists
if [ ! -f "$CLI_SCRIPT" ]; then
    echo "Error: $CLI_SCRIPT not found in current directory" >&2
    echo "Please run this script from the applet directory" >&2
    exit 1
fi

# Parse command line arguments
case "$1" in
    --global)
        if [ "$EUID" -eq 0 ]; then
            install_cli "$GLOBAL_INSTALL_DIR"
        else
            echo "Installing to system directory requires sudo privileges"
            sudo "$0" --global-internal
        fi
        ;;
    --global-internal)
        # Internal flag for sudo execution
        install_cli "$GLOBAL_INSTALL_DIR"
        ;;
    --user|"")
        install_cli "$INSTALL_DIR"
        ;;
    --uninstall)
        uninstall_cli
        ;;
    --help|-h)
        show_help
        ;;
    *)
        echo "Error: Unknown option '$1'" >&2
        show_help
        exit 1
        ;;
esac