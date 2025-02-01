// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {TokenRupiah} from "./TokenRupiah.sol";

contract Vault is ERC20 {
    error AmountCannotBeZero();
    error SharesCannotBeMoreThanBalance();

    address public assetToken;
    address public owner;

    event Deposit(address user, uint256 amount, uint256 shares);
    event Withdraw(address user, uint256 amount, uint256 shares);

    constructor(address _assetToken) ERC20("Deposito Vault", "DEPO") {
        assetToken = _assetToken;
        owner = msg.sender;
    }
    // shares token

    function deposit(uint256 amount) external {
        // amount can not 0
        if (amount == 0) revert AmountCannotBeZero();
        // shares yg akan diperoleh = deposit amount / total asset * total shares
        uint256 shares = 0;
        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));

        if (totalSupply() == 0) {
            shares = amount;
        } else {
            // why different? in case solidity, kali harus didahulukan
            shares = amount * totalSupply() / totalAssets;
        }

        _mint(msg.sender, shares);

        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount, shares);
    }

    function withdraw(uint256 shares) external {
        // shares can not 0
        if (shares == 0) revert AmountCannotBeZero();
        // shares can not up to balance
        if (shares > balanceOf(msg.sender)) revert SharesCannotBeMoreThanBalance();
        uint256 totalAssets = IERC20(assetToken).balanceOf(address(this));
        uint256 amount = shares * totalAssets / totalSupply();

        _burn(msg.sender, shares);

        IERC20(assetToken).transfer(msg.sender, amount);
        emit Deposit(msg.sender, amount, shares);
    }

    function distributeYield(uint256 amount) external {
        require(msg.sender == owner, "only owner can distribute yield");
        IERC20(assetToken).transferFrom(msg.sender, address(this), amount);
    }
}
