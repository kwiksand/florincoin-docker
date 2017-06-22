#!/bin/sh
set -e
cd /home/florincoin/florincoind

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for florincoind"

  set -- florincoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "florincoind" ]; then
  mkdir -p "$GAMECOIN_DATA"
  chmod 700 "$GAMECOIN_DATA"
  chown -R florincoin "$GAMECOIN_DATA"

  echo "$0: setting data directory to $GAMECOIN_DATA"

  set -- "$@" -datadir="$GAMECOIN_DATA"
fi

if [ "$1" = "florincoind" ] || [ "$1" = "florincoin-cli" ] || [ "$1" = "florincoin-tx" ]; then
  echo
  exec gosu florincoin "$@"
fi

echo
exec "$@"
