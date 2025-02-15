// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MemeToken} from "../src/MemeToken.sol";

contract MemeTokenScript is Script {
    MemeToken public memeToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("DEPLOYER_WALLET_PRIVATE_KEY"));

        memeToken = new MemeToken("Nama Sembarang", "EFISIENSI");

        console.log("contract deployed to", address(memeToken));

        vm.stopBroadcast();
    }
}
