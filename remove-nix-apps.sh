#!/usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils

# Script to remove Nix apps that were copied to ~/Applications/Nix Apps
# by the home-manager activation script

set -euo pipefail

NIX_APPS_DIR="$HOME/Applications/Nix Apps"

echo "Removing Nix Apps from Spotlight..."
echo "Target directory: $NIX_APPS_DIR"
echo ""

if [ -d "$NIX_APPS_DIR" ]; then
    echo "Found Nix Apps directory. Removing all apps..."
    rm -rf "$NIX_APPS_DIR"/*
    echo "✓ Removed all apps from $NIX_APPS_DIR"
    echo ""
    echo "Note: The directory itself is kept for future activations."
    echo "To remove the directory entirely, run:"
    echo "  rmdir \"$NIX_APPS_DIR\""
else
    echo "No Nix Apps directory found at $NIX_APPS_DIR"
    echo "Nothing to clean up."
fi

echo ""
echo "Done!"
