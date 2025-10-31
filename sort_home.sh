#!/usr/bin/env bash

# Script to alphabetically sort packages in home.nix
# Usage: ./sort-nix-packages.sh home.nix

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-home.nix>"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found"
    exit 1
fi

# Create a backup
cp "$FILE" "${FILE}.backup"
echo "Created backup: ${FILE}.backup"

# Use awk to process the file
awk '
BEGIN { in_packages = 0; package_list = "" }

# Detect start of home.packages
/home\.packages = with pkgs; \[/ {
    in_packages = 1
    print $0
    next
}

# If we are in the packages section
in_packages == 1 {
    # Check if this is the closing bracket
    if ($0 ~ /^[[:space:]]*\];?[[:space:]]*$/) {
        # Sort and print the collected packages
        if (package_list != "") {
            # Split by newlines, sort, and print
            n = split(package_list, packages, "\n")
            asort(packages)
            for (i = 1; i <= n; i++) {
                if (packages[i] != "") {
                    print packages[i]
                }
            }
        }
        print $0
        in_packages = 0
        package_list = ""
        next
    }
    
    # Skip empty lines and comments within the package list
    if ($0 ~ /^[[:space:]]*$/ || $0 ~ /^[[:space:]]*#/) {
        next
    }
    
    # Collect the package line
    package_list = package_list $0 "\n"
    next
}

# Print everything else as-is
{ print }
' "$FILE" > "${FILE}.tmp"

# Replace original file with sorted version
mv "${FILE}.tmp" "$FILE"

echo "Done! Packages in $FILE have been sorted alphabetically."
echo "Original file backed up to ${FILE}.backup"

