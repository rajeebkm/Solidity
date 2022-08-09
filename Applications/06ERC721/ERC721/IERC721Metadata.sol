// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./IERC721.sol";

/**
 *  ERC-721 Non-Fungible Token Standard, optional metadata extension
 *  See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     *  Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     *  Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     *  Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}