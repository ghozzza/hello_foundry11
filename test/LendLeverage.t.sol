// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LendLeverage} from "../src/LendLeverage.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; // setiap interaksi dengan token harus ada ierc

contract LendLeverageTest is Test {
    LendLeverage public lendLeverage;

    address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public pool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function setUp() public {
        //  vm.createSelectFork(RPC URL, BLOCK di lokasi mana) = kenapa pakai block tertentu, supaya test nya cepet
        // vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/Ea4M-V84UObD22z2nNlwDD9qP8eqZuSI", 21699818);
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/npJ88wr-vv5oxDKlp0mQYSfVXfN2nKif", 21699818);
        // deploy lendLeverage
        lendLeverage = new LendLeverage();
    }

    function test_lendLeverage() public {
        // deal(wbtc, address(this), 1e8);
        // IERC20(wbtc).approve(address(lendLeverage), 1e8);
        // lendLeverage.leverage(1e8, 100);
        deal(wbtc, address(this), 1e8);
        IERC20(wbtc).approve(address(lendLeverage), 1e8);
        lendLeverage.leverage(1e8, 50_000e6);
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(this)));
        console.log("WBTC Balance: ", IERC20(wbtc).balanceOf(address(pool)));
    }
}

// 3 user
// 1. wallet(user)
// 2. lendLeverage
// 3. unilendLeverage

// brarti kalau unilendLeverage harganya otomatis tergenerate?

// contract lendLeverage ambil saldo di wallet,
// approve, supaya wallet kita menyetujui agar duit kita diambil
// transferFrom, supaya wallet kita bisa transfer ke lendLeverage

// manipulasi uang menggunakan deal()
