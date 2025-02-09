// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {LendingPool} from "./LendingPool.sol";

contract Position {
    // uint256 public totalSupplyAssets;
    // uint256 public totalSupplyShares;
    // uint256 public totalBorrowAssets;
    // uint256 public totalBorrowShares;

    // mapping(address => uint256) public userSupplyShares;
    // mapping(address => uint256) public userBorrowShares;
    // mapping(address => uint256) public userCollaterals;

    // uint256 supp0;
    uint256 public supp1;

    // address collateral0;
    address public collateral1;
    address public borrowAssets;
    address public owner;
    // uint256 lastAccrued;

    constructor(
        // address _collateral0,
        address _collateral1,
        address _borrow
    ) {
        // collateral0 = _collateral0;
        collateral1 = _collateral1;
        borrowAssets = _borrow;
        owner = msg.sender;
    }

    // function supplyCollateral(uint256 amount0, uint256 amount1) public {
    //     lendingPool.accrueInterest();

    //     IERC20(collateral0).transferFrom(msg.sender, address(this), amount0);
    //     IERC20(collateral1).transferFrom(msg.sender, address(this), amount1);

    //     lendingPool.userCollaterals[msg.sender] += amount;
    // }

    // function withdrawCollateral(uint256 amount0, uint256 amount1) public {
    //     require(lendingPool.userCollaterals[msg.sender] >= amount, "insufficient collateral");
    //     require(lendingPool.userBorrowShares[msg.sender] == 0, "cannot withdraw while borrowing");

    //     lendingPool.accrueInterest();

    //     IERC20(collateral0).transfer(msg.sender, amount0);
    //     IERC20(collateral1).transfer(msg.sender, amount1);

    //     // lendingPool.userCollaterals[msg.sender] -= amount;
    // }

    // function borrow(uint256 amount) public {
    //     lendingPool.accrueInterest();

    //     uint256 shares = (amount * lendingPool.totalBorrowShares) / lendingPool.totalBorrowAssets;

    //     lendingPool.totalBorrowAssets += amount;
    //     lendingPool.totalBorrowShares += shares;
    //     lendingPool.userBorrowShares[msg.sender] += shares;

    //     IERC20(borrow).transfer(msg.sender, amount);
    // }

    // function test() public returns (string memory) {
    //     return "Hello World";
    // }
}
