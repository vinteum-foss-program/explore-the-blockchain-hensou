# Which tx in block 257,343 spends the coinbase output of block 256,128?

txid=$(bitcoin-cli getblockhash 256128 | xargs bitcoin-cli getblock | jq -r .tx[0])

transactions_to_search=($(bitcoin-cli getblockhash 257343 | xargs bitcoin-cli getblock | jq -rc .tx[]))

for tx in "${transactions_to_search[@]}"; do
  result=$(bitcoin-cli getrawtransaction "$tx" | xargs bitcoin-cli decoderawtransaction | jq "any(.vin[]; .txid == \"$txid\")")
  if $result; then
    echo "$tx"
    exit 0
  fi
done

exit 1
