// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract VendingMachine {
    address public owner;
    mapping (address => uint) public donutBalances;

    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    function restock (uint amount) public {
        require( msg.sender == owner, "Only the machine owner can restock it");
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable{
        require(msg.value >= amount * 2 ether, "You must pay at least 3 ETH per donut");
        require(donutBalances[address(this)] >= amount, "There is not enough donuts to fulfill your request");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }

    //add comment
}