// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address payable owner;
    address payable[] public players;

    constructor(){
        owner = payable(msg.sender);
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    function enter() public payable{
        require(msg.value > 0.1 ether);
        players.push(payable(msg.sender));
    }

    function getRandomNumber() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner{
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }

    modifier onlyowner(){
        require(msg.sender == owner);
        _;
    }
}