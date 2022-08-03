// Verifying Signature
// Messages can be signed off chain and then verified on chain using a smart contract.

//The process of verifying signature in solidity is in four steps:
/*
    0. message to sign
    1. hash(message)
    2. sign(hash(message), private key) | off chain using wallet
    3. ecrecover(hash(message), signature) == signer (ecrecover function will return a signer, we can check that the signer that was returned from the ecrecover function is actually equal to the true signer that sign the message)
 */

contract VerifySignature{

    //verify function takes signer, message, and signature, and verify that signature is valid. The address of signer (_signer) that we expect ecrecover to return. If the signature is valid and the signer that was returned by ecrecover is actually to the signer from the input, then it will return true
    function verify(address _signer, string memory _message, bytes memory _sig) external pure returns (bool){
        //we can hash the message by keccak265, hash will be bytes32
        bytes32 messageHash = getMessageHash(_message); 
        //When we actually sign the message off chain, the message that is signed is not "messageHash" (hash of the message). The hash that is actually signed is also bytes32, named it to "ethSignedMessageHash"
        // "ethSignedMessageHash" is off chain signed hash that will be verified with the signature.
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash); 
        // "ethSignedMessageHash" will be verified with signature, ecrecover returns the signer, which will be matched with actual signer (_signer) from the input.
        return recover(ethSignedMessageHash, _sig) == _signer; 
    }

    // keccak256 returns bytes32 hash of the message.
    function getMessageHash(string memory _message)public pure returns (bytes32){
        return keccak256(abi.encodePacked(_message));
    }
    // When we actually sign the "messageHash", this hash (messageHash) will be prefixed with some strings and then hashed (signed) again. That will be the actual message that is signed ("ethSignedMessageHash").
    function getEthSignedMessageHash(bytes32 _messageHash)public pure returns(bytes32){
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)); 
        //The string that is prefixed to messageHash is some string with the message "Ethereum Signed Message" followed by the length of the message bytes32 (32). We append the actual messageHash and take keccak256 of the whole string. This is the actual message that is signed when we sign a message offchain.
    }

    //// Once we have the actual message that is signed, recover function will take the "ethSignedMessageHash" and "_sig", and recover the signer from these inputs ("ethSignedMessageHash" and "_sig") that we can verify or match with the actual signer (_signer).
    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig)public pure returns (address){
        //Split the _sig into 3 parts
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig); //r and s are cryptographic parameters used for digital signatures, and the parameter v is something unique to Ethereum. These parameters are passed into the ecrecover function with the signed message.
        return ecrecover(_ethSignedMessageHash, v, r, s); //This function returns the address of the signer, given the signed message and these parameters
    }

    //Split signature into 3 parameters
    function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v){

        //Check the length of signature is equal to 65 (bytes32 is 32 length, uint8(1 byte) is 1 length, so 32+32+1 = 65)
        require(_sig.length == 65, "invalid signature length");

        //We will get r, s and v from _sig with the help of assembly.
        // _sig is a dynamic data because it has a variable length. For dynamic data types, the first 32bytes stores the length of the data
        // This variable _sig is not the actual sigature. It's a pointer to where the signature is stored in memory. With those in mind, we can get the values of r, s, v.

        assembly {
            r := mload(add(_sig, 32)) //mload(): This will go to memory 32 bytes from the pointer that we provide into this input. The first 32 bytes of _sig is the length of the _sig, we can write add() to the pointer _sig and 32 like "mload(add(_sig, 32))". 
            // := (assigned)

            // From the pointer of _sig, skip the first 32 bytes because it holds the length of the array. After we skip the first 32 bytes the value for r is stored in next 32 bytes
            s := mload(add(_sig, 64)) //Assigned to mload (load from memory) add to the pointer of _sig, skips first 32 (length)m skip another 32 (holds value for r) 
            v := byte(0, mload(add(_sig, 96))) //For v we don't need 32 bytes, we only need first byte from the 32 bytes after 96.
        }

        // return (r, s, v); //Because the reurn is implicit


    }


}


//Explainations

/* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/

contract VerifyingSignature {
    /* 1. Unlock MetaMask account
    ethereum.enable()
    */

    /* 2. Get message hash to sign
    getMessageHash(
        0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
        123,
        "coffee and donuts",
        1
    )

    hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
    */
    function getMessageHash(
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /* 3. Sign message hash
    # using browser
    account = "copy paste account of signer here"
    ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

    # using web3
    web3.personal.sign(hash, web3.eth.defaultAccount, console.log)

    Signature will be different for different accounts
    0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */
    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        /*
        Signature is produced by signing a keccak256 hash with the following format:
        "\x19Ethereum Signed Message\n" + len(msg) + msg
        */
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
            );
    }

    /* 4. Verify signature
    signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
    to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
    amount = 123
    message = "coffee and donuts"
    nonce = 1
    signature =
        0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
    */
    function verify(
        address _signer,
        address _to,
        uint _amount,
        string memory _message,
        uint _nonce,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
}
