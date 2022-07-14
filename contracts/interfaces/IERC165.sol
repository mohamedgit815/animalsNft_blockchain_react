// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns(bool);
}