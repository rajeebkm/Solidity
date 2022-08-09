// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DeployWithCreate2{
    address public owner;
    constructor(address _owner){
        owner = _owner;
    }
}

contract Create2Factory{
    event Deploy(address addr);

    function deploy(uint _salt) external{
        // DeployWithCreate2 _contract = new DeployWithCreate2(msg.sender); /* General way of deploying contract */
        DeployWithCreate2 _contract = new DeployWithCreate2{
            salt: bytes32(_salt) /* Use create2 to deploy the contract. salt is basically a random number of ourchoice 
            which determines the address of the contract that will be deployed. */
        }(msg.sender);
        emit Deploy(address(_contract));
    }

    //How do we know the address of the contract to be deployed before we deploy it ?
    /* address of the contract to be deployed using create2 is determined by this below function. */

    function getAddress(bytes memory bytecode, uint _salt) public view returns(address){
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))); /* We are deploying 
            from this contract,so address(this) is the deployer. */
        /* address will be the last 20 bytes of the hash. So we cast hash to uint and then cast
        to uint160 and then cast it to address. */
        return address(uint160(uint(hash)));
    }
    
    // To get bytecode of the contract to be deployed
    function getByteCode(address _owner) public pure returns(bytes memory){
        /* first get the creation code of the contract to be deployed. and then to this 
        code we append the constructor argument, here is constructor argument is _owner  */
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));

    }
    /* Just compare two addresses. One is pre-computedand from getAddress(), 
    and the actual address of the contract that was deployed using create2 (deploy(). */
}