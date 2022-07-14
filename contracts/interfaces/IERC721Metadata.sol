// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

interface IERC721Metadata {
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
}