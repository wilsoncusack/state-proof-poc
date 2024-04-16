// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {MerkleTrie} from "optimism/packages/contracts-bedrock/src/libraries/trie/MerkleTrie.sol";
import {MerkleProof} from "openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {MerkleTree} from "relic-contracts/lib/MerkleTree.sol";

library StateVerifier {
    address private constant BEACON_ROOTS_ORACLE = 0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02;

    struct StateProofParameters {
        // The root of the L1 beacon block being used for the proof.
        bytes32 beaconRoot;
        // The timestamp that can be passed to the beacon oracle, should return `beaconRoot`.
        uint256 beaconOracleTimestamp;
        // block.body.executionPayload.stateRoot of the beacon block.
        bytes32 executionStateRoot;
        // Proof that executionStateRoot is a leaf in the merkle tree for which beaconRoot is the root.
        bytes32[] stateRootProof;
        // The storage proof to be used with executionStateRoot.
        bytes[] storageProof;
    }

    error BeaconRootDoesNotMatch(bytes32 expected, bytes32 actual);
    error BeaconRootsOracleCallFailed(bytes callData);
    error ExecutionStateRootMerkleProofFailed();

    /// @notice Uses the EIP-4788 Beacon Root Oracle, which on OP Stack L2 exposes L1 Beacon roots,
    /// to validate L1 state on L2.
    ///
    /// @param key The storage slot at which the value is set, i.e. keccak256(abi.encode(mappingKey, slotIndex));
    /// @param value The value at key
    /// @param proofParams The StateProofParameters needed for this proof.
    function validateState(bytes memory key, bytes memory value, StateProofParameters calldata proofParams)
        internal
        view
        returns (bool)
    {
        _checkValidBeaconRoot(proofParams.beaconRoot, proofParams.beaconOracleTimestamp);

        _checkValidStateRoot(proofParams.beaconRoot, proofParams.executionStateRoot, proofParams.stateRootProof);

        return MerkleTrie.verifyInclusionProof({
            _key: key,
            _value: value,
            _proof: proofParams.storageProof,
            _root: proofParams.executionStateRoot
        });
    }

    function _checkValidBeaconRoot(bytes32 root, uint256 timestamp) private view {
        (bool success, bytes memory result) = BEACON_ROOTS_ORACLE.staticcall(abi.encode(timestamp));
        if (!success) {
            revert BeaconRootsOracleCallFailed(abi.encode(timestamp));
        }

        bytes32 resultRoot = abi.decode(result, (bytes32));

        if (resultRoot != root) {
            revert BeaconRootDoesNotMatch({expected: root, actual: resultRoot});
        }
    }

    function _checkValidStateRoot(bytes32 beaconRoot, bytes32 executionStateRoot, bytes32[] calldata proof)
        private
        view
    {
        if (!MerkleTree.validProof({proofHashes: proof, rootHash: beaconRoot, hash: executionStateRoot, index: 7})) {
            revert ExecutionStateRootMerkleProofFailed();
        }
    }
}
