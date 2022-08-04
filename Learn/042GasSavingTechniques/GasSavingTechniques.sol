// Gas Saving Techniques
// Some gas saving techniques.

// Replacing memory with calldata
// Loading state variable to memory
// Short circuit
// Replace for loop i++ with ++i (loop increments)
// Caching array elements (cache array length)
// Load array elements to memory


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// gas golf
contract GasGolf {
    // start - 50908 gas
    // use calldata - 49163 gas
    // load state variables to memory - 48952 gas  (State variables arebeing accessed for each loop. Anytime we read or write to a state variables, it uses up a lot of gas. So we can save some gas by loading state variable (total) to a variable inside memory, and after we run the for loop we update the state variable)
    // short circuit - 48634 gas
    // loop increments - 48244 gas
    // cache array length - 48209 gas
    // load array elements to memory - 48047 gas
    // uncheck i overflow/underflow - 47309 gas

    uint public total;

    // start - not gas optimized
    // function sumIfEvenAndLessThan99(uint[] memory nums) external {
    //     for (uint i = 0; i < nums.length; i += 1) {
    //         bool isEven = nums[i] % 2 == 0;
    //         bool isLessThan99 = nums[i] < 99;
    //         if (isEven && isLessThan99) {
    //             total += nums[i];
    //         }
    //     }
    // }

    // gas optimized
    // [1, 2, 3, 4, 5, 100]
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;  //Copy the state variable to memory
        uint len = nums.length; //cache array length

        for (uint i = 0; i < len; ) {
            uint num = nums[i]; // load array elements to memory
            if (num % 2 == 0 && num < 99) { //short cicuit: If first expression is false, there is no need to check seconf expression
                _total += num;
            }
            unchecked {
                ++i;
            }
        }

        total = _total; //Update the state variable at the end of the loop from memory
    }
}
