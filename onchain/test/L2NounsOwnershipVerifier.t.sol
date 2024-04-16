// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/StdJson.sol";

import {StateVerifier} from "../src/StateVerifier.sol";
import {L2NounsOwnershipVerifier} from "../src/L2NounsOwnershipVerifier.sol";
import {MerkleTree} from "relic-contracts/lib/MerkleTree.sol";

contract L2NounsOwnershipVerifierTest is Test {
    using stdJson for string;

    L2NounsOwnershipVerifier verifier = new L2NounsOwnershipVerifier();

    function test() public {
        string memory rootPath = vm.projectRoot();
        string memory path = string.concat(rootPath, "/test/data.json");
        string memory json = vm.readFile(path);

        StateVerifier.StateProofParameters memory params = StateVerifier.StateProofParameters({
            beaconRoot: json.readBytes32(".beaconRoot"),
            beaconOracleTimestamp: uint256(json.readBytes32(".beaconOracleTimestamp")),
            executionStateRoot: json.readBytes32(".executionStateRoot"),
            stateRootProof: abi.decode(json.parseRaw(".stateRootProof"), (bytes32[])),
            storageProof: abi.decode(json.parseRaw(".storageProof"), (bytes[]))
        });
        verifier.isOwner(256, 0x44d97D22B3d37d837cE4b22773aAd9d1566055D9, params);
        console2.logBytes32(MerkleTree.computeRoot(params.stateRootProof));
    }
}
