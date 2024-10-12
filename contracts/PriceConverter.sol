// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // Function to withdraw funds/money
    // function withdraw() public {}

    // Convert to ETH ==>> USD

    function getPrice() internal view returns(uint256) {
    // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306 : Got from chainlink data feeds
    // ABI
    // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    // THIS IS THE ADDRESS FOR ZKSYNC
     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
    (
        ,
        int256 answer,
        ,
        ,
        
    ) = priceFeed.latestRoundData();
    
    // Chainlink price feed returns price with 8 decimal places, so to convert to 18 decimals:
    return uint256(answer * 1e10); // converting the answer to 18 decimal places
    // We will get 200000000 it will not have the decimal point but according to the rules it should have 8 decimal points
}

    // Now we get the value of ETH now we have to convert that to USD

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        // IDEA: Lets say 1 ETH = 2000 USD
        // 1 ETH => 2000_000000000000000000
        // Math does: (2000_000000000000000000 * 1_000000000000000000) / 1e18
        // So we get 2000$ = 1ETH
        uint256 ethPrice = getPrice();
        // ETH amount in USD
        // 1ETH * 1 ETH => 1000000000000000000 * 1000000000000000000 = 1000000000000000000000000000000000000 so this is a large number so we have to divide it by 1 ETH => 1000000000000000000
        // Always have to multiply before dividing because in solidity 1/2 always give 0
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }   


    

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF)
                .version();
    }
}