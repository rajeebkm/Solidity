// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract FixedStaking is ERC20 {
    mapping(address => uint) public staked;
    mapping(address => uint) private stakedFromTS;

    constructor() ERC20("Fixed Staking", "FIX") {
        _mint(msg.sender, 1000000000000000000);
    }

    function stake(uint amount) external {
        require(amount > 0, "amount <= 0");
        require(balanceOf(msg.sender) >= amount, "balance < amount");
        _transfer(msg.sender, address(this), amount);
        if(staked[msg.sender] > 0) {
            claim();
        }
        stakedFromTS[msg.sender] = block.timestamp;
        staked[msg.sender] += amount;
    }

    function unstake(uint amount) external {
        require(amount > 0, "amount <= 0");
        require(staked[msg.sender] >= amount, "amount is > staked");
        claim();
        staked[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
    }

    function claim() public {
        require(staked[msg.sender] > 0, "staked is <= 0");
        uint256 secondsStaked = block.timestamp - stakedFromTS[msg.sender];
        uint256 rewards = staked[msg.sender] * secondsStaked / 3.1536e7; // 1:1 per year
        _mint(msg.sender,rewards);
        stakedFromTS[msg.sender] = block.timestamp;
    }
}