// Minimal Proxy Contract
// If you have a contract that will be deployed multiple times, use minimal proxy contract to deploy them cheaply.

/* Minimal Proxy Contract (create_forwarder_to in Vyper) https://www.youtube.com/watch?v=r0cAn4ZVUeg
    - why is it cheap to deploy contract ?
        - Because it uses delegate call, the copied contract doesn't have to have any code inside, so there is very little code inside the contracts that were cloned.There is minimal code inside clones.
    - why is constructor not called, when we use create_forwarder_to ?
        - Because it uses delegate call. After we called create_forwarder_to to clone (deploy) a new contract frommaster contract, we have to manually setup some parameters inside the new contract by calling the function setup(), which was declared in master contract. It deployes a simple contract that forwards all calls using delegate call. Constructor of master contract was not called.
    - why is the original contract not affected, when the copied contract executes it's code ?
        - Because it uses delegate call
*/

/* Delegate call- Suppose Contract A will delegate call to Contract B, what this means that when someone (Alice) calles a function() inside Contract A, Contract A will delegate call to Contract B, execute code inside Contract B and instead of updating stuff inside Contract B, it updates the stuff inside Contract A, for example, it might update the state variable inside Contract A, even though the code that was executed lives inside Contract B, and this is exactly how the contracts deployed using create-forwarder_to works. They used delegate call to execute original call inside the original contract and then make any updates inside copied contract. This answers our questions. 
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// //create_forwarder_to deployes a contract like this
// contract PseudoMinimalProxy{
//     address masterCopy;
//     constructor (address _masterCopy){
//         //notice that costructor of masterCopy is not called any where inside this contract.
//         masterCopy = _masterCopy;
//     }

//     /* this forward() function forward all function calls using delegate call, if the function 
//     is successfull, it will return the output as bytes. No master contract constructor called here */
//     function forward() external returns(bytes memory){
//         (bool success, bytes memory data) = masterCopy.delegatecall(msg.data);
//         require(success);
//         return data;
//     }
// }

// actual code for Minimal Proxy Contract look like this //
// 3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3

/* To understand how this actual code is simillar to the contract above, we need to understand bytecode.

- If we give the contract directly to EVM, it will understand what exactly the contract means. In order to create a code that EVM can easily understand, we first need to compile it and generate bytecode, we give this bytecode to EVM, EVM understands what the contrcat is supposed to do.

- After compilation, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3 is the actual bytecode for the Minimal Proxy contact. There are 3 parts to this bytecode.
`0x3d602d80600a3d3981f3(part 1)`363d3d373d3d3d363d73(part 2)`bebebebebebebebebebebebebebebebebebebebe'(part 3)`5af43d82803e903d91602b57fd5bf3 (part 2)'

**Delegate call to this address: part 2 + part 3 (runtime code) says to delegate call to ( this address part 3).

**Return the bytecode in part 1 : part 1 tells the EVM to return the bytecode as in (part 2 + part 3). Why do we return the bytecode as in (part 2 + part 3) ? To talk about this, we first need to understand the creation and runtime code. 
-- The creation code (part 1) is the part that calls the constructor initial setups and then it returns the part as in (part 2 + part 3) runtime code. But for the Minimal Proxy Contract, it doen't call any constructor, there is no initial setup.

-- The runtime code is the actual code that is saved to the blockchain (part2 & part 3). When we call functions on smart contract, (this part2 + part 3) will be executed.

* For the Minimal Proxy Contract, the actual code that is being executed is to delegate call to this part 3 (0xbebebebebe...) address. When we deploy this contract, we need to replace this part 3 with the actual address of the masterCopy. Let's do in solidity, The part 1 and part 2 will not change.However we need to write solidity code to replace the address in part 3  The bytes in code(3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3)at indices 20 to 39 (inclusive) are to be replaced by the 20-bytes address of the logic contract.

The entire sequence of bytes representing the creation code, which includes the runtime code, is:
3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
The bytes at indices 20 to 39 (inclusive) are to be replaced by the 20-bytes address of the logic contract.
*/



// creation code //
// copy runtime code into memory and return it
// 3d602d80600a3d3981f3 : creation code (10 bytes)

// runtime code //
// runtime code to delegatecall to address
// 363d3d373d3d3d363d73 address 5af43d82803e903d91602b57fd5bf3 : runtime code (45 bytes)


// original code
// https://github.com/optionality/clone-factory/blob/master/contracts/CloneFactory.sol

contract MinimalProxy{
    /* This function takes the address of master copy (target) and it will programatically 
    replace the address of part 3 of the Minimal Proxy Contract. */
    function clone(address target) external returns(address result){
        //convert the address to 20 bytes
        bytes20 targetBytes = bytes20(target);

        /* Next thing to do is create that code (3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3) 
        and load into memory. So first thing is to get a memory address where we
        can store that code. We do that by calling mload at 0x40. mload is a function available inside assembly and it will read the next 32 bytes stored at the memory address. It tells read the next 32 bytes from the memory at the memory slot of ox40. It's a special slot in solidity. It contains a free memory pointer, basically it gives us a pointer where we can load our code into memory.*/

        assembly{
            let clone := mload(0x40) //This will give us back a pointer to where we can load directly the rest of our code.
            //To store the next 32 bytes to memory, starting at memory location stored in the variable called clone and code that we are going to store is 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )

            /*
              |              20 bytes                |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
                                                      ^
                                                      pointer
            */
            // store 32 bytes to memory starting at "clone" + 20 bytes
            // 0x14 = 20
            mstore(add(clone, 0x14), targetBytes) 

            /*
              |               20 bytes               |                 20 bytes              |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe
                                                                                              ^
                                                                                              pointer
            */
            // store 32 bytes to memory starting at "clone" + 40 bytes
            // 0x28 = 40
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )

            /*
              |               20 bytes               |                 20 bytes              |           15 bytes          |
            0x3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
            */
            // create new contract
            // send 0 Ether
            // code starts at pointer stored in "clone"
            // code size 0x37 (55 bytes)
            result := create(0, clone, 0x37)
        }
    }


    function isClone(address target, address query) external view returns (bool result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
      mstore(add(clone, 0xa), targetBytes)
      mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

      let other := add(clone, 0x40)
      extcodecopy(query, other, 0, 0x2d)
      result := and(
        eq(mload(clone), mload(other)),
        eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
      )
    }
  }
}


//https://medium.com/coinmonks/diving-into-smart-contracts-minimal-proxy-eip-1167-3c4e7f1a41b8
//https://eips.ethereum.org/EIPS/eip-1167