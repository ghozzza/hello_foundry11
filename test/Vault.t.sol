// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {TokenRupiah} from "../src/TokenRupiah.sol";

contract VaultTest is Test {
    TokenRupiah public tokenRupiah;
    Vault public vault;

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public carol = makeAddr("carol");
    address public david = makeAddr("david");

    function setUp() public {
        // deploy vault
        tokenRupiah = new TokenRupiah();
        vault = new Vault(address(tokenRupiah));

        // TokenRupiah
        tokenRupiah.mint(alice, 1_000_000e6);
        tokenRupiah.mint(bob, 1_000_000e6);
        tokenRupiah.mint(carol, 2_000_000e6);
        tokenRupiah.mint(david, 5_000_000e6);
        tokenRupiah.mint(address(this), 2_000_000e6);
    }

    function test_scenario_1() public {
        vm.startPrank(alice);
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.deposit(1_000_000e6);
        vm.stopPrank();

        vm.startPrank(bob);
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.deposit(1_000_000e6);
        vm.stopPrank();

        // distribute yield
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.distributeYield(1_000_000e6);

        // alice withdraw
        uint256 aliceBalanceBefore = tokenRupiah.balanceOf(alice);
        console.log("Alice balance before: ", aliceBalanceBefore);
        vm.startPrank(alice);
        uint256 aliceShares = vault.balanceOf(alice);
        vault.withdraw(aliceShares);
        vm.stopPrank();
        uint256 aliceBalanceAfter = tokenRupiah.balanceOf(alice);
        console.log("Alice balance after: ", aliceBalanceAfter);

        vm.startPrank(carol);
        tokenRupiah.approve(address(vault), 2_000_000e6);
        vault.deposit(2_000_000e6);
        vm.stopPrank();

        // distribute yield
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.distributeYield(1_000_000e6);
    }

    function test_deposit_amount_should_not_zero() public {
        vm.expectRevert(Vault.AmountCannotBeZero.selector);
        vault.deposit(0);
    }

    function test_withdraw_shares_cannot_more_than_balance() public {
        vm.startPrank(alice);
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.deposit(1_000_000e6);
        vm.stopPrank();

        vm.startPrank(bob);
        tokenRupiah.approve(address(vault), 1_000_000e6);
        vault.deposit(1_000_000e6);
        vm.stopPrank();

        vm.expectRevert(Vault.SharesCannotBeMoreThanBalance.selector);
        vm.startPrank(alice);
        vault.withdraw(2_000_000e6);
    }
}
