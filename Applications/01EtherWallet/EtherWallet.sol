// Ether Wallet
// An example of a basic wallet.

// Anyone can send ETH.
// Only the owner can withdraw.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {} 
    
    // We use receive() function to receive ether to this contract,. In the place of receive() we can use fallback() function. Our intenstion is to receive ether to this contract. If anyone call the function that doesn't exists, then transaction will be failed (as fallback() function is not available)

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        // owner.transfer(_amount);
        payable(msg.sender).transfer(_amount); //Replacing (msg.sender) in the place of owner state variable to optimize gas

        //call or transfer accomplish the same thing.

        // (bool success, ) = msg.sender.call{value: _amount}("");
        // require(success, "Failed to send Ether");
    } 

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
