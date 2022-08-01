//Error Handling

//1. What happens when there is an error ?
//2. throw
//3. require(), revert(), assert()
//4. custom error - save gases
//5. error in other contracts

//------------------------------------------------//

//1. What happens when there is an error ?
// Execution of function will be stopped, any state changes will be reverted, gas will be refunded (For Ex: 1000 gas was sent for function excution,100 was consumed,so remaining 900 gas will be refunded): gas refund, state updates are reverted

//2. throw
// throw : "throw" keyword was the first keyword to throw an error, it was deprecated in solidity 0.5.

//3. require(), revert(), assert()
//require(): Input validation, access control
//revert(): "revert", if some condition inside the function fails, returns an error message (it's better than require, if condition to check is nested in a lot of if statements)
//assert: Condition inside assert will always be true, if it fails, then throws an error. "assert" is used to check for the condition that should always be true. if condition evaluates to false, then there might be bugs inside the smart contracts.

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Error{

    //require()
    function testRequire(uint _i) public pure {
        require(_i <=10, "i is greater than 10");
        //code
    }

    //revert()
    function testRevert(uint _i) public pure {
        if(_i > 1){
            //code
            if(_i > 2){
                //code
                if(_i>10){
                    revert("i is greater than 10");
                }
            }
        }
    }

    //assert()
    uint public num = 123;

    function testAssert() public view {
        assert(num == 123);  //assert will check the condition should always be true.
    }

    function foo() public {
        //accidentally update num
        num +=1;
        
    }

    //gas refund, state updates are reverted

    function foo2(uint _i) public {
        num +=1;
        require(_i < 10);
        //code
    }

    //4. custom error : Cheaper than to use "require with some error messages", as longer the error message, the more the gas it will use. Custom error will only be used with revert.

    error MyError(address caller, uint i); //inside Custom error, we can log some data

    function testCustomError(uint _i) public view {
        if (_i >10){
            revert MyError(msg.sender, _i);
        }
    }

    function willThrowInOtherContracts() external {
        otherErrorContract other = new otherErrorContract(); //Instances of other contract
        other.bar();
    }

    //Also, it's possible to recover from the error, if we call the smart contract with an other way

    function willThrowInOtherContracts2() external {
        otherErrorContract other = new otherErrorContract(); //Instances of other contract
        // other.bar();
        //call() is a low-level way of calling smart contracts, vulnerable to re-entrancy attacks. Avoid if possible
        (bool success, )=address(other).call(abi.encodePacked("bar()")); // this line of code return boolean set to false, if there is false we know that there is an error inside code.
        require(success, "Not deployed");
    }

}

//5. error in other contracts

contract otherErrorContract{

    function bar() external {
        revert("Because other reasons");
    }
}



