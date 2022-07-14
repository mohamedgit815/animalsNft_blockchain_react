// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

import "./interfaces/IERC721Metadata.sol";
import "./ERC165.sol";


contract ERC721Metadata is IERC721Metadata , ERC165{
      string private _name;
      string private _symbol;

      constructor(string memory name_,string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _registerInterface(
            bytes4(keccak256("name(bytes4)")) ^
            bytes4(keccak256("symbol(bytes4)")) 
            );
      }

      function name() external view returns(string memory){
        return _name;
      }

      function symbol() external view returns(string memory){
        return _symbol;
      }

}