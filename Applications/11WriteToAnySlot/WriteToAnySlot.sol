// Write to Any Slot
// Solidity storage is like an array of length 2^256. Each slot in the array can store 32 bytes.

// State variables define which slots will be used to store data.

// However using assembly, you can write to any slot.

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Storage {
    struct MyStruct{
        uint value;
    }

    //Struct stored at slot 0
    MyStruct public s0 = MyStruct(123);
    //Struct stored at slot 1
    MyStruct public s1 = MyStruct(246);
    //Struct stored at slot 2
    MyStruct public s2 = MyStruct(369);

    function _get(uint i)internal pure returns (MyStruct storage s){
        //get strcut stored at slot i
        assembly{
            s.slot := i
        }
    }

    /*
    get(0) returns 123
    get(1) returns 246
    get(2) returns 369
    */
    function get(uint i) external view returns (uint) {
        // get value inside MyStruct stored at slot i
        return _get(i).value;
    }

    /*
    We can save data to any slot including slot 999 which is normally unaccessble.

    set(999) = 888 
    */
    function set(uint i, uint x) external {
        // set value of MyStruct to x and store it at slot i
        _get(i).value = x;
    }

}