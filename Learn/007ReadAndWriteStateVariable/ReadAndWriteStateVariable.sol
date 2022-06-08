// Reading and Writing to a State Variable

// To write or update a state variable you need to send a transaction.

// On the other hand, you can read state variables, for free, without any transaction fee.

//SPDX-License-Identifier: MIT

contract SimpleStorage{

    uint public num;

    function set(uint _num) public {
        num = _num;
    }

    function get() public view returns(uint){
        return num;

    }
}
