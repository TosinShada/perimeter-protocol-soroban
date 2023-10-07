#!/bin/bash

set -e

ADMIN_ADDRESS="$(soroban config identity address token-admin)"
SOROBAN_RPC_HOST="https://rpc-futurenet.stellar.org:443"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST"
SOROBAN_NETWORK_PASSPHRASE="Test SDF Future Network ; October 2022"
FRIENDBOT_URL="https://friendbot-futurenet.stellar.org/"
NETWORK="futurenet"
SNS_REGISTRY_ID="$(cat ./.sns-dapp/sns_registry_id)"
SNS_REGISTRAR_ID="$(cat ./.sns-dapp/sns_registrar_id)"
SNS_RESOLVER_ID="$(cat ./.sns-dapp/sns_resolver_id)"

echo "Using $NETWORK network"
echo "  RPC URL: $SOROBAN_RPC_URL"
echo "  Friendbot URL: $FRIENDBOT_URL"

echo Add the $NETWORK network to cli client

ARGS="--network $NETWORK --source token-admin"

echo "Initialize the registry contract"
soroban contract invoke \
  $ARGS \
  --id "$SNS_REGISTRY_ID" \
  -- \
  initialize \
  --admin "$SNS_REGISTRAR_ID" \
  --resolver "$SNS_RESOLVER_ID"

echo "Initialize the resolver contract"
soroban contract invoke \
  $ARGS \
  --id "$SNS_RESOLVER_ID" \
  -- \
  initialize \
  --admin "$SNS_REGISTRAR_ID"

## Base node is the SHA256 hash of the string "sns" 
echo "Initialize the registrar contract"
soroban contract invoke \
  $ARGS \
  --id "$SNS_REGISTRAR_ID" \
  -- \
  initialize \
  --registry "$SNS_REGISTRY_ID" \
  --admin "$ADMIN_ADDRESS" \
  --resolver "$SNS_RESOLVER_ID" \
  --base_node b018ed7bff94dbb0ed23e266a3c6ca9d1a1739737db49ec48ea1980b9db0ad46 \
  --native_token CB64D3G7SM2RTH6JSGG34DDTFTQ5CFDKVDZJZSODMCX4NJ2HV2KN7OHT

echo "Register a new SNS"
soroban contract invoke \
  $ARGS \
  --id "$SNS_REGISTRAR_ID" \
  -- \
  register \
  --caller "$ADMIN_ADDRESS" \
  --owner "$ADMIN_ADDRESS" \
  --name 67741aa8c74ef6ef3c1449cb2c42753aa69817f7019950eee67ea9a5ecf1fa0c \
  --address_name "$ADMIN_ADDRESS" \
  --duration 31536000 

echo "Done"