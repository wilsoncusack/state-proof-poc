// // import { sleep } from "bun";
// // import { createPublicClient, http, type Address, encodeAbiParameters, toHex, keccak256, type Hex, sha256, hexToBytes } from "viem";
// // import { base } from "viem/chains";
// // // import {ValueOf, ContainerType, ByteVectorType} from "@chainsafe/ssz";

// import { bytesToHex, createPublicClient, encodePacked, http, keccak256, type Address, type Block, type Hex, type Chain, type PublicClient } from 'viem';
// import { getBlock, getProof } from 'viem/actions';
// import { base, mainnet } from 'viem/chains';

// // const { ssz } = await import('@lodestar/types');
// //     const { createProof, ProofType } = await import('@chainsafe/persistent-merkle-tree');
// //     const { BeaconBlock, BeaconState, SignedBeaconBlock, LightClientHeader } = ssz.deneb;


// // // 0xaf33296672567a8588cfd7691b7ea1c503684889760dd3e9b05b33034f68415b


// // const header  = {
// //   slot: BigInt("8858959"),
// //   proposer_index: BigInt("70719"),
// //   parent_root: hexToBytes("0xf7e0ce4ca00d86d6e978c317216e2912d9be2aea101668c224151ad65608026d"),
// //   state_root: hexToBytes("0xc1abd35aaeb3668026f92363e60d2e02adca4adad5f74909ebe4d118c253b506"),
// //   body_root: hexToBytes("0x4a9a1296711318547b99e4cd2d8b3133a85a68b37d72550ba5e27482e1738fca"),
// // };
// // // LightClientHeader.serialize(header)
// // BeaconBlock.to


// // console.log(keccak256(
// //   encodeAbiParameters(
// //     [{type: 'uint256'}, {type: 'uint256'}, {type: 'bytes32'}, {type: 'bytes32'}, {type: 'bytes32'}],
// //     [BigInt(header.slot), BigInt(header.proposer_index), header.parent_root as Hex, header.state_root as Hex, header.body_root as Hex]
// //     )
// // ))

// // console.log(sha256(
// //   encodeAbiParameters(
// //     [{type: 'uint256'}, {type: 'uint256'}, {type: 'bytes32'}, {type: 'bytes32'}, {type: 'bytes32'}],
// //     [BigInt(header.slot), BigInt(header.proposer_index), header.parent_root as Hex, header.state_root as Hex, header.body_root as Hex]
// //     )
// // ))


// ///
// // console.log("Hello via Bun!");



// // const headerResponse = await fetch("http://testing.mainnet.beacon-api.nimbus.team/eth/v1/beacon/headers", {
// //   method: "GET",
// //   headers: { "Content-Type": "application/json" },
// // });

// // const headerResponseBody = await headerResponse.json();
// // const header = headerResponseBody.data[0].header.message
// // console.log(header)



// const blockResponse = await fetch(`http://testing.mainnet.beacon-api.nimbus.team/eth/v2/beacon/blocks/${block.parentBeaconBlockRoot}`, {
//   method: "GET",
//   headers: { "Content-Type": "application/json" },
// });

// const blockResponseBody = await blockResponse.json();
// const actualTimestamp = BigInt(blockResponseBody.data.message.body.execution_payload.timestamp)
// const l2OffsetSeconds = 200
// const timestampForL2Oracle = actualTimestamp + BigInt(l2OffsetSeconds)
// console.log(blockResponseBody.data)
// console.log(`block timestamp ${actualTimestamp}`)
// console.log(`timestamp for l2 beacon root oracle ${timestampForL2Oracle}`)
// // const client = createPublicClient({
// //   chain: base,
// //   transport: http()
// // })

// // await sleep(l2OffsetSeconds * 1000)

// // const BEACON_ROOTS_ADDRESS = '0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02' as Address
// // console.log(encodeAbiParameters([{type: 'bytes32'}], [toHex(timestampForL2Oracle, {size: 32})]));
// // const res = await client.call({
// //   to: BEACON_ROOTS_ADDRESS,
// //   data: encodeAbiParameters([{type: 'bytes32'}], [toHex(timestampForL2Oracle, {size: 32})])
// // })
// // console.log(`Block root from L2 oracle ${res}`)

// // // get proof
// // // submit proof on L2 

// ///

// const client = createPublicClient({
//   chain: mainnet,
//   transport: http()
// })

// async function main() {
  

//   class MissingBlock { }

//   async function getBlock(tag: string) {
//       const resp = await fetch(
//           `${BEACON_API_URL}/eth/v2/beacon/blocks/${tag}`,
//           { headers }
//       );
//       if (resp.status == 404) throw new MissingBlock()
//       if (resp.status != 200) throw new Error(`error fetching block ${tag}: ${await resp.text()}`)
//       const raw = new Uint8Array(await resp.arrayBuffer());
//       const signedBlock = SignedBeaconBlock.deserialize(raw);
//       return signedBlock.message;
//   }

//   const block: Sign = await getBlock("finalized");
//   console.log(block.slot)
//   const blockView = BeaconBlock.toView(block);
//   console.log(bytesToHex(blockView.hashTreeRoot()));
//   // console.log(blockView.stateRoot)
//   console.log(bytesToHex(blockView.body.executionPayload.stateRoot))
//   const path = blockView.type.getPathInfo(['body', 'executionPayload', 'stateRoot']);
//   const proof = createProof(blockView.node, { type: ProofType.single, gindex: path.gindex });
//   console.log(proof)
//   console.log(proof)

  // const noun = BigInt(256);
  // const ownerMappingSlot = BigInt(3);
  // const slot = keccak256(encodePacked(['uint256', 'uin256'], [noun, ownerMappingSlot]))
  // getProof(client, {
  //   address: '0x9c8ff314c9bc7f6e59a9d9225fb22946427edc03' as Address, // nouns token
  //   storageKeys: [slot]
  // })

//   // get proof about storage state 

//   /// proof is a SSZ merkle proof from the blockRoot to the ExecutionPayload root
// }

// // main()

// // const noun = BigInt(256);
// //   const ownerMappingSlot = BigInt(3);
// //   const slot = keccak256(encodePacked(['uint256', 'uint256'], [noun, ownerMappingSlot]))
// // const proof = await getProof(client, {
// //     address: '0x9c8ff314c9bc7f6e59a9d9225fb22946427edc03' as Address, // nouns token
// //     storageKeys: [slot]
// //   })

//   // console.log(proof.storageProof)



// const { ssz } = await import('@lodestar/types');
// const { createProof, ProofType } = await import('@chainsafe/persistent-merkle-tree');
// const { BeaconBlock, BeaconState, SignedBeaconBlock } = ssz.deneb;

// const BEACON_API_URL = 'http://testing.mainnet.beacon-api.nimbus.team';
// const headers = {
//     "Accept": "application/octet-stream",
// }


// async function getBeaconBlock(tag: string) {
//   const resp = await fetch(
//       `${BEACON_API_URL}/eth/v2/beacon/blocks/${tag}`,
//       { headers }
//   );
//   if (resp.status == 404) throw new Error("Missing block")
//   if (resp.status != 200) throw new Error(`error fetching block ${tag}: ${await resp.text()}`)
//   const raw = new Uint8Array(await resp.arrayBuffer());
//   const signedBlock = SignedBeaconBlock.deserialize(raw);
//   return signedBlock.message;
// }