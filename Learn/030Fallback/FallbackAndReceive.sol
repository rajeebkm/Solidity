// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReceiveEther {

    event Log(string func, address sender, uint amount, bytes data);
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

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    // Fallback function is called when msg.data is not empty
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }
    // Fallback is executed a. when a function doesn't exist inthe contract b. when directly send Ether.

}

// https://docs.soliditylang.org/en/v0.6.2/contracts.html#receive-ether-function
