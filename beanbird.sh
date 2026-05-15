#!/bin/sh
# beanbird.sh — Return Beanbird Cursor

echo "=== beanbird.sh started ==="

# 1. Prepare destination
echo "Step 1: mkdir /tmp/cursors..."
mkdir -p /tmp/cursors
echo "mkdir exit code: $?"

# 2. Download cursor zip
echo "Step 2: Downloading 4.0.zip..."
curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/7.5.zip -o /tmp/7.5.zip
echo "curl exit code: $?"
if [ ! -f /tmp/7.5.zip ]; then
    echo "ERROR: /tmp/7.5.zip not found after curl."
    exit 1
fi

# 3. Extract directly into /tmp/cursors/
echo "Step 3: Extracting into /tmp/cursors/..."
unzip -o /tmp/4.0.zip -d /tmp/cursors/
echo "unzip exit code: $?"
echo "Contents of /tmp/cursors/:"
ls /tmp/cursors/

# 4. Bind mount
echo "Step 4: Mounting /tmp/cursors -> /usr/share/im..."
mount --bind /tmp/cursors /usr/share/im
echo "mount exit code: $?"
if [ $? -ne 0 ]; then
    echo "ERROR: bind mount failed."
    exit 1
fi
echo "Step 4 OK."

sync

# 5. Restart surface-manager
echo "Step 5: Restarting surface-manager..."
initctl restart surface-manager
echo "initctl exit code: $?"

echo "=== Done. Screen will go black for 10-20 seconds. ==="

sleep(20)

rm -rf /tmp/cursors/
