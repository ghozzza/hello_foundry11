// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
// import {LendingPool} from "../src/LendingPool.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; // setiap interaksi dengan token harus ada ierc

contract LendingPoolTest is Test {
    LendingPool public lendingPool;

    address public pool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function setUp() public {
        //  vm.createSelectFork(RPC URL, BLOCK di lokasi mana) = kenapa pakai block tertentu, supaya test nya cepet
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/npJ88wr-vv5oxDKlp0mQYSfVXfN2nKif", 21699818);
        // deploy lendingPool
        lendingPool = new LendingPool();
    }

    function test_supplyCollateral() public {
        deal(wbtc, address(this), 1e8);
        IERC20(wbtc).approve(address(lendingPool), 1e8);

        deal(usdc, address(this), 1000e6);
        IERC20(usdc).approve(address(lendingPool), 1000e6);
        lendingPool.supplyCollateral(1e8, 1000e6);

        (address token, uint256 amountBTC) = lendingPool.totalUserSupply(address(this), 0);

        console.log("total WBTC Supply:", lendingPool.totalSupply(wbtc));
        console.log("total USDC Supply:", lendingPool.totalSupply(usdc));
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(this)));
        console.log("USDC Balance: ", IERC20(usdc).balanceOf(address(this)));
        console.log("Token: ", token);
        console.log("User WBTC Supply: ", amountBTC);
    }

    function test_borrowUSDC() public {
        deal(wbtc, address(this), 1e8);
        IERC20(wbtc).approve(address(lendingPool), 1e8);

        lendingPool.supplyCollateral(1e8, 0);

        lendingPool.borrow(1000e6, usdc);

        (address token, uint256 amountBTC) = lendingPool.totalUserSupply(address(this), 0);

        console.log("total WBTC Supply:", lendingPool.totalSupply(wbtc));
        console.log("total USDC Supply:", lendingPool.totalSupply(usdc));
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(this)));
        console.log("USDC Balance: ", IERC20(usdc).balanceOf(address(this)));
        console.log("Token: ", token);
        console.log("User WBTC Supply: ", amountBTC);
    }
    function test_borrowWBTC() public {
        deal(wbtc, address(this), 1e8);
        IERC20(wbtc).approve(address(lendingPool), 1e8);

        lendingPool.supplyCollateral(1e8, 0);

        lendingPool.borrow(1e6, wbtc);

        (address token, uint256 amountBTC) = lendingPool.totalUserSupply(address(this), 0);

        console.log("total WBTC Supply:", lendingPool.totalSupply(wbtc));
        console.log("total USDC Supply:", lendingPool.totalSupply(usdc));
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(this)));
        console.log("USDC Balance: ", IERC20(usdc).balanceOf(address(this)));
        console.log("Token: ", token);
        console.log("User WBTC Supply: ", amountBTC);
    }
}
