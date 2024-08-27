// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/StdJson.sol";

import {StateVerifier} from "../src/StateVerifier.sol";
import {L2NounsOwnershipVerifier} from "../src/L2NounsOwnershipVerifier.sol";
import {MerkleTree} from "relic-contracts/lib/MerkleTree.sol";

contract L2NounsOwnershipVerifierTest is Test {
    using stdJson for string;

    

    function test() public {
        vm.createSelectFork("https://mainnet.base.org");
        L2NounsOwnershipVerifier verifier = new L2NounsOwnershipVerifier();
        string memory rootPath = vm.projectRoot();
        string memory path = string.concat(rootPath, "/test/data.json");
        string memory json = vm.readFile(path);

        StateVerifier.StateProofParameters memory params = StateVerifier.StateProofParameters({
            beaconRoot: json.readBytes32(".beaconRoot"),
            beaconOracleTimestamp: uint256(json.readBytes32(".beaconOracleTimestamp")),
            executionStateRoot: json.readBytes32(".executionStateRoot"),
            stateRootProof: abi.decode(json.parseRaw(".stateRootProof"), (bytes32[])),
            storageProof: abi.decode(json.parseRaw(".storageProof"), (bytes[])),
            accountProof: abi.decode(json.parseRaw(".accountProof"), (bytes[]))
        });
        verifier.isOwner(256, 0xb1a32FC9F9D8b2cf86C068Cae13108809547ef71, params);
        console2.logBytes32(MerkleTree.computeRoot(params.stateRootProof));
    }
}
