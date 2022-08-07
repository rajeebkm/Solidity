// Contract to swap tokens

// Here is an example contract, TokenSwap, to trade one ERC20 token for another.

/* This contract will swap tokens by calling "transferFrom(address sender, address recipient, uint256 amount" which will transfer amount of token from sender to recipient.

/* For transferFrom to succeed, sender must: 
1. have more than amount tokens in their balance, 
2. have allowed "TokenSwap" to withdraw amount tokens by calling "approve" prior to "TokenSwap* calling *transferFrom". */

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

/*
How to swap tokens

1. Alice has 100 tokens from AliceCoin, which is a ERC20 token.
2. Bob has 100 tokens from BobCoin, which is also a ERC20 token.
3. Alice and Bob wants to trade 10 AliceCoin for 20 BobCoin.
4. Alice or Bob deploys TokenSwap
5. Alice approves TokenSwap to withdraw 10 tokens from AliceCoin
6. Bob approves TokenSwap to withdraw 20 tokens from BobCoin
7. Alice or Bob calls TokenSwap.swap()
8. Alice and Bob traded tokens successfully.
*/

contract TokenSwap {
    IERC20 public token1;
    address public owner1;
    IERC20 public token2;
    address public owner2;

    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }

    function swap(uint amount1, uint amount2) public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(
            token1.allowance(owner1, address(this)) >= amount1,
            "Token 1 allowance too low"
        );
        require(
            token2.allowance(owner2, address(this)) >= amount2,
            "Token 2 allowance too low"
        );

        _safeTransferFrom(token1, owner1, owner2, amount1);
        _safeTransferFrom(token2, owner2, owner1, amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

/* 
token1 Contract: 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d (RAJ Token)
token1 Contract deployed Owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
totalSupply: 100 RAJ
After Swap: 90 RAJ, 20 JIT (account: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)


token2 Contract: 0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7 (JIT Token)
token2 Contract deployed Owner: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
totalSupply: 100 JIT
After Swap: 80 JIT, 10 RAJ (account: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2)


TokenSwap Contract: 0x11bcD925D9c852a3eb40852A1C75E194e502D2b9
TokenSwap Contract deployed owner: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
amount1 = 10 RAJ
amount2 = 20 JIT

*/


