// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function getLatestETHPrice(
    AggregatorV3Interface priceFeed
  )
    internal
    view
    returns (uint256)
  {
    (
      /*uint80 roundID*/,
      int price,
      /*uint startedAt*/,
      /*uint timeStamp*/,
      /*uint80 answeredInRound*/
    ) = priceFeed.latestRoundData();

    return uint256(price * 1e10);
  }

  function getConversionRate(
    uint256 ethAmount,
    AggregatorV3Interface priceFeed
  )
    internal
    view
    returns (uint256)
  {
    uint256 ethPrice = getLatestETHPrice(priceFeed);
    uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
    // the actual ETH/USD conversion rate, after adjusting the extra 0s.
    return ethAmountInUsd;
  }
}
