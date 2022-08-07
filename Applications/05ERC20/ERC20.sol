// ERC20
// Any contract that follow the ERC20 standard(https://eips.ethereum.org/EIPS/eip-20) is a ERC20 token.

// ERC20 tokens provide functionalities to

// transfer tokens
// allow others to transfer tokens on behalf of the token holder (approve, allowance, transferFrom)


// Here is the interface for ERC20.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


//Importing Openzeppelin ERC20 contract. Create your own ERC20 contract

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

// contract MyContract is ERC20{
//     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
            // Mint 1000 tokens to msg.sender
            // Similar to how
            // 1 dollar = 100 cents
            // 1 token = 1 * (10 ** decimals)
//         _mint(msg.sender, 1000 * 10 ** decimals());
//     }
// }

//Or,
// Example of ERC20 token contract.

contract ERC20 is IERC20 {

    /* To keep track of total supply of tokens. If we mint tokens, totalSupply will increase, and 
    if we burn tokens, totalSupply will decrease. */
    uint public totalSupply;
    /* Use mapping to check how much token balances, each user has */
    mapping(address => uint) public balanceOf;
    /* When a ERC20 token holder calls the function approve, approving the spender to spend some of his tokens
    on his behalf, we need save that somewhere in a state variable, called allowances. We will do mapping
    from owner address to another mapping from spender address to the amount. Here, we're atoring the data
    that owner approves the spender to spend certain amount. */
    mapping(address => mapping(address => uint)) public allowance;
    /* We'll store the metadata about the ERC20 token (name, symbol, & decimals) */
    string public name = "RAJ TOKEN";
    string public symbol = "RAJ";
    /* Most ERC20 tokens have decimals 18. 'decimals' means how many zeros are used to represent
    1 ERC20 tokens. For example, U.S Dollar has 2 decimal places (1.00 USD = 100 cents (2 decimals)), 
    1 ETH = 10 ** 18 wei (18 decimals). 1 ETH is easily divisible to 18 decimal places, so we can buy 0.000000000000000001 ETH if we want.Here 18 means 10 ** 18 zeros are used to represent 1 ERC20 token */
    uint8 public decimals = 18; 

    /* We have to implement IERC20 functions over here */

    /* When we transfer a token from msg.sender to recipient, we want to update the balanceOf mapping.*/
    function transfer(address recipient, uint amount) external returns (bool){
        balanceOf[msg.sender] -= amount; //balance0f[msg.sender] will be decreased by amount.
        balanceOf[recipient] += amount; //balance0f[recipient] will be increased by amount.
        //When transfer function is called for the ERC20 standard,we need to emit the event
        emit Transfer(msg.sender, recipient, amount);
        return true; //This means function to this call was successful.
    }

    /* msg.sender will be able to approve the spender to spend some of his balance for the amount*/
    function approve(address spender, uint amount) external returns (bool){
        //msg.sender is allowing the spender to spend amount of his token
        allowance[msg.sender][spender] = amount;
        //We also need to emit the event.
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /* transferFrom function will transfer some token from sender to the recipient for the amount 
    from the input, and this function is called by anyone as long as the sender has approves the
    msg.sender to spend his tokens. */
    function transferFrom(address sender, address recipient, uint amount) external returns (bool){
        /* Reduce the allowance between sender and spender (msg.sender) by amount. In solidity 0.8, overflows and underflows cause the error to a function. So if sender has't approved msg.sender to spend his tokens, then "allowance[sender][msg.sender] -= amount;" will fail.*/
        allowance[sender][msg.sender] -= amount; 
        balanceOf[sender] -= amount; //Reduce the sender balance by amount
        balanceOf[recipient] += amount; //Increase the recipient balance by amount
        /* Again for the transferFrom, we also need to emit the event Transfer. */
        emit Transfer(sender, recipient, amount);
        return true; //Finally we will return true, means this function executed correctly without fail.
    }

    /* To mint ERC20 tokens. This minting function is restricted in some way. For ex: you can only 
    mint tokens in exchange for sending some ETH or,maybe only owner of this contract can mint some tokens.
    For simplicity, we will create a mint function which will allow msg.sender to mint any amount of tokens 
    */

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount; //Increment the balanceof msg.sender
        totalSupply += amount; //Increment the totalSupply as we are creating new tokens
        /* We need to emit Transfer event. We aren't sending existing tokens from another account 
        instead we are creating new tokens, so we set the sender to address(0). */
        emit Transfer(address(0), msg.sender, amount);
    }


    /* To burn or destroy the tokens means reduce tokens amount from circulation. */
    function burn(uint amount) external {
         balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount); //We transfer tokens from msg.sender to address(0).
    }
}


