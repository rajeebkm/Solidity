// Hashing with Keccak256
// keccak256 computes the Keccak-256 hash of the input.

// Some use cases are:

// Creating a deterministic unique ID from a input
// Commit-Reveal scheme
// Compact cryptographic signature (by signing the hash instead of a larger input)

// Sign a signature come up with uinque ID and also it is used to create a contract that is protected from front running, (The attacker can execute something called the Front-Running Attack wherein, they basically prioritize their transaction over other users by setting higher gas fees).


// What is Commit reveal schemes ?
// A commitment scheme is a cryptographic algorithm used to allow someone to commit to a value while keeping it hidden from others with the ability to reveal it later. The values in a commitment scheme are binding, meaning that no one can change them once committed. The scheme has two phases: a commit phase in which a value is chosen and specified, and a reveal phase in which the value is revealed and checked.

// To get a better understanding, consider this simplified visualization. Imagine Alice, the sender, placing a message in a locked box and handing it to Bob, the receiver. Bob can’t access the message because it’s locked in the box, and Alice can’t change the message because it’s in Bob’s possession, but when Alice wants to reveal the message, she can unlock the box and show the message to Bob.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HashFunction {
    function hash(
        string memory _text,
        uint _num,
        address _addr
    ) public pure returns (bytes32) { //keccak256 output is in bytes
        return keccak256(abi.encodePacked(_text, _num, _addr)); //keccak256 takes inputs in bytes, To convert inputes to bytes, use "abi.encode(inputs)" or "abi.encodePacked(inputs)"
    }

    function encode(string memory text0, string memory text1) external view returns (bytes32 memory){
        return abi.encode(text0, text1);
    }

    function encodePacked(string memory text0, string memory text1) external view returns (bytes32 memory){
        return abi.encodePacked(text0, text1);
    }

    // Example of hash collision
    //Hash Collision (Inputs are different, but these hashes to the same output). 
    // "abi.encode() encodes data into bytes whereas abi.encodePacked also encodes data into bytes but it compresses it. The output will be smaller and it reduces some of the informations that was contained in abi.encode
    // Hash collision can occur when you pass more than one dynamic data type
    // to abi.encodePacked, it produces same bytes and also keccak256 of that bytes are same. In such case, you should use abi.encode instead.
    function collision(string memory _text, string memory _anotherText)
        public
        pure
        returns (bytes32)
    {
        // encodePacked(AAA, BBB) -> AAABBB
        // encodePacked(AA, ABBB) -> AAABBB  (Same hash)
        return keccak256(abi.encodePacked(_text, _anotherText));
    }
}

contract GuessTheMagicWord {
    bytes32 public answer =
        0x60298f78cc0b47170ba79c10aa3851d7648bd96f2f8e46a19dbc777c36fb0c00;

    // Magic word is "Solidity"
    function guess(string memory _word) public view returns (bool) {
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
