#!/bin/bash

# Send clipboard's contents to remote host's clipboard using ssh(1) and xsel(1x).
# I wrote pasta because I read docs and the web on one computer and develop code on the other one
# and I often need snippets of text from the docs machine to be used on the dev machine.
#
# Call this script with 'pasta.sh user@host' where host is the remote machine and user is your account there.
# Then supply your ssh passphrase at the prompt just once.
#
# Now, copying text on the local computer (where pasta is running) will signal pasta to automatically send
# the text to the remote host and insert it in its clipboard, ready to be pasted. It's like magic, I tell you.
#
# BUG: for some reason this script stops working after a while (on the order of several days).
# I haven't had time to find out why, so I just restart it.
#
# Written by Gunk Slinger @ github, 7-25. I am placing this file in the public domain for anyone
# to use, enjoy, curse, modify, or sell(LOL), etc.

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

while true; do
  fping `echo $1 |cut -d@ -f2`  # get remote hostname and set reutrn code with fping
  if [[ "$?" ==  "0" ]]; then   # if 0 then it is up
    content=$(xsel -ob)
    if [[ "$content" != "$prev_content" ]]; then
      echo "$content" | ssh -Y $1 "xsel --display $DISPLAY -ib"
      prev_content="$content"
    fi
  fi
  sleep 1
done
