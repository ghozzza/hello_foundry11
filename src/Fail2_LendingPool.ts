// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Position} from "./Position.ts";

contract LendingPool {
    Position public position;
    uint256 public totalSupplyAssets;
    uint256 public totalSupplyShares;
    uint256 public totalBorrowAssets;
    uint256 public totalBorrowShares;

    mapping(address => uint256) public userSupplyShares;
    mapping(address => uint256) public userBorrowShares;
    mapping(address => uint256) public userCollaterals;
    mapping(address => address) public addressPosition;

    // address token0; // collateral(?)
    address public token1; // collateral(?)
    address public token2; // borrow(?)
    uint256 public lastAccrued;

    constructor(
        // address _token0,
        address _token1,
        address _token2
    ) {
        // token0 = _token0;
        token1 = _token1;
        token2 = _token2;
        lastAccrued = block.timestamp;
    }

    function createPosition() public {
        if (addressPosition[msg.sender] == address(0)) {
            position = new Position(token1, token2);
            addressPosition[msg.sender] = address(position);
        }
    }

    function supply(uint256 amount) public {
        // Tujuannya adalah untuk penyedia token
        IERC20(token2).transferFrom(msg.sender, address(this), amount);

        _accrueInterest();
        uint256 shares = 0;
        if (totalSupplyAssets == 0) {
            shares = amount;
        } else {
            shares = (amount * totalSupplyShares) / totalSupplyAssets;
        }

        totalSupplyAssets += amount;
        totalSupplyShares += shares;
        userSupplyShares[msg.sender] += shares;
    }

    function withdraw(uint256 amount) public {
        // user withdraw dapat yield
        uint256 shares = (amount * totalSupplyShares) / totalSupplyAssets;

        totalSupplyAssets -= amount;
        totalSupplyShares -= shares;
        userSupplyShares[msg.sender] -= shares;

        IERC20(token2).transfer(msg.sender, amount);
    }

    function accrueInterest() public {
        _accrueInterest();
    }

    function _accrueInterest() internal {
        uint256 borrowRate = 5;

        uint256 interestPerYear = totalBorrowAssets * borrowRate / 100;
        uint256 elapsedTime = block.timestamp - lastAccrued;

        uint256 interest = (interestPerYear * elapsedTime) / 365 days;

        totalBorrowAssets += interest;
        totalSupplyAssets += interest;

        lastAccrued = block.timestamp;
    }

    // By Position

    // function supplyCollateral(uint256 amount0, uint256 amount1) public {
    //     accrueInterest();

    //     IERC20(collateral0).transferFrom(msg.sender, address(this), amount0);
    //     IERC20(collateral1).transferFrom(msg.sender, address(this), amount1);

    //     userCollaterals[msg.sender] += amount;
    // }

    function supplyCollateralByPosition(
        // uint256 _position,
        // uint256 amount0,
        uint256 _amount
    ) public {
        // if (addressPosition[msg.sender][_position] != address(0)) {
        if (addressPosition[msg.sender] != address(0)) {
            accrueInterest();

            IERC20(token1).transferFrom(msg.sender, address(this), _amount);
            // position = Position(addressPosition[msg.sender][_position]);
            position = Position(addressPosition[msg.sender]);
            userCollaterals[msg.sender] += _amount;
        } else {
            revert();
        }
    }

    function borrowByPosition(uint256 amount) public {
        if (addressPosition[msg.sender] != address(0)) {
            accrueInterest();
            uint256 shares;
            if (totalBorrowShares == 0) {
                shares = amount;
            } else {
                shares = (amount * totalBorrowShares) / totalBorrowAssets;
            }

            totalBorrowAssets += amount;
            totalBorrowShares += shares;
            userBorrowShares[msg.sender] += shares;

            IERC20(token2).transfer(msg.sender, amount);
        } else {
            revert();
        }
    }

    function withdrawCollateral(
        // uint256 amount0,
        uint256 amount1
    ) public {
        // require(userCollaterals[msg.sender] >= amount0, "insufficient collateral");
        require(userCollaterals[msg.sender] >= amount1, "insufficient collateral");
        require(userBorrowShares[msg.sender] == 0, "cannot withdraw while borrowing");

        accrueInterest();

        // IERC20(token0).transfer(msg.sender, amount0);
        IERC20(token1).transfer(msg.sender, amount1);

        // userCollaterals[msg.sender] -= amount;
    }
}
