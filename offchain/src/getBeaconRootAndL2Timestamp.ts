import type { Block, Hex, PublicClient } from "viem"

type L2Block = Block & {parentBeaconBlockRoot: Hex}

type GetBeaconRootAndL2TimestampReturnType = {
  beaconRoot: Hex, 
  timestampForL2BeaconOracle: bigint
}

export async function getBeaconRootAndL2Timestamp(l2ChainPublicClient: PublicClient) : Promise<GetBeaconRootAndL2TimestampReturnType>{
  const block = (await l2ChainPublicClient.getBlock()) as L2Block
  return {beaconRoot: block.parentBeaconBlockRoot, timestampForL2BeaconOracle: block.timestamp}
}