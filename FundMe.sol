// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract FundMe {
    // uint256 public myValue = 1;
    // payable => mark that this function can accept ether
    uint256 public minimumUsd = 5;

    // This min USD cannot be populated here becz blockchain used the eth,wei,gwei stuffs so we need something called decentralized oracle network/ chainlink [blockchain oracle]
    function fund() public payable {
        // Function to send me funds/money
        // Have a minimum $ sent
        // Instead ETH we want to limit that some USD should be the limit(eg 5$)
        // Send at least 1 ETH
        // require => checks something like conditional statement
        // require(value, if not successfull message)
        // myValue = myValue+2;
        require(msg.value >= minimumUsd, "didn't have enough ETH"); //1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 18 wei

        // revert => undo any actions that have been done, and send the remaining gas back
    }

    // Function to withdraw funds/money
    // function withdraw() public {}

    // Convert to ETH ==>> USD

    function getPrice() public {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306 : Got from chainlink data feeds
        // ABI
        // AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
