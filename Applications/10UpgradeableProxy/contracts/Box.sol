//SPDX-License-Identifier:MIT

pragma solidity ^0.8.13;

contract Box{
    uint public val;

    // constructor(uint _val){
    //     val = _val;
    // }
    //For upgradeable contract, the state variable inside implementation contract will never be used.

    function initialize(uint _val)external{
        val = _val;
    }
}