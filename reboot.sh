#!/bin/sh

luna-send -n -f luna://com.webos.settingsservice/setSystemSettings '{
  "category": "general",
  "settings": {
    "defaultApps": {
      "home": "com.webos.app.home"
    }
  }
}'

reboot
