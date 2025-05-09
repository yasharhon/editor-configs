#!/bin/bash

# Check that file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Install each package listed in the package file
while read extension; do
    code --install-extension $extension
done < "$1"
