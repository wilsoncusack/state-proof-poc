// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {L2NounsOwnershipVerifier} from "../src/L2NounsOwnershipVerifier.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new L2NounsOwnershipVerifier();
    }
}
