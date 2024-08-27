Proof of concept for using EIP-4788 beacon root oracle on L2 to prove L1 state. In this case, proving 
Noun ownership on L2. 

`/offchain` has code for generating inputs. `bun run index`. You will need to supply a beacon node URL in `.env`. `NODE=....`.

`/onchain` has contracts for onchain verification. `forge test`

> [!WARNING]  
> This code has not been audited. Use at your own risk.
