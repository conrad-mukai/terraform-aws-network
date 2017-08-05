#!/bin/bash

# set path to authorized_keys
file=/home/${user}/.ssh/authorized_keys

# create the authorized_keys (public keys for all allowed users)
cat > $file <<EOF
${authorized_keys}
EOF

# set file owner/permissions
chmod 600 $file
