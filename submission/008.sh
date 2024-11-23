# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 2 |
  jq -rc '.vin[0].txinwitness[2]' |
  xargs bitcoin-cli decodescript |
  jq -rc '.asm' |
  awk '/OP_IF/ {print $2}'
