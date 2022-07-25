// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract YarikToken is ERC20 {
    constructor(address shop) ERC20("YarikToken", "YRK", 200, shop) { }
}