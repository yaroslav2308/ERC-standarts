// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../IERC20.sol";
import "../YarikToken.sol";

contract SomeShopERC20 {
    IERC20 public token;
    address payable public owner;
    event Bought(uint amount, address indexed buyer);
    event Sold(uint amount, address indexed seller);

    constructor() {
        owner = payable(msg.sender);
        token = new YarikToken(address(this));
    }

    
    modifier onlyOwner() {
        require(msg.sender == owner, "address not an owner");
        _;
    }

    function setToken(address tokenAddress) public onlyOwner {
        token = YarikToken(tokenAddress);
    }

    // user have to give permission (allowance) to take his tokens
    function sell(uint amountToSell) external {
        require(amountToSell > 0 && token.balanceOf(msg.sender) >= amountToSell, "incorrect amount");
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amountToSell, "check allowance"); 

        token.transferFrom(msg.sender, address(this), amountToSell);
        payable(msg.sender).transfer(amountToSell);

        emit Sold(amountToSell, msg.sender);
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }
    
    receive() external payable {
         // 1 wei = 1 token
        require(msg.value > 0, "not enough funds");

        require(tokenBalance() >= msg.value, "not enough tokens");

        token.transfer(msg.sender, msg.value);
        emit Bought(msg.value, msg.sender);
    }
}