// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC721.sol";

interface IERC721MetaData is IERC721 {
    function name() external view returns(string memory);

    function symbol() external view returns(string memory);

    // returns link which represents current location of our image
    function tokenURI(uint tokenId) external view returns(string memory);
}