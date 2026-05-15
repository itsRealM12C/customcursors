#!/bin/sh
# beanbird.sh — Return Beanbird Cursor
# Requires Homebrew Channel (hbchannel) with root service

# 1. Download Beanbird cursor package
curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/4.0.zip -o /tmp/4.0.zip
if [ $? -ne 0 ]; then
    echo "ERROR: Download failed."
    exit 1
fi

# 2. Extract and prepare
unzip -o /tmp/4.0.zip -d /tmp/
rm -rf /tmp/cursors
mv /tmp/4.0 /tmp/cursors

if [ ! -d /tmp/cursors ]; then
    echo "ERROR: Expected /tmp/4.0 after extraction. Check zip structure."
    exit 1
fi

# 3. Apply bind mount over the webOS cursor theme directory
mount --bind /tmp/cursors /usr/share/icons
if [ $? -ne 0 ]; then
    echo "ERROR: bind mount failed. Ensure hbchannel root service is active."
    exit 1
fi

sync

# 4. Restart the compositor — try initctl, fall back to luna-send
initctl restart surface-manager 2>/dev/null || \
    luna-send -n 1 luna://com.webos.service.applicationManager/closeAllApps '{}'

echo "Done. Screen will go black for ~10-20 seconds."
