// Multi-Sig Wallet
// Let's create an multi-sig wallet. Here are the specifications.

// The wallet owners can

// submit a transaction
// approve and revoke approval of pending transcations
// anyone can execute a transcation after enough owners has approved it.

// Multi-sig wallet means it's a wallet that has many owners. To spend from the wallet, owner will need toget approval from other owners. Example: 2 out of 3 Multi-sig wallet (atlease 2 owners out of total 3 owners, have to approve the transaction). Simliarly, 2 out of 5 Multi-sig wallet, 3 out of 5 Multi-sig wallets and 5 out of 5 Multi-sig wallets exist.

//Multi-sig wallet can call other contracts. Suppose one owners wants to call other contract, and gets approval from other owners. After getting approval, can that owner can execute transaction on Multi-sig wallet and multi-sig wallet calls other contracts.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount, uint balance); //This event will be emitted when Ethers are sent to this contract
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    //State Variables
    address[] public owners; //Stores the owners in an array of addresses
    mapping(address => bool) public isOwner; //Check address is owner or not (boolean)
    uint public numConfirmationsRequired; //No. of confirmations required to execute a transaction

    //When a transaction is proposed by calling the submitTransaction function, we will create a struct called "Transaction".
    struct Transaction {
        address to; //address the transaction is sent to
        uint value; //Amount of ether send to the address
        bytes data; //In the case we are calling other contract, we will store the transaction data that is going to be sent to that contract
        bool executed; //We need to know whether our transaction is executed or not (tru or false boolean value)
        // mapping(address=>bool) isConfirmed; //When the owner arroves a transaction, we will store that in a mapping from address to boolean
        uint numConfirmations; // We will store the no. of confirmations
    }

    // mapping from tx index => owner => bool
    mapping(uint => mapping(address => bool)) public isConfirmed; 

    // Store the struct (transaction) inside the array of transactions "Transaction[]"
    Transaction[] public transactions;

    //Modifiers
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner"); //Modifier "onlyOwner" will check if the msg.sender is the owner of multi-sig wallet by looking at the mapping "isOwner".
        _; //If caller is the owner, we will excute the rest of the function
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist"); //modifier txExists will take _txIndex as input, and check _txIndex should less than the length of the transactions array
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed"); //To check a transaction is not executed, we can do this by getting transaction at _txIndex and making sure the field executed is false.
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed"); //To check a transaction is not confirmed by owner yet, we can do this by getting transaction at _txIndex, and access the isConfirmed mapping and then check isConfirmed for msg.sender is equal to false.
        _;
    }

    //constructors to initialize state variables
    //Inputs: array of owners, No. of confirmations required.
    constructor(address[] memory _owners, uint _numConfirmationsRequired) { 
        //Check array of owners is not empty
        require(_owners.length > 0, "owners required");
        //Check No. of confirmations required is greater than 0 and also less than or equal to number of owners
        require(
            _numConfirmationsRequired > 0 &&
                _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        //We will copy the owners from input array into the state variables owners
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i]; //Get the owner from index i and store in a variable

            require(owner != address(0), "invalid owner"); //owner shouldn't be a zero address
            require(!isOwner[owner], "owner not unique"); //Check duplicate owners, We can check if address is already owner or not.

            isOwner[owner] = true; //After checking that address is not already an owner, just make it true
            owners.push(owner); //Push or add the address (owner) to the owners state variable
        }

        numConfirmationsRequired = _numConfirmationsRequired; //set no. of confirmations required
    }

    //fallback function to send Ether to this contract, when the fallback function is called, we will emit the Deposit event.

    // function() external payable {
    //     emit Deposit(msg.sender, msg.value, address(this).balance);
    // }  ////deprecated

    //NOTE: Helper function to easily deposit in remix.
    function deposit() external payable{
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }
    
    //or,
    //To deposi Ethers to this contract address
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function getBalance() external view returns(uint){
        return address(this).balance;
    }


    //When owner submit a transation, they will need to send the address that the transaction is for, the amount that is going to be sent to the address and the transction data that is going to be sent
    function submitTransaction(
        address _to, 
        uint _value,
        bytes memory _data
    ) public onlyOwner {  //Only allow the owner of the contract to call this function
        uint txIndex = transactions.length; //We need ID for the transaction that we're about to create, and for the ID, we are just going to use current length of  transactions array. That means, first transaction will have ID of 0, second will have ID have 1 and so on..

        //We initialize the Transaction struct and append it to the array of transactions. 
        // executed is set to false, and numConfirmations is set to 0

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);//Lastly, we will emit the SubmitTransation event.
    }

    //Once the owner submit a transaction, they'll be able to approve the transaction by calling confirmTransaction with input "transation ID" that is going to be confirmed.
    //We only want the owner to call this function, transaction should be exist, if the transaction exists, it shouldn't be executed, owner shouln't have confirmed the transactions yet i.e owner will only be able to confirm the transaction once. So we use modifiers here.
    function confirmTransaction(uint _txIndex)
        public
        onlyOwner 
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex) 
    {
        Transaction storage transaction = transactions[_txIndex]; //To update the transaction struct, we will first get the transactions at the _txIndex
        
        isConfirmed[_txIndex][msg.sender] = true; //we will set isConfirmed for msg.sender to true
        transaction.numConfirmations += 1; //Increment the numConfirmations by 1
        emit ConfirmTransaction(msg.sender, _txIndex); //Finally emit the ConfirmTransaction event with msg.sender and _txIndex that was confirmed.
    }

    //Once enough owners confirm a transation, they'll be able to execute it. To execute a transaction, wee need to pass the index of the transaction. The function should be public
    //Only owner will call the function. Transaction should exist and it should n't be executed yet.
    function executeTransaction(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex]; //To actually execute a transaction, we'll first get the transaction struct

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx"
        ); 
        //Then, require that the number of owners that confirm this transaction is greater than or equal to minimum number of confirmations required to execute any transactions.

        transaction.executed = true; //If there are enough confirmations, we'll first set executed to true

        // Then, we execute the transaction by usinf the call method and check that the call was successfull.
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex); //Finally, emit the ExecuteTransaction event with the owner taht call this function and the transaction (_txIndex) that was executed.
    }

    function revokeConfirmation(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        isConfirmed[_txIndex][msg.sender] = false;
        transaction.numConfirmations -= 1;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex)
        public
        view
        returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}

//Topics/Features included

/*
 event
 array
 mapping
 struct
 constructor
 error
 for loop
 fallback and payable
 function modifier
 call
 view function
*/

//Demo

/* 
1. Send Ether to an account
2. Call another contract
*/

//Deploy contract

//2 out of 3 Multi-sig wallet


/* 3 accounts: 

["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]

*/

//1. Send Ether to an account
/*

["0x617F2E2fD72FD9D5503197092aC168c91465E7f2",1000000000000000000,0x00]
_to : 0x617F2E2fD72FD9D5503197092aC168c91465E7f2
_value: 1000000000000000000 (1 Ether)
_data: 0x00 (we are sending 0 bytes as we are not calling another contracts)

*/

//2. Call another contract

/*
    _to (contract address): 0x929336a17aF293b16d025170e310d7C408C5447e 
    _value: 0
    bytes: 0xe73620c3000000000000000000000000000000000000000000000000000000000000007b

*/