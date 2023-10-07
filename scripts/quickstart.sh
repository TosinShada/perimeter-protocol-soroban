#!/bin/bash

set -e

case "$1" in
standalone)
    echo "Using standalone network"
    ARGS="--standalone"
    ;;
futurenet)
    echo "Using Futurenet network"
    ARGS="--futurenet"
    ;;
*)
    echo "Usage: $0 standalone|futurenet"
    exit 1
    ;;
esac

# this is set to the quickstart `soroban-dev` image annointed as the release 
# for a given Soroban Release, it is captured on Soroban Releases - https://soroban.stellar.org/docs/reference/releases 
QUICKSTART_SOROBAN_DOCKER_SHA=stellar/quickstart:soroban-dev

shift

# Run the stellar quickstart image

docker run --rm -ti \
  --name stellar \
  --network soroban-network \
  -p 8000:8000 \
  "$QUICKSTART_SOROBAN_DOCKER_SHA" \
  $ARGS \
  --enable-soroban-rpc
