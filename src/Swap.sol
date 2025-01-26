// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract Swap {
    address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address wbtc = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    function swap(uint256 amountIn, uint256 minAmountOut) public {
        // transfer dari user ke contract swap
        IERC20(usdc).transferFrom(msg.sender, address(this), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: usdc,
            tokenOut: wbtc, // mau ditukar ke apa
            fee: 3000, // setiap money changer ngasih berapa, fleksibel ga sih(?) sama dengan 0,3%
            recipient: msg.sender, // siapa yang mau ditukar
            deadline: block.timestamp, // transaksi dikasih batas waktu
            amountIn: amountIn, // jumlah yang mau ditukar
            amountOutMinimum: minAmountOut, // masukin 1000 usdc, maunya dapet minimal sekian btc, kalo tidak mencapai itu, batal. wajib ada kalo ke auditor, tujuannya supaya tidak ada manipulasi harga. slipage
            sqrtPriceLimitX96: 0 // 
        });
        IERC20(usdc).approve(router, amountIn); // approve kepada uniswap
        ISwapRouter(router).exactInputSingle(params);
    }
}


// sandwich attack

// uniswap udah kasih calculated, sdk