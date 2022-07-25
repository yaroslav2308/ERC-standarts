// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./InterfaceERC20.sol";

contract ERC20 is IERC20 {
    address owner;
    uint totalTokens;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;
    
    function name() external view returns(string memory) {
        return _name;
    }

    function decimals() external view returns(uint) {
        return 18; // 
    }

    function totalSupply() external view returns(uint) {
        return totalTokens;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    modifier enoughTokens(address _from, uint amount) {
        require(balanceOf(_from) >= amount, "not enough tokens" );
        _;
    }
    

    modifier onlyOwner() {
        require(msg.sender == owner, "address not an owner");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(msg.sender, shop, amount);
        balances[shop] += amount;
        totalTokens += amount;

        emit Transfer(msg.sender, shop, amount);
    }

    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function burn(address _from, uint amount) public onlyOwner enoughTokens(_from, amount) {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function allowance(address _owner, address spender) public view returns(uint) {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) public {
        _approve(msg.sender, spender, amount);
    }

    function _approve(address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) external enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);

        allowances[sender][recipient] -= amount; // error if recipient is not allowed to transfer tokens 
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {
        
    }
}

contract YarikToken is ERC20 {
    constructor(address shop) ERC20("YarikToken", "YRK", 200, shop) { }
}

contract SomeShop {
    IERC20 public token;
    address payable public owner;
    event Bought(uint amount, address indexed buyer);
    event Sold(uint amount, address indexed seller);

    constructor() {
        token = new YarikToken(address(this));
    }
}