#!/bin/bash

# Configuration
local_path="."
remote_user=""
remote_host=""
remote_path="/tmp/A/2/"
exclude_file=".gitignore"

# Watch the directory for any modifications
inotifywait -m -r -e modify,create,delete "$local_path" --excludei "$(grep -Ev '^(\s*$|#)' $local_path/$exclude_file | sed ':a;N;$!ba;s/\n/|/g')" |
while read -r directory events filename; do
  echo "Changes detected in: $directory/$filename. Syncing..."

  # Use rsync to sync files
  #rsync -avz --delete --filter=". $local_path/$exclude_file" "$local_path/" "$remote_user@$remote_host:$remote_path"
  #rsync -avzC --delete --filter=":- $local_path/$exclude_file" "$local_path/" "$remote_path"
  rsync -avzPC \
    --exclude="__pycache__/" \
    --filter=":- $local_path/$exclude_file" \
    -e 'ssh -p 17013' \
    . root@213.173.108.217:~/project
done

