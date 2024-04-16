// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {StateVerifier} from "./StateVerifier.sol";

contract L2NounsOwnershipVerifier {
    function isOwner(uint256 tokenId, address account, StateVerifier.StateProofParameters calldata proofParams)
        external
        view
        returns (bool)
    {
        return StateVerifier.validateState({
            key: abi.encode(_getKey(tokenId)),
            value: abi.encode(account),
            proofParams: proofParams
        });
    }

    function _getKey(uint256 tokenId) private pure returns (bytes32) {
        return keccak256(
            abi.encode(
                tokenId,
                3 // _owner slot
            )
        );
    }
}
