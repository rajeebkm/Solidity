// Function Selector
// When a function is called, the first 4 bytes of calldata specifies which function to call.

// This 4 bytes is called a function selector.

// Take for example, this code below. It uses call to execute transfer on a contract at the address addr.

// addr.call(abi.encodeWithSignature("transfer(address,uint256)", 0xSomeAddress, 123))

// The first 4 bytes returned from abi.encodeWithSignature(....) is the function selector.


//SPDX-License-Identifier:MIT

pragma solidity ^0.8.13;

contract FunctionSelector{

    function functionSlector(string calldata _add) external pure returns(bytes4){
        return bytes4(keccak256(bytes(_add))); //First 4 bytes of hash of function signature "transfer(address,uint256)" 
    }
    // 0xa9059cbb 
}

 contract Receiver{
 /*
    "transfer(address,uint256)"
    0xa9059cbb
    "transferFrom(address,address,uint256)"
    0x23b872dd
    */

    event Log(bytes data);
    function transfer(address _to, uint _amount) external {
        emit Log(msg.data);
        // 0xa9059cbb (First 4 bytes encodes transfer function to call
        // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc //Corresponds to parameter address _to
        // 4000000000000000000000000000000000000000000000000000000000000007b //Corresponds to parameter uint _amount

    }
 }



