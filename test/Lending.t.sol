// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Lending} from "../src/Lending.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; // setiap interaksi dengan token harus ada ierc

contract LendingTest is Test {
    Lending public lending;

    address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function setUp() public {
        //  vm.createSelectFork(RPC URL, BLOCK di lokasi mana) = kenapa pakai block tertentu, supaya test nya cepet
        vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/npJ88wr-vv5oxDKlp0mQYSfVXfN2nKif", 21699818);
        // deploy lending
        lending = new Lending();
    }

    function test_lending() public {
        deal(wbtc, address(this), 1e8);
        IERC20(wbtc).approve(address(lending), 1e8);
        lending.supplyAndBorrow(1e8, 1000e6);
        console.log("USDC Balance: ", IERC20(usdc).balanceOf(address(this)));
    }
}

// 3 user
// 1. wallet(user)
// 2. lending
// 3. unilending

// brarti kalau unilending harganya otomatis tergenerate?

// contract lending ambil saldo di wallet,
// approve, supaya wallet kita menyetujui agar duit kita diambil
// transferFrom, supaya wallet kita bisa transfer ke lending

// manipulasi uang menggunakan deal()
