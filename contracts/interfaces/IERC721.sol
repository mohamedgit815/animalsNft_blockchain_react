// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

interface IERC721 {
    function balanceOf(address owner_) external view returns(uint256);

    function ownerOf(uint256 tokenId_) external view returns(address);
}