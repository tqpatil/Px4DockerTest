#!/bin/bash
# Test the GitHub Actions workflow locally using act
# Install act: https://github.com/nektos/act
# macOS: brew install act
# Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

set -e

echo "=== Testing GitHub Actions Workflow Locally ==="
echo ""

# Check if act is installed
if ! command -v act &> /dev/null; then
    echo "ERROR: 'act' is not installed."
    echo ""
    echo "To install act:"
    echo "  macOS:  brew install act"
    echo "  Linux:  curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash"
    echo ""
    echo "More info: https://github.com/nektos/act"
    exit 1
fi

echo "Running GitHub Actions workflow locally..."
echo ""
echo "NOTE: This will use Docker to run the workflow in the same container image"
echo "      as GitHub Actions (osrf/ros:humble-desktop-full)"
echo ""

# Run the workflow with act
# --container-architecture linux/amd64: Ensure consistent architecture
# -j px4-ros: Run only the px4-ros job
# --verbose: Show detailed output
act -j px4-ros \
    --container-architecture linux/amd64 \
    --verbose
