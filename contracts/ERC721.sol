// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

import "./interfaces/IERC721.sol";
import "./ERC165.sol";


contract ERC721 is IERC721 , ERC165{
    mapping (uint256=>address) private _tokenOwners;
    mapping (address=>uint256) private _tokenOwnerOwned;

    constructor() {
        _registerInterface(
            bytes4(keccak256("balanceOf(bytes4)")) ^
            bytes4(keccak256("ownerOf(bytes4)")) ^
            bytes4(keccak256("_mint(bytes4)"))
            );
    }

    event Transfer(address indexed from , address indexed to , uint256 indexed tokenId);
    
    function _exits(uint256 tokenId_) internal view returns(bool) {
        address _owner = _tokenOwners[tokenId_];
        return _owner == address(0);
    }


    function balanceOf(address owner_) external override view returns(uint256) { 
        require(owner_ != address(0) , "This Address not Aviable");
        return _tokenOwnerOwned[owner_];
    }


    function ownerOf(uint256 tokenId_) external override view returns(address){
        require(!_exits(tokenId_) , "This Address not Aviable");
        return _tokenOwners[tokenId_];
    }

    
    function _mint(address to , uint256 tokenId) internal virtual{
        require(to != address(0),"Can not mint to Address Zero");
        require(_exits(tokenId),"Token Alerdy Minted");

        _tokenOwners[tokenId] = to;
        _tokenOwnerOwned[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }


}