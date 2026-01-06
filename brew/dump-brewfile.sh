#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
brew bundle dump --formula --cask --tap --mas --no-vscode --file="${SCRIPT_DIR}/Brewfile"