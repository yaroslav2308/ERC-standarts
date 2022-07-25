// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../InterfaceERC20.sol";
import "../YarikToken.sol";

contract SomeShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint amount, address indexed buyer);
    event Sold(uint amount, address indexed seller);

    constructor() {
        token = new YarikToken(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "address not an owner");
        _;
    }

    // user have to give permission (allowance) to take his tokens
    function sell(uint amount) external {
        require(amount > 0, token.balanceOf(msg.sender) >= amount, "incorrect amount");
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "check allowance");

        token.transferFrom(msg.sender, recipient, amount);
    }

    receive() external payable {
        uint tokensToBuy = msg.value; // 1 wei = 1 token
        require(tokensToBuy > 0, "not enough funds");

        uint currentBalance = tokenBalance();
        require(currentBalance >= tokensToBuy, "not enough tokens");

        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }

    
}