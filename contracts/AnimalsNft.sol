// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

import "./ERC721Enumerable.sol";
import "./ERC721Metadata.sol";

contract AnimalNft is ERC721Metadata , ERC721Enumerable {

    constructor() ERC721Metadata("Mohamed Elsherif","SymbolNft") {
        _registerInterface(
            bytes4(keccak256("mint(bytes4)")) ^
            bytes4(keccak256("getAnimalsNft(bytes4)"))
            );
    }

    string [] animalNft;
    mapping(string=>bool) private _animalExits;


    function mint(string memory _animalUrl) public {
        require(!_animalExits[_animalUrl],"This Nft Url Token Already Exists");

        animalNft.push(_animalUrl);
        uint256 _id = animalNft.length - 1; 
        _animalExits[_animalUrl] = true;
        _mint(msg.sender, _id);
    }


    function getAnimalsNft() public view returns(string [] memory){
        return animalNft;
    }
    
}