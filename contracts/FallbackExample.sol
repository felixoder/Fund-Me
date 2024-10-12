// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract FallbackExample{
    uint256 public result;


    // AND ONLY IF THE CALLDATA IS BLANK

    receive() external payable {
    // Get trigger anytime we hit any transaction 

        result = 1;
    }

    fallback() external payable { 
    // Get trigger anytime we hit any transaction
    result =  2;


    }
}

  /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
    receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()

    
    */