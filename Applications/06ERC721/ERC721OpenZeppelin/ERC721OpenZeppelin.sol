// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.2/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.2/security/Pausable.sol";
import "@openzeppelin/contracts@4.7.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.2/utils/Counters.sol";

contract HappyMonkey is ERC721, ERC721Enumerable, Pausable, Ownable {

    //==== 1. Property Variables ====//

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    /* Define a Mint price */
    uint256 public MINT_PRICE = 0.05 ether;
    /* Define Maximum Supply */
    uint256 public MAX_SUPPLY = 10000;

    //==== 2. LifeCycle Methods ====//
    /* Increment the token counter. Default tokenID starts with 0, but we start at 1 */

    constructor() ERC721("HappyMonkey", "HM") {
        _tokenIdCounter.increment();
    }

    /* Create withdraw() function to withdraw funds from this contract */
    function withdraw() public onlyOwner{
        require(address(this).balance > 0, "Balance is zero.");
        payable(owner()).transfer(address(this).balance);
    }


    //==== 3. Pausable Functions ====//

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    //==== 5. Minting Functions ====//
    /* 
    Remove the modifier "onlyOwner" so, anyone can call safeMInt().
    Add require statement for msg.value >= MINT_PRICE. Check if ether value is correct.
    Add payable to the safeMint function
    */

    function safeMint(address to) public payable {
         /* Check that totalSupply is less than Maximum Supply.*/
        require(totalSupply() < MAX_SUPPLY, "Cann't mint anymore tokens.");
        /* Check if ether value is correct.*/
        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    //==== 4. Other Functions ====//


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://happyMonkeyBaseURI/";
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

/* NOTES:

contract address: 0xf8e81D47203A594245E36C48e151709F0C19fBe8

owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    Deploy the contract
    Can only call onlyOwner modifier function

account 2: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    - Mint 1 NFT
    - 0.05 ETH = 0.05*10**18 wei = 500000000000000000 wei

account 3: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    - account 2 will transfer NFT to account 3. As account 2 is holding that NFT, that can call transferFrom()

*/
