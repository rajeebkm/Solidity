// Iterable Mapping
// You cannot iterate through a mapping. So here is an example of how to create an iterable mapping.

/* If I have an array,I can get size of the array,and usinf the for loop I can get all of the 
element in that array. That's not in the case of mappings. We cann't get the size of mapping 
and we cann't iterate to get all the element of mapping unless we keep track of all the keys
in the mapping.
*/

/* To build iterable mapping where we can get the size of the mapping and we'll be able to run a 
for loop to get all the elements inside the mapping.
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract IterableMapping{
    //Mapping from address to uint which represents a balance of an address.
    mapping(address=>uint) public balances; 
    /* To keep track of the size ofthe mapping and to get all the elements in this mapping, we're gonna 
    need some new data. We're gonna need a mapping that keeps track whether a key is inserted or not. 
    When we insert a new data into the "balances mapping", inside the "inserted mapping" we'll set 
    the "address" that we just inserted into the "balances mapping" to "true".
    */
    mapping(address=>bool) public inserted;
    /* We alse need to keep track of all of the keys that we inserted into a array.
    */
    address[] public keys;

    /* First function to set the balance of the mapping "balances", check whether key is inserted or not,
     if not, then push the keys into the array of keys.
    */

    function set(address _key, uint _value) external {
        balances[_key] = _value;

        if(!inserted[_key]){
            inserted[_key] = true;
            keys.push(_key);
        }
    }
    
    //We can get the size of balances mapping with this function by getting length of the keys array.
    function getSize() external view returns(uint){
        return keys.length;
    }

    // Once we know the size of the balances mapping, we can run a for loop to get all the values inside the mapping. If we want to know the first element/value stored inside the balances mapping, we'll first access the keys array at 0 index, this will return an address, and given that address, we'll access the balances mapping and then get the uint.

    function first() external view returns(uint){
        return balances[keys[0]];
    }

    function last() external view returns(uint){
        return balances[keys[keys.length-1]];
    }
}