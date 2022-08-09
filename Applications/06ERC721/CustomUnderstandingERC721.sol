// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// interface ERC721 {

//     /* To check number of assets owned by an address. Suppose, balanceOf of an account is 5, that means that account holds 5 different assets for this token, not 5 times the same assets. */
//     function balanceof(address _owner) external view returns(uint256); 

//     /* To check the ownership of an asset */
//     function ownerOf(uint256 _tokenId) external view returns(address);

//     /* Couple of functions to transfer token. These two safeTransferFrom function are used to transfer
//     assets in a safe way. Here we will check, if the recipient is a samrt contract, it will make sure that
//     it implements an interface. Behind the hood, it will use ERC165. If the recipient smart contract doesn't implement the recipient interface of ERC721, transfer is going to fail */
//     function safeTransferFrom(
//         address _from, 
//         address _to,
//         uint256 _tokenId,
//         bytes data) external payable;

//     //Overloaded function
//     function safeTransferFrom(
//         address _from,
//         address _to,
//         uint256 _tokenId) external payable;

//     /* Unlike ERC20, we don't have two different transfer functions i.e. normal and delegated transfer 
//     function. We can do simple transfer and delegated transfer. We don't need to specify the amount of tokens.
//     only specify the tokenId as each asset is unique and quantity is irrelevant. */
//     function transferFrom(
//         address _from,
//         address _to,
//         uint256_tokenId) external;

//     /* Approval mechanism to do delegated transfer. We need to specify the address that we want to 
//     approve and the tokenId i.e we have to approve a address for specific asset, not for all the assets.
//     We don't need to specify the quantity. */
//     function approve(address _approved, uint256 _tokenId) external payable;

//     //To know the approved address for specific tokenId
//     function getApproved(uint256 _tokenId) external view returns(address);

//     //Approve an address for all your assets
//     function setApprovalForAll(address _operator, bool _approved) external;

//     //To check whether approved for all assets
//     function isApprovedForAll(
//         address _owner,
//         address _operator
//         ) external view returns (bool);
// }

// //If you want your receiver smart contract to receive ERC721 token, you need to implement onERC721Received function and it will return specific constants (bytes4)
// interface ERC721TokenReceiver{
//     function onERC721Received(
//         aadress _operator,
//         address _owner,
//         uint256 _tokenId,
//         bytes _data) external returns(bytes4);
    
// }

// /* Two optional interfaces

// 1. ERC721Metadata: ERC721 token can optionally implement some set of functions, name() and symbol() are same as ERC20 and, tokenURI() that will return a string that is pointing to an URL that's going to return a JSON document that describe your token. Just to be clear, this JSON document is outside of the blockchain.

// 2. ERC721Enumerable: 
// a. totalSupply() gives the total number of assets managed by ERC721 contract.
// b. tokenByIndex() is going to return tokenId for each token. If you want to eneumerate all the assets that are tracked by the contract, then first you call totalSupply(), then each of the integer from 0 index upto (totalSupply-1) index, you will get tokenId. tokenId will be decided arbitarily based on implementation, not necessarily similar to tokenIndex.
// c. tokenofOwnerByIndex(): We can enumerate all the assets owned by a specific address. First you call balanceOf(), it will give the number of assets owned by this specific address, then call the function by passing owner (that specific address) and index upto the balanceOf(address). Exactly same with tokenByIndex, but this function is for specif address.

// */
// interface ERC721Metadata{
//     function name() external view returns(string _name);
//     function symbol() external view returns(string _symbol);
//     function tokenURI(uint256 _tokenId) external view returns(string _tokenURI); 
// }

// interface ERC721Enumerable {
//     function totalSupply() external view returns(uint256);
//     function tokenByIndex(uint256 _index) external view returns(uint256);
//     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns(uint256);
// }



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns (uint balance);

    function ownerOf(uint tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    // Mapping from token ID to owner address
    mapping(uint => address) internal _ownerOf;

    // Mapping owner address to token count
    mapping(address => uint) internal _balanceOf;

    // Mapping from token ID to approved address
    mapping(uint => address) internal _approvals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    function ownerOf(uint id) external view returns (address owner) {
        owner = _ownerOf[id];
        require(owner != address(0), "token doesn't exist");
    }

    function balanceOf(address owner) external view returns (uint) {
        require(owner != address(0), "owner = zero address");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function approve(address spender, uint id) external {
        address owner = _ownerOf[id];
        require(
            msg.sender == owner || isApprovedForAll[owner][msg.sender],
            "not authorized"
        );

        _approvals[id] = spender;

        emit Approval(owner, spender, id);
    }

    function getApproved(uint id) external view returns (address) {
        require(_ownerOf[id] != address(0), "token doesn't exist");
        return _approvals[id];
    }

    function _isApprovedOrOwner(
        address owner,
        address spender,
        uint id
    ) internal view returns (bool) {
        return (spender == owner ||
            isApprovedForAll[owner][spender] ||
            spender == _approvals[id]);
    }

    function transferFrom(
        address from,
        address to,
        uint id
    ) public {
        require(from == _ownerOf[id], "from != owner");
        require(to != address(0), "transfer to zero address");

        require(_isApprovedOrOwner(from, msg.sender, id), "not authorized");

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint id,
        bytes calldata data
    ) external {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function _mint(address to, uint id) internal {
        require(to != address(0), "mint to zero address");
        require(_ownerOf[id] == address(0), "already minted");

        _balanceOf[to]++;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function _burn(uint id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;

        delete _ownerOf[id];
        delete _approvals[id];

        emit Transfer(owner, address(0), id);
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint id) external {
        _mint(to, id);
    }

    function burn(uint id) external {
        require(msg.sender == _ownerOf[id], "not owner");
        _burn(id);
    }
}