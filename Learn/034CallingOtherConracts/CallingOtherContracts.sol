//SPDX-License-Identifier:MIT
 
pragma solidity ^0.8.13;

contract CallTestContract{

    // function setX(address _add, uint _x) external {
    //     TestContract(_add).setX(_x);   //Initialising contract first before calling a function.
    // }
    function setX(TestContract _add, uint _x) external {  // We can set contract name as type
        _add.setX(_x);
    }


    // function getX(address _add) external view returns (uint){
    //     return TestContract(_add).getX();
    // } 

    // or,

    // function getX(address _add) external view returns (uint x){
    //     x = TestContract(_add).getX();
    // }

    // or,

    function getX(address _add) external view returns (uint){
        // TestContract _testContract = TestContract(_add);
        // _testContract.getX();
        uint x = TestContract(_add).getX();
        return x;
    }

    function setXandSendEther(address _add, uint _x) external payable {
        TestContract(_add).setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(address _add) external view returns(uint, uint){
        (uint x, uint value) = TestContract(_add).getXandValue();
        return (x, value);
    }



}


contract TestContract{
    uint public x;
    uint public value = 123;


    function setX(uint _x) external {
        x=_x;
    }

    function getX() external view returns (uint){
        return x;
    }

    function setXandReceiveEther(uint _x) external payable{
        x=_x;
        value = msg.value;
    }

    function getXandValue() external view returns(uint, uint){
        return (x, value);
    }
}