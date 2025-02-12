// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {LendingPool} from "../src/LendingPool.sol";
import {Factory} from "../src/Factory.sol";
import {WETHUSDCOracle} from "../src/WETHUSDCOracle.sol";

interface IOracle {
    function getPrice() external view returns (uint256);
}

contract LendingPoolTest is Test {
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    Factory public factory;
    IOracle public oracle;

    LendingPool public lendingPool1;
    LendingPool public lendingPool2;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/npJ88wr-vv5oxDKlp0mQYSfVXfN2nKif", 21197642);

        factory = new Factory();
        oracle = IOracle(address(new WETHUSDCOracle()));

        // collateral= WETH, debt= USDC, LTV 70%, oracle= WETHUSDCOracle
        address lendingPool1Address = factory.createLendingPool(weth, usdc, address(oracle), 7e17);
        // address lendingPool2Address = factory.createLendingPool(usdc, weth, address(oracle), 7e17);

        lendingPool1 = LendingPool(lendingPool1Address);
        // lendingPool2 = LendingPool(lendingPool2Address);

        deal(usdc, alice, 1000e6);
        deal(weth, bob, 1e18);
    }

    function test_oracle() public {
        uint256 price = oracle.getPrice();
        console.log("price", price);
    }

    function test_borrow() public {
        // alice supply 1000 usdc
        vm.startPrank(alice);
        IERC20(usdc).approve(address(lendingPool1), 1000e6);
        lendingPool1.supply(1000e6);
        vm.stopPrank();

        vm.startPrank(bob);

        // bob supply 1 WETH as collateral
        IERC20(weth).approve(address(lendingPool1), 1e18);
        lendingPool1.supplyCollateral(1e18);

        vm.expectRevert(LendingPool.InsufficientCollateral.selector);
        lendingPool1.borrow(10_000e6);

        // bob borrow  usdc
        // vm.expectRevert(LendingPool.InsufficientCollateral.selector);
        lendingPool1.borrow(900e6);

        // bob withdraw collateral
        // vm.expectRevert();
        lendingPool1.withdrawCollateral(1e18 / 2);

        vm.stopPrank();
    }

    function test_withdraw() public {
        vm.startPrank(alice);
        IERC20(usdc).approve(address(lendingPool1), 1000e6);
        lendingPool1.supply(1000e6);

        // zero Amount
        vm.expectRevert(LendingPool.ZeroAmount.selector);
        lendingPool1.withdraw(0);

        // insufficient shares
        vm.expectRevert(LendingPool.InsufficientShares.selector);
        lendingPool1.withdraw(10_000e6);

        vm.stopPrank();

        vm.startPrank(bob);
        IERC20(weth).approve(address(lendingPool1), 1e18);
        lendingPool1.supplyCollateral(1e18);
        lendingPool1.borrow(500e6);

        console.log("total supply assets before", lendingPool1.totalSupplyAssets());
        console.log("total borrow assets before", lendingPool1.totalBorrowAssets());

        vm.warp(block.timestamp + 365 days);
        lendingPool1.accureInterest();
        vm.stopPrank();

        vm.startPrank(alice);
        vm.expectRevert(LendingPool.InsufficientLiquidity.selector);
        lendingPool1.withdraw(1000e6);
        vm.stopPrank();
    }

    function helper_supply_borrow() public {
        vm.startPrank(alice);
        IERC20(usdc).approve(address(lendingPool1), 1000e6);
        lendingPool1.supply(1000e6);
        vm.stopPrank();

        vm.startPrank(bob);
        IERC20(weth).approve(address(lendingPool1), 1e18);
        lendingPool1.supplyCollateral(1e18);
        lendingPool1.borrow(500e6);
        vm.warp(block.timestamp + 365 days);
        lendingPool1.accureInterest();
        vm.stopPrank();
    }

    function test_repay() public {
        helper_supply_borrow();

        console.log("balance bob usdc", IERC20(usdc).balanceOf(bob));
        console.log("total supply assets before", lendingPool1.totalSupplyAssets());
        console.log("total borrow assets before", lendingPool1.totalBorrowAssets());
        console.log("total borrow shares before", lendingPool1.totalBorrowShares()); // 500e6
        console.log("user borrow shares before", lendingPool1.userBorrowShares(bob)); // 500e6

        vm.startPrank(bob);
        IERC20(usdc).approve(address(lendingPool1), 500e6);
        lendingPool1.repay(454e6); // 499
        vm.stopPrank();

        console.log("total supply assets after repay", lendingPool1.totalSupplyAssets()); // no changes
        console.log("total borrow assets after repay", lendingPool1.totalBorrowAssets()); // 110e6
        console.log("total borrow shares after repay", lendingPool1.totalBorrowShares()); // 100e6
        console.log("user borrow shares after repay", lendingPool1.userBorrowShares(bob)); // 100e6

        deal(usdc, bob, 300e6);

        vm.startPrank(bob);
        IERC20(usdc).approve(address(lendingPool1), 300e6);
        lendingPool1.repay(46e6); // 440
        vm.stopPrank();

        console.log("total supply assets after repay 2", lendingPool1.totalSupplyAssets()); // no changes
        console.log("total borrow assets after repay 2", lendingPool1.totalBorrowAssets()); // 110e6
        console.log("total borrow shares after repay 2", lendingPool1.totalBorrowShares()); // 100e6
        console.log("user borrow shares after repay 2", lendingPool1.userBorrowShares(bob)); // 100e6
        console.log("bob balance", IERC20(usdc).balanceOf(bob));
    }
}
