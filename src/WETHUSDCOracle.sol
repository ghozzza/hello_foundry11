// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20Metadata} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IChainLink {
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract WETHUSDCOracle {
    address quoteFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; // ETH/USD 31.57 * 10 ** 8
    address baseFeed = 0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6; // USDC/USD

    function getPrice() public view returns (uint256) {
        (, int256 quotePrice, , , ) = IChainLink(quoteFeed).latestRoundData();
        (, int256 basePrice, , , ) = IChainLink(baseFeed).latestRoundData();
        return uint256(quotePrice) * 1e6 / uint256(basePrice);
    }
}
// 313357000000