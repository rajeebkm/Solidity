// Merkle Tree
/ Merkle tree allows you to cryptographically prove that an element (transaction) is contained in a set (block) without revealing the entire
set (transactions).
*/

/* Tree that grows our cryptocurrencies like Bitcoin and Ethereum */

/* To construct a Merkle Tree, we first start with a non-empty array. For simplicity, we're going to assume that the length of the array is a powerof 2. 
Example:Length of the array can be 2 or, 4, or, 8 and so on..Why we need an array with a length as power of 2 ? */

/* For each element in the array, we're gonna compute the cryptographic hash of the element and then store it in a new array. From the array of hashes,
we take the first two elementand then compute the hash, we take next two element, and compute the hash, and we continue the process untill we computed 
the hash of the last two elements. Eventually, we will get a single hash, called root hash. This is how we construct the Merkle Tree. If number of 
elements in the original array is not the power of 2, then at some point of Merkle Tree construction, there will be an odd number of computed hashes. 
*/

/* For example: If we start with 6 elements, then we'll get 3 hashes after computing hash of the pairs. And we cann't compute the next level of hashes 
since we need 4 hashes, but there is only 3 hashes present. If there are odd number of hashes, then the trick to compute the next level of hashes is to 
duplicate the last element and then compute the hash of the duplicates. This is like filling the tail end of the array with duplicates so that length of 
the array becomes the power of 2. 
*/

/* So, how is a Merkle Tree useful ? One application is: We can create a cryptographic proof that a transaction was included in a block. Imagine there
are bunch of transactions that are waiting to be included in a block. To create a cryptographic proof that these pending transactions are included in
the next block. We first create the Merkle Tree from these transactions and we include the Merkle root hash into the block.
*/

/* Now, if Alice wants to know if her transaction (3rd element) was included in the block, all she has to do is get these 4 hashes (from 8 hashes,
4 hashes, then 2, then 1). Now From base 8 hashes, take 3rd element (index 2, hash 1) & 4th element (index 3, hash 2, proof 1), from 1st level 4 hashes 
take, first hashes (index 0, hash 3, proof 2), and finally take last hashes (index 1, hash 4, proof 3) from 2nd level and compute merkle root hash),
we compute the Merkle root hash and compared to the Merkle root hash that was commited to the block. If two merkle root hashes are matched, then she 
knows that her transaction was included in the block.
*/

/* Another way to create a proof that a transaction was included in a block is to concatenate all the transaction data and create a single hash from it.
The problem with this approach is that in order to recompute the hash, we need the all of the transaction data, so if there was 1000 transactions in a 
block and Alice wants to know if her transaction was included in the block, then she'll have to download all 1000 transactions and then compute the hash.
However using the Merkle Tree, she only need log2(100) < 10 hashes (about)
*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MerkleProof {
    function verify(
        bytes32[] memory proof, //array of hashes that are needed to compute the Merkle root
        bytes32 root, //Merkle root itself
        bytes32 leaf, //hash of the element in the array that was used to construct the merkle tree
        uint index //index in the array where the element is stored
    ) public pure returns (bool) { 
        //This function will return true if it can recreate the Merkle root from the proof, leaf and the index, otherwise it will return false
        bytes32 hash = leaf; 
        //We will start with the leaf, recompute the Merkle root and compare with the Merkle root that was provided.

        //Build (recompute) Merkle Root
        for (uint i = 0; i < proof.length; i++) { 
            //for loop that will update the hash with elements of the proof
            //First to fugure out how to compute the parent hash from the very bottom of the Merkle Tree. Notice that indexes of all left leaves are all even (0, 2, 4..) and all right leaves are all odd (1, 3, 5..). This means that if the index is even then we need to append the proof element to our current hash and then update the hash, otherwise index is odd which means that our hash belongs to the right branch and we need to prepend our proof element before updating the hash. This will give us hash one above from very bottom of the Merkle tree.

            bytes32 proofElement = proof[i]; 
           
   
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            //We want to repeat this logic where we concatenate our current hash with the proof element if the current hash belongs to the left branch and if our current hash belongs to the right branch, then we want to concatenate our proof element with the hash and then update the hash. Now notice that if our starting index is 3, then our parent index is 1 and if our starting index is 2, then our parent index is also 1 and in general if our index is either 2k or 2k+1, then our parent index is k. In other words, we devide our current index by 2 and round down to nearest integer. 

            index = index / 2; //Next index will be 1
        }

        return hash == root;
    }
}

//How it works ?

//Let's say that there are 8 elements and we want to verify that the 3rd element is contained in this Merkle Tree. Then the proof must be an array of the hash of 4th element, the hash of the hashes of 1st and 2nd element and the hash computed from the right side of the Merkle Tree.
//The leaf will be the hash of the 3rd element and the index will be 2
//We start from the hash of the 3rd element. Since the index is equal to 2, our proof element must come from the right. So we concatenate our current hash with the hash of the 4th element and then update ourhash and then update our index. Our index was 2 before, so 2/2 = 1. now our current index is equal to 1 and we move on to the next iteration of the for loop. 
//Now current index is 1, this means our proof element must be on the left side. So we append the current hash to the second proof element and then update the hash and then update the index. Our index was 1, so 1/2 = 0.5, round down to nearest integer 0. So, our index is equal to 0and that completes the second iteration. For 3rd and final iteration the index is now equal to 0, so the proof element comes from the right side of the Merkle Tree which means that we need to append it to our current hash and update the hash and lastly we check that Merkle root that we computed is equal to the Merkle root that was provided.

contract TestMerkleProof is MerkleProof {
    bytes32[] public hashes;

    constructor() {
        string[4] memory transactions = [
            "alice -> bob",
            "bob -> dave",
            "carol -> alice",
            "dave -> bob"
        ];

        for (uint i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint n = transactions.length;
        uint offset = 0;

        while (n > 0) {
            for (uint i = 0; i < n - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
                    )
                );
            } 
            offset += n;
            n = n / 2; 
        }
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    /* verify
    3rd leaf
    0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b

    root
    0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7

    index
    2

    proof
    0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950
    0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
    */
    //Order of proof element in the array should be important.

/* hashes =
[
0x92ae03b807c62726370a4dcfecf582930f7fbb404217356b6160b587720d3ba7, 
0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b, 
0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b, 
0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950, 
0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433, 
0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7, 
0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7 (Merkle root)
]
*/
}
