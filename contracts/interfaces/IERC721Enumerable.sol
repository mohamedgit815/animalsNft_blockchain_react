// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;




interface IERC721Enumerable {
    
    function totalSupply() external view returns(uint256);

    function tokenByIndex(uint256 index_) external view returns(uint256);

}