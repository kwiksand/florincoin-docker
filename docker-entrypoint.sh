#!/bin/sh
set -e
cd /home/florincoin/florincoind
FLORINCOIN_DATA=/home/florincoin/.florincoin

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for florincoind"

  set -- florincoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "florincoind" ]; then
  mkdir -p "$FLORINCOIN_DATA"
  chmod 700 "$FLORINCOIN_DATA"
  chown -R florincoin "$FLORINCOIN_DATA"

  echo "$0: setting data directory to $FLORINCOIN_DATA"

  set -- "$@" -datadir="$FLORINCOIN_DATA"
fi

if [ "$1" = "florincoind" ] || [ "$1" = "florincoin-cli" ] || [ "$1" = "florincoin-tx" ]; then
  echo
  exec gosu florincoin "$@"
fi

echo
exec "$@"
