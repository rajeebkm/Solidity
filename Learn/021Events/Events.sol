// Events
// Events allow logging to the Ethereum blockchain. Some use cases for events are:

// Listening for events and updating user interface
// A cheap form of storage

//1 Event Declaration, 2. Emit Events 3. Listening to Events by the outside consumer

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Event {
    // Event declaration
    // Up to 3 parameters can be indexed.
    // Indexed parameters helps you filter the logs by the indexed parameter
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}

//Events cann't be read from smart contract like state variables.
//After we emit Log events, it's impossible for smart contract to read the emitted event in the past. You can emit event and that will be consumed by entities outside the blockchain. This is one-way communication, from blockchain to outside world.
//State variables can be read in the future from the smart contract.