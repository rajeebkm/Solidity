// Library
// Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.

// A library is embedded into the contract if all library functions are internal.

// Otherwise the library must be deployed and then linked before the contract is deployed.

/* 
Library
- ** no storage, no ether
- ** helps you keep your code DRY (Don't Repeat Yourself):
We will be able to reuse the code from library and remove duplicate code. one way is Libraries allow us to add functionality to the types
    - add functionality types
    //uint x   //variable of uint type
    //x.myFuncFromLibrary()  //by using library uint type can be enhanced to have extra functionalities. Example: call the function from library on the variable x
- ** can save gas // deploy the library first and after that it can be linked to any contract before it's deployment.

Embedded or Linked
- embedded (library has only internal functions) : 
Embedded into the contract if library has only internal functions i.e. when a contract is being compiled, all of the code inside the library will be put inside the contract
- must be deployed and then linked (library has public or external function)

Examples
- safe math (prevent uint overflow): Library prevents uint overflow
- deleting elements from array without gaps:
 (In solidity, when we delete the element from an array, it doen't shrink the array (default value 0). So this library will allow us to shrink an array after deleting element from it. (Last element will be placed in the removed space, and last element space will be deleted). Example: [1,2,3,4,5,6,7,8]. If we want to remove element from index 3, array becomes [1,2,3,0,5,6,7,8]. So after shrinking array becomes [1,2,3,8,5,6,7]) .
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//define library
library SafeMath {
    //prevent uint overflow when two uints are added.
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");

        return z;
    }

    function max(uint x, uint y) internal pure returns(uint){
        return x >= y ? x : y;
    }
}

library Math {
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0 (default value)
    }
}

contract TestSafeMath {
    using SafeMath for uint;
    //using A for B means attach functions from lirary A (SafeMath) to type B (uint).
    //uint x = 123;
    //x.add(246); //We have to use "using SafeMath for uint", to enhance the uint type, we can pass only one parameter in library function though the function takes two parameters.
    //or, SafeMath.add(x,246); //otherwise we have to use library like this.

    uint public MAX_UINT = 2**256 - 1;

    function testAdd(uint x, uint y) public pure returns (uint) {
        return x.add(y);
        //or, retun SafeMath.add(x, y);
    }

    function testMax(uint x, uint y) external pure returns (uint){
        return SafeMath.max(x, y);
    }
    

    function testSquareRoot(uint x) public pure returns (uint) {
        return Math.sqrt(x);
    }
}

// Array function to delete element at index and re-organize the array
// so that their are no gaps between the elements.
library Array {
    function remove(uint[] storage arr, uint index) public {
        // Move the last element into the place to delete
        require(arr.length > 0, "Can't remove from empty array");
        arr[index] = arr[arr.length - 1];
        arr.pop();
    }
}

contract TestArray {
    using Array for uint[];

    uint[] public arr;

    function testArrayRemove() public {
        for (uint i = 0; i < 3; i++) {
            arr.push(i);
        }

        arr.remove(1);
        //or, Array.remove(arr, 1);

        assert(arr.length == 2);
        assert(arr[0] == 0);
        assert(arr[1] == 2);
    }
}
