// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {L1StateVerifier} from "./L1StateVerifier.sol";

contract L2NounsOwnershipVerifier {
    function isOwner(uint256 tokenId, address account, L1StateVerifier.StateProofParameters calldata proofParams)
        external
        view
        returns (bool)
    {
        return L1StateVerifier.validateL1State({
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
