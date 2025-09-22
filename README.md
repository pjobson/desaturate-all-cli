# Desaturate All CLI (Cinnamon DE)

A command-line interface for controlling screen desaturation effects in the Cinnamon desktop environment. This tool provides an easy way to enable grayscale mode, adjust saturation levels, and manage automatic scheduling from the terminal.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Installing the CLI](#installing-the-cli)
    - [Bash Completion (Optional)](#bash-completion-optional)
- [Usage](#usage)
    - [Basic Commands](#basic-commands)
    - [Saturation Control](#saturation-control)
    - [Automatic Scheduling](#automatic-scheduling)
    - [Running Without Arguments](#running-without-arguments)
- [Configuration](#configuration)
    - [Configuration Options](#configuration-options)
- [Examples](#examples)
    - [Basic Usage](#basic-usage)
    - [Night Mode Setup](#night-mode-setup)
    - [Fade Animations](#fade-animations)
    - [Startup Integration](#startup-integration)
- [Troubleshooting](#troubleshooting)
    - [Common Issues](#common-issues)
    - [Debug Mode](#debug-mode)
- [Uninstallation](#uninstallation)
- [How It Works](#how-it-works)
- [License](#license)
- [Citation](#citation)

## Features

- **Toggle desaturation on/off** - Instantly switch between color and grayscale
- **Adjustable saturation levels** - Fine-tune the amount of desaturation (0-100%, supports decimals)
- **Smooth fade animations** - Gradually transition between saturation levels over time
- **Automatic scheduling** - Enable/disable based on time of day
- **Persistent settings** - Configuration saved across sessions
- **Resume on startup** - Restore previous state when Cinnamon starts
- **Direct screen control** - Works independently of the GUI applet

## Installation

### Prerequisites

- Cinnamon desktop environment
- `jq` for JSON configuration management
- `bc` for saturation calculations

Install dependencies:

```bash
sudo apt install jq bc
```

### Installing the CLI

1. **Make the script executable:**

        chmod +x desaturate-cli

2. **Install globally (recommended):**

        # Install to user directory
        ./install-cli.sh
        
        # Or install system-wide (requires sudo)
        ./install-cli.sh --global

3. **Add to PATH (if installing manually):**

        # Copy to local bin directory
        cp desaturate-cli ~/.local/bin/
        
        # Or create a symlink
        ln -s "$(pwd)/desaturate-cli" ~/.local/bin/desaturate-cli

### Bash Completion (Optional)

Enable tab completion for command and option suggestions:

```bash
# Source the completion script
source desaturate-cli-completion.bash

# Or add to your bash profile for persistent completion
echo "source $(pwd)/desaturate-cli-completion.bash" >> ~/.bashrc
```

## Usage

### Basic Commands

```bash
# Enable desaturation effect
desaturate-cli on

# Disable desaturation effect
desaturate-cli off

# Toggle current state
desaturate-cli toggle

# Show current status
desaturate-cli status

# Apply configuration settings
desaturate-cli init
```

### Saturation Control

```bash
# Set saturation level (0 = grayscale, 100 = full color)
desaturate-cli saturation 0     # Full grayscale
desaturate-cli saturation 25    # Mostly grayscale
desaturate-cli saturation 25.5  # Fine-tuned with decimals
desaturate-cli saturation 50    # Half saturation
desaturate-cli saturation 75    # Slight desaturation

# Gradual fade animations (saturation duration_in_seconds)
desaturate-cli saturation 0 5   # Fade to grayscale over 5 seconds
desaturate-cli saturation 100 3 # Fade to full color over 3 seconds
desaturate-cli saturation 50 10 # Smooth 10-second transition to 50%
```

*Note: Setting saturation automatically enables the effect*

### Automatic Scheduling

```bash
# Enable automatic scheduling
desaturate-cli auto on

# Disable automatic scheduling
desaturate-cli auto off

# Set schedule (24-hour format) - creates crontab entries
desaturate-cli schedule 22:00 06:00  # Enable at 10 PM, disable at 6 AM

# Remove automatic schedule from crontab
desaturate-cli unschedule
```

### Running Without Arguments

```bash
# Apply configuration and show status
desaturate-cli
```

## Configuration

Settings are stored in `~/.config/desaturate/settings.json`:

```json
{
    "enabled": false,
    "saturation": 0,
    "automatic": false,
    "start_time": "22:00",
    "end_time": "06:00",
    "resume_on_startup": false
}
```

### Configuration Options

- **`enabled`** - Current effect state (true/false)
- **`saturation`** - Saturation level (0-100, supports decimals)
- **`automatic`** - Enable automatic scheduling (true/false)
- **`start_time`** - Time to automatically enable (HH:MM format)
- **`end_time`** - Time to automatically disable (HH:MM format)
- **`resume_on_startup`** - Restore state when Cinnamon starts (true/false)

## Examples

### Basic Usage
```bash
# Quick grayscale toggle
desaturate-cli toggle

# Set to 25% saturation and enable
desaturate-cli saturation 25

# Smooth fade to low saturation over 8 seconds
desaturate-cli saturation 10 8

# Check current settings
desaturate-cli status
```

### Night Mode Setup
```bash
# Enable automatic night mode
desaturate-cli auto on
desaturate-cli schedule 20:00 08:00
desaturate-cli saturation 10

# Test gradual evening transition (fade to 5% over 2 minutes)
desaturate-cli saturation 5 120

# Check the configuration
desaturate-cli status
```

### Fade Animations
```bash
# Quick transitions
desaturate-cli saturation 0 2      # Fast fade to grayscale (2 seconds)
desaturate-cli saturation 100 1    # Quick restore to color (1 second)

# Gradual transitions
desaturate-cli saturation 25 30    # Slow fade over 30 seconds
desaturate-cli saturation 75.5 15  # Medium fade with precise value

# Eye strain relief patterns
desaturate-cli saturation 20 5     # Gentle 5-second fade for breaks
desaturate-cli saturation 90 10    # Gradual return over 10 seconds
```

*Note: Fade animations run at 60 FPS for smooth visual transitions*

### Startup Integration
```bash
# Add to your shell startup file (~/.bashrc, ~/.profile, etc.)
desaturate-cli init  # Apply saved configuration on login
```

## Troubleshooting

### Common Issues

**Effect not working:**
- Ensure Cinnamon desktop environment is running
- Check if the original applet is installed (not required but helpful)
- Try running `desaturate-cli init` to apply configuration

**Permission errors:**
- Make sure the script is executable: `chmod +x desaturate-cli`
- For global installation, ensure you have sudo privileges

**Configuration not saved:**
- Verify `jq` is installed for JSON processing
- Check write permissions to `~/.config/desaturate/`

### Debug Mode

```bash
# Test effect detection
desaturate-cli test

# View configuration
cat ~/.config/desaturate/settings.json
```

## Uninstallation

```bash
# Remove globally installed CLI
./install-cli.sh --uninstall

# Remove configuration (optional)
rm -rf ~/.config/desaturate/
```

## How It Works

The CLI communicates directly with Cinnamon's window manager through D-Bus, applying `ClutterDesaturateEffect` to `Main.uiGroup`. This approach:

- Works independently of the GUI applet
- Provides reliable state management through configuration files
- Enables direct control over the visual effect
- Supports automatic scheduling and persistence

## License

This project builds upon the open-source Cinnamon applet ecosystem and is provided as-is for community use.

## Citation

This CLI tool is based on the original "Desaturate All" Cinnamon applet:

- **Original Applet**: [Desaturate All](https://cinnamon-spices.linuxmint.com/applets/view/371)
- **Original Author**: klangman
- **Applet Repository**: Cinnamon Spices Collection

The CLI extends the functionality of the original applet by providing command-line access, enhanced configuration management, and automatic scheduling features.
