#!/bin/bash

# download cli zip file
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# verify cli download with gpg
gpg --import ./cli-gpg-key

curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig

if gpg --status-fd 1 --verify awscliv2.sig awscliv2.zip | grep -qF "VALIDSIG FB5DB77FD5C118B80511ADA8A6310ACC4672475C"; then
  echo "VALIDSIG found."
else
  echo "VALIDSIG not found!"
  exit
fi

# unzip and install
unzip awscliv2.zip
sudo ./aws/install