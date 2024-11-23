# Only one single output remains unspent from block 123,321. What address was it sent to?

bitcoin-cli getblockhash 123321 |
  xargs -I {} bitcoin-cli getblock {} 2 |
  jq -rc '.tx[] | .txid as $txid | (.vout[] | {txid: $txid, n: .n}) | "\(.txid) \(.n)"' |
  while read -r id index; do
    res=$(bitcoin-cli gettxout "$id" "$index")
    if [[ -n "$res" ]]; then
      address=$(echo "$res" | jq -rc '.scriptPubKey.address')
      echo "$address"
      exit 0
    fi
  done
