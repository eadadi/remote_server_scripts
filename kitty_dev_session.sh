#!/bin/bash

# Param: ssh command: ssh remote_server -p port
# Flow
#   - Open new kitty tab with 3 terminals: "code" "kernel" "sync" if SSH_COMMAND is given,
#     else, only open 2 terminals: "code" "kernel"
#    - Layout: Tall (code and kernel)
#    - Activate torch_dev conda env in both code and kernel
#    - If SSH_COMMAND is given, do kitty ssh Param on the "kernel" terminal
#    - If SSH_COMMAND is given, run sync Param on the "sync" terminal

SSH_COMMAND=$(echo "$@")

# Open new kitty tab with 3 terminals: "code" "kernel" "sync"
kitty @ launch --type=tab --title="code" --cwd current
kitty @ launch --type=window --title="kernel" --cwd current
if [ ! -z "$SSH_COMMAND" ]; then
  kitty @ launch --type=tab --title="sync" --cwd current
fi

# Layout: Tall
kitty @ goto-layout --match title:code tall

# Activate torch_dev conda env in both code and kernel
kitty @ send-text --match title:code "conda activate torch_dev\n"
kitty @ send-text --match title:kernel "conda activate torch_dev\n"

# Run sync Param on the "sync" terminal
if [ ! -z "$SSH_COMMAND" ]; then
  kitty @ send-text --match title:sync "sync_ssh $SSH_COMMAND\n"
fi

# Do kitty ssh Param on the "kernel" terminal
if [ ! -z "$SSH_COMMAND" ]; then
kitty @ send-text --match title:kernel "kitten $SSH_COMMAND\n"
fi

