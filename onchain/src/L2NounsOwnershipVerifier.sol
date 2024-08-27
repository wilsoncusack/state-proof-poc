// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {StateVerifier} from "./StateVerifier.sol";
import {console2} from "forge-std/Test.sol";

contract L2NounsOwnershipVerifier {
    function isOwner(uint256 tokenId, address account, StateVerifier.StateProofParameters calldata proofParams)
        external
        view
        returns (bool)
    {
        console2.log("hi");
        console2.logBytes32(_getKey(tokenId));
        return StateVerifier.validateState({
            account: 0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03,
            storageKey: abi.encode(_getKey(tokenId)),
            storageValue: abi.encode(account),
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
