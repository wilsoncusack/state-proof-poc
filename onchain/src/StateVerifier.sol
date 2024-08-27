// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {RLPReader} from "Solidity-RLP/RLPReader.sol";
import {MerkleTrie} from "optimism/packages/contracts-bedrock/src/libraries/trie/MerkleTrie.sol";
import {SecureMerkleTrie} from "optimism/packages/contracts-bedrock/src/libraries/trie/SecureMerkleTrie.sol";
import {SSZ} from "eip-4788-proof/SSZ.sol";
import {console2} from "forge-std/Test.sol";

library StateVerifier {
    using RLPReader for RLPReader.RLPItem;
    using RLPReader for bytes;

    address private constant BEACON_ROOTS_ORACLE = 0x000F3df6D732807Ef1319fB7B8bB8522d0Beac02;
    uint256 private constant STATE_ROOT_GINDEX = 6434;

    struct StateProofParameters {
        bytes32 beaconRoot;
        uint256 beaconOracleTimestamp;
        bytes32 executionStateRoot;
        bytes32[] stateRootProof;
        bytes[] accountProof;
        bytes[] storageProof;
    }

    error BeaconRootDoesNotMatch(bytes32 expected, bytes32 actual);
    error BeaconRootsOracleCallFailed(bytes callData);
    error ExecutionStateRootMerkleProofFailed();
    error AccountProofVerificationFailed();
    error StorageProofVerificationFailed();

    function validateState(
        address account,
        bytes memory storageKey,
        bytes memory storageValue,
        StateProofParameters calldata proofParams
    ) internal view returns (bool) {
        _checkValidBeaconRoot(proofParams.beaconRoot, proofParams.beaconOracleTimestamp);
        _checkValidStateRoot(proofParams.beaconRoot, proofParams.executionStateRoot, proofParams.stateRootProof);

        console2.log('account');
        console2.log(account);
        // Verify account state
        bytes memory accountKey = abi.encodePacked(keccak256(abi.encodePacked(account)));
        bytes memory encodedAccount = _verifyAccountProof(accountKey, proofParams.accountProof, proofParams.executionStateRoot);
        
        // Extract storage root from account data
        bytes32 storageRoot = _extractStorageRoot(encodedAccount);
        console2.log('YYYY');
        console2.logBytes(storageKey);
        console2.logBytes32(storageRoot);
        console2.logBytes(abi.encodePacked(storageRoot));
        console2.logBytes32(storageRoot);
        bytes memory x = SecureMerkleTrie.get(storageKey, proofParams.storageProof, storageRoot);
        console2.log('xxxxxx');
        console2.logBytes(x);

        // Verify storage proof
        return _verifyStorageProof({
            storageKey: storageKey, 
            storageValue: storageValue, 
            storageRoot: storageRoot, 
            storageProof: proofParams.storageProof
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
        console2.logUint(STATE_ROOT_GINDEX);
        console2.logBytes32(beaconRoot);
        console2.logBytes32(executionStateRoot);

        if (!SSZ.verifyProof({proof: proof, root: beaconRoot, leaf: executionStateRoot, index: STATE_ROOT_GINDEX})) {
            revert ExecutionStateRootMerkleProofFailed();
        }
    }

    function _verifyAccountProof(bytes memory accountKey, bytes[] memory accountProof, bytes32 stateRoot) 
        private 
        pure 
        returns (bytes memory)
    {
        bytes memory encodedAccount = MerkleTrie.get(accountKey, accountProof, stateRoot);
        if (encodedAccount.length == 0) {
            revert AccountProofVerificationFailed();
        }
        return encodedAccount;
    }

    function _extractStorageRoot(bytes memory encodedAccount) private pure returns (bytes32) {
        RLPReader.RLPItem[] memory accountFields = encodedAccount.toRlpItem().toList();
        require(accountFields.length == 4, "Invalid account RLP");
        return bytes32(accountFields[2].toUint()); // storage root is the third field
    }

    function _verifyStorageProof(
        bytes memory storageKey,
        bytes memory storageValue,
        bytes32 storageRoot,
        bytes[] memory storageProof
    ) private pure returns (bool) {

        bool isValid = SecureMerkleTrie.verifyInclusionProof({
            _key: storageKey,
            _value: storageValue,
            _proof: storageProof,
            _root: storageRoot
        });

        if (!isValid) {
            revert StorageProofVerificationFailed();
        }

        return true;
    }
}