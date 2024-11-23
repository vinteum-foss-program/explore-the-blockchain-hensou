#!/usr/bin/env bash
bitcoin-cli getblockstats 123456 | jq ".outs"
