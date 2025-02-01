// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {LendingPool} from "./LendingPool.sol";

contract LendingPoolFactory {
    function createLendingPool(
        // address LendingPoolToken0,
        address LendingPoolToken1,
        address LendingPoolToken2
    ) public returns (address) {
        LendingPool lendingPool = new LendingPool(
            // LendingPoolToken0,
            LendingPoolToken1,
            LendingPoolToken2
        );
        return address(lendingPool);
    }
}
