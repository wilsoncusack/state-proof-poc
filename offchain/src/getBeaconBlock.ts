const { ssz } = await import('@lodestar/types');
const { SignedBeaconBlock } = ssz.deneb;

const BEACON_API_URL = process.env.NODE || '';
const headers = {
    "Accept": "application/octet-stream",
}

export async function getBeaconBlock(tag: string) {
  console.log('log', BEACON_API_URL)
  console.log("!!!")
  const resp = await fetch(
      `${BEACON_API_URL}/eth/v2/beacon/blocks/${tag}`,
      { headers }
  );
  // if (resp.status == 404) throw new Error(`Missing block ${tag}`)
  if (resp.status != 200) throw new Error(`error fetching block ${tag}: ${await resp.text()}`)
  const raw = new Uint8Array(await resp.arrayBuffer());
  const signedBlock = SignedBeaconBlock.deserialize(raw);
  return signedBlock.message;
}