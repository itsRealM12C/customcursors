#!/bin/sh
# beanbird.sh — Custom Cursors
# Requires Homebrew Channel (hbchannel) with root service

# 1. Download 7.5 cursor package
curl -L https://github.com/itsRealM12C/customcursors/raw/refs/heads/main/7.5.zip -o /tmp/7.5.zip
if [ $? -ne 0 ]; then
    echo "ERROR: Download failed."
    exit 1
fi

# 2. Extract and prepare
unzip -o /tmp/7.5.zip -d /tmp/cursors/
rm -rf /tmp/cursors
mv /tmp/7.5 /tmp/cursors

if [ ! -d /tmp/cursors ]; then
    echo "ERROR: Expected /tmp/7.5 after extraction. Check zip structure."
    exit 1
fi

# 3. Apply bind mount over the webOS cursor theme directory
mount --bind /tmp/cursors /usr/share/im
if [ $? -ne 0 ]; then
    echo "ERROR: bind mount failed. Ensure hbchannel root service is active."
    exit 1
fi

sync

luna-send -n -f luna://com.webos.settingsservice/setSystemSettings '{
  "category": "general",
  "settings": {
    "defaultApps": {
      "home": "com.webos.app.fullhome"
    }
  }
}'

# 4. Restart the compositor — try initctl, fall back to luna-send
initctl restart surface-manager 2>/dev/null || \
    luna-send -n 1 luna://com.webos.service.applicationManager/closeAllApps '{}'

echo "Done. Screen will go black for ~10-20 seconds."
sleep(10)
rm -rf /tmp/cursors/
