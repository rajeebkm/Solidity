// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ArrayRemoveByShifting {
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []

    uint[] public arr = [1,2,3,4,5,6];
    // uint[] external arr = [1,2,3,4,5,6]; //Error, we cann't declare state variable as external

    function array() public view returns (uint[] memory){
        return arr;
    }
  
  

    function removeByShift(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();

        // this.removeByCopyLastElement(2); //To call external function within the contract this.function_name() used
    }

    // Remove array element by copying last element into to the place to remove

    function removeByCopyLastElement(uint _index) external {
        require(_index < arr.length, "Out of bound");

        for (uint i=0; i<arr.length; i++){
            arr[_index]=arr[arr.length-1];
        }
        arr.pop();
        // removeByCopyLastElement(2); //Error, as we cannot call external function internally,
        //can be called outside of external function with this.function_name().
    }

}
