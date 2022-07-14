// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";


contract ERC721Enumerable is ERC721 , IERC721Enumerable {
    uint256 [] private _allTokens;

     constructor() {
        _registerInterface(
            bytes4(keccak256("totalSupply(bytes4)")) ^
            bytes4(keccak256("tokenByIndex(bytes4)"))
            );
    }


    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }
    
    function tokenByIndex(uint256 index_) public view returns(uint256) {
        require(index_ < totalSupply(),"Your Index Invalid");
        return _allTokens[index_];
    }

    function _addTokenToTotalSupply(uint256 tokenId_) private {
        _allTokens.push(tokenId_);
    }
    

    mapping(address=>uint256[]) private _ownedTokens;
    mapping(uint256=>uint256) private _allTokensByIndex;
    mapping(uint256=>uint256) private _ownedTokensIndex;


    function _addTokenToAll(uint256 tokenId_) private {
        _allTokensByIndex[tokenId_] = _allTokens.length;
        _allTokens.push(tokenId_);
    }

    function _addTokenToTheOwners(address to_ , uint256 tokenId_) private {
        _ownedTokensIndex[tokenId_] = _ownedTokens[to_].length;
        _ownedTokens[to_].push(tokenId_);
    }

    function tokenOfOwnerByIndex(address owner_ , uint256 index_) external view returns(uint256) {
        return _ownedTokens[owner_][index_];
    }


       function _mint(address to,uint256 tokenId)internal override(ERC721) {
        super._mint(to,tokenId);
        _addTokenToAll(tokenId);
        _addTokenToTheOwners(to, tokenId);   
    } 
    

    
}