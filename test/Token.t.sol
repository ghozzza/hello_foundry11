// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token public token;

    function setUp() public {
        // deploy token
        token = new Token();
    }

    function test_mint() public {
        token.mint(address(this), 1000);
        assertEq(token.balanceOf(address(this)), 1000);
    }

    function test_mint_max_supply() public {
        vm.expectRevert("Max supply exceeded");
        token.mint(address(this), 10000000000);
    }

    // function test_balance() public view {
    //     console.log("total supply: ", token.MAX_TOTAL_SUPPLY());
    //     console.log("balance:", token.balanceOf(address(this)));
    //     assertEq(token.balanceOf(address(this)), 1000);
    // }


}
