#!/bin/bash

# Configuration
local_path="."
remote_path="~/workspace"
exclude_file=".gitignore"

# Get an ssh command as parameter (ssh user@ip -p port ...) and extract the ip and port
# the param won't be wrapped with ".." so take all the string after the first space
param=$(echo "$@")
# exit if no parameter is provided
if [ -z "$param" ]; then
  echo "Usage: $0 <ssh command>"
  exit 1
fi
ip=$(echo "$param" | awk '{print $2}')
port=$(echo "$param" | awk '{print $4}')
echo "IP: $ip"
echo "Port: $port"

# Watch the directory for any modifications
inotifywait -m -r -e modify,create,delete "$local_path" --excludei "$(grep -Ev '^(\s*$|#)' $local_path/$exclude_file | sed ':a;N;$!ba;s/\n/|/g')" |
while read -r directory events filename; do
  echo "Changes detected in: $directory/$filename. Syncing..."

  # Use rsync to sync files
  rsync -avzPC \
    --exclude="__pycache__/" \
    --filter=":- $local_path/$exclude_file" \
    -e "ssh -p $port" \
    . $ip:$remote_path
done

