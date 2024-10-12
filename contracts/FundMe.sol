// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


import {PriceConverter} from "./PriceConverter.sol";


// ADDING CUSTOM ERROR

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    // uint256 public myValue = 1;
    // payable => mark that this function can accept ether

    uint256 public constant MINIMUM_USD = 5e18 ; //Adding the 8 decimals after the dot for a better precision

    // this constant keyword saves some gas
    // we saved this much gas 824358 [without constant] 804400 [with constant] 

    address[] public funders; // get a list of the persons who funds money

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    // This immutable keyword also saves some gas!

    address public immutable i_owner;

    // WHAT IMMUTABLE and CONSTANT does is instead of storing tha values on the storage slot it stores directly in the bytecode of the contract


    //  This will enable a owner of the contract ONLY WHO CAN WITHDRAW MONEY
    constructor(){
        i_owner = msg.sender;
    }
    


    // This min USD cannot be populated here becz blockchain used the eth,wei,gwei stuffs so we need something called decentralized oracle network/ chainlink [blockchain oracle]
    function fund() public payable {
        msg.value.getConversionRate();
        // Function to send me funds/money
        // Have a minimum $ sent
        // Instead ETH we want to limit that some USD should be the limit(eg 5$)
        // Send at least 1 ETH
        // require => checks something like conditional statement
        // require(value, if not successfull message)
        // myValue = myValue+2;
        // Using the getConversionRate
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't have enough ETH"); //1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 18 wei
        // here in the function call the msg.value will be the first params of the function getConversionRate
        funders.push(msg.sender); // update the value after successfull payments

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

        // revert => undo any actions that have been done, and send the remaining gas back if some action reverts then the gas becomes refunded to the user
    }

    // withdraw the money

    // onlyOwner at first try to solve the job of the modifiers

    function withdraw() public onlyOwner {
        // require(msg.sender == owner, "Must be owner");

        // for(/*starting index; ending index, step amount */)

        // going through the funders array and making the address funder as funders[iterator]
        // and the mapping of [funder] will be 0

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset the array (0) means blank
        funders = new address[](0);
        // withdraw the funds
        // ways to withdraw money
        /*
        1. transfer: transfer the funds to whomever the person calls the withdraw func
        2. send
        3. call



       

        // TRANSFER method: [GO TO THE SOLIDITY BY EXAMPLE] ### IF THE TRANSFER METHOD REVERTS IT SHOWS AN "ERROR" WHILE THE OTHERS RETURNS "BOOL"
        // msg.sender = address
        // payable(msg.sender) = payable address
        payable(msg.sender).transfer(address(this).balance);

        // SEND method: Only reverts if we include the require statement

        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        */
        
        // CALL: WE ARE USING THIS HERE

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

    // CREATE MODIFIERS :
    // says do check the condition (eg, given to check that who is the sender) 
    // _ says that if the require successfull then do everything in the function

    // if _ comes first like

    /*
    modifier onlyOwner() {
        _;
        require(msg.sender == owner, "Sender is not owner);
    }
    this will execute the function stuffs first then do the checks


    */
    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    // WHAT IF SOMEONE SENDS THIS CONTRACT SOME ETH WITHOUT CALLING THE FUND FUNCTION

    // reveive(), fallback()


    // IF SOMEBODY ACCIDENTALLY SEND SOME MONEY WE CAN DEAL WITH THAT TRANSACTION

    // if anyone does not call the fund function still they will be directed to the fund() function
    receive() external payable { 
        fund();
    }

    fallback() external payable { 
        fund();
    }
    
}


// The receive function is specifically designed to handle Ether transfers without data and is automatically invoked when Ether. The fallback function is used for handling calls with data or when the receive function is not defined. The fallback function can also handle Ether transfers with data.

