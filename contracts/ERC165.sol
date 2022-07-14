// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <8.10.0;

import "./interfaces/IERC165.sol";


contract ERC165 is IERC165 {

    mapping(bytes4=>bool) private _supportedInterfaces;

    function supportsInterface(bytes4 interfaceId_) external view returns(bool) {
        return _supportedInterfaces[interfaceId_];
    }

    function _registerInterface(bytes4 interfaceId_) internal {
        require(interfaceId_ != 0xffffffff,"Invalid Interface ID");

        _supportedInterfaces[interfaceId_] = true;
    }
}