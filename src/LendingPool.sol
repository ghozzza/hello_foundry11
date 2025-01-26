// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IAavePool {
    function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf)
        external;
    // function repay(address asset, uint256 amount, uint256 rateMode, address onBehalfOf) external;
    // function withdraw(address asset, uint256 amount, address to) external;
}

contract LendingPool {
    address public supplyAsset;
    address public borrowAsset;

    address public pool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    struct Supply {
        address token;
        uint256 amount;
    }

    mapping(address => uint256) public totalSupply;
    mapping(address => Supply[]) public totalUserSupply;

    // Jaminan
    // Supply WBTC
    function supplyCollateral(uint256 amountWBTC, uint256 amountUSDC) external {
        // transfer dari user ke contract lending
        if (amountWBTC != 0) {
            IERC20(wbtc).transferFrom(msg.sender, address(this), amountWBTC);
            // supply
            IERC20(wbtc).approve(pool, amountWBTC);
            IAavePool(pool).supply(wbtc, amountWBTC, address(this), 0);
            totalSupply[wbtc] += amountWBTC;

            for (uint256 i = 0; i < totalUserSupply[msg.sender].length; i++) {
                if (totalUserSupply[msg.sender][i].token == wbtc) {
                    totalUserSupply[msg.sender][i].amount += amountWBTC;
                    break;
                }
            }
            totalUserSupply[msg.sender].push(Supply({token: wbtc, amount: amountWBTC}));
        }
        if (amountUSDC != 0) {
            IERC20(usdc).transferFrom(msg.sender, address(this), amountUSDC);
            // supply
            IERC20(usdc).approve(pool, amountUSDC);
            IAavePool(pool).supply(usdc, amountUSDC, address(this), 0);
            totalSupply[usdc] += amountUSDC;

            for (uint256 i = 0; i < totalUserSupply[msg.sender].length; i++) {
                if (totalUserSupply[msg.sender][i].token == usdc) {
                    totalUserSupply[msg.sender][i].amount += amountUSDC;
                    break;
                }
            }
            totalUserSupply[msg.sender].push(Supply({token: usdc, amount: amountUSDC}));
        }
    }

    // Borrow USDC
    function borrow(uint256 amount, address _token) external {
        //borrow
        IAavePool(pool).borrow(_token, amount, 2, 0, address(this));
        // transfer dari contract lending ke user
        IERC20(_token).transfer(msg.sender, amount);
    }

    // tidak perlu kalo hackahton (opsional)
    // function repay() external {} // repayUSDC
    // function withdrawCollateral(uint256) external {} // withdraw WBTC
    // function withdraw(uint256 amount) external {} // withdraw USDC
}

// sandwich attack

// uniswap udah kasih calculated, sdk
//collateral si vault
