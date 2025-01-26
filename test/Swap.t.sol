// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Swap} from "../src/Swap.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; // setiap interaksi dengan token harus ada ierc

contract SwapTest is Test {
    Swap public swap;

    address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function setUp() public {
        //  vm.createSelectFork(RPC URL, BLOCK di lokasi mana) = kenapa pakai block tertentu, supaya test nya cepet
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI", 21699818);
        // deploy swap
        swap = new Swap();
    }

    function test_swap() public {
        deal(usdc, address(this), 100e6);
        IERC20(usdc).approve(address(swap), 100e6);
        swap.swap(100e6, 100);
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(this)));
        // console.log(swap.balanceOf(address(this)));
    }
}

// 3 user
// 1. wallet(user)
// 2. swap
// 3. uniswap

// brarti kalau uniswap harganya otomatis tergenerate?

// contract swap ambil saldo di wallet,
// approve, supaya wallet kita menyetujui agar duit kita diambil
// transferFrom, supaya wallet kita bisa transfer ke swap

// manipulasi uang menggunakan deal()
