// Here is a contract to test sending transactions from the multi-sig wallet

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TestContract {
    uint public i;

    function callMe(uint j) public {
        i += j;
    }

    function getData() public pure returns (bytes memory) {
        return abi.encodeWithSignature("callMe(uint256)", 123);
    }
    //bytes: 0xe73620c3000000000000000000000000000000000000000000000000000000000000007b
}

//_to (contract address): 0x929336a17aF293b16d025170e310d7C408C5447e 