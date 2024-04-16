Proof of concept for using EIP-4788 beacon root oracle on L2 to prove L1 state. 

`/offchain` has code for generating inputs. `bun run index`
`/onchain` has contracts for onchain verification. `forge test -f https://mainnet.base.org  `