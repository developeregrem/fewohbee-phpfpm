#!/bin/sh
set -e

if [ -d /opt/cron ]; then
  for src in /opt/cron/*; do
    [ -f "$src" ] || continue
    dest="/etc/crontabs/$(basename "$src")"
    cp "$src" "$dest"
    chown root:root "$dest"
    chmod 600 "$dest"
  done
fi

exec "$@"
