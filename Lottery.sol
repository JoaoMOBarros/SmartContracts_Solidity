// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address payable owner;
    address payable[] public players;
    mapping (uint => address payable) lotteryWinners;
    uint lotteryId;

    constructor(){
        owner = payable(msg.sender);
        lotteryId = 1;
    }

    function getWinnerByLotteryId (uint id) public view returns (address payable){
        return lotteryWinners[id];
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    function enter() public payable{
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }

    function getRandomNumber() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyowner{
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        lotteryWinners[lotteryId] = payable(players[index]);
        lotteryId++;

        players = new address payable[](0);
    }

    modifier onlyowner(){
        require(msg.sender == owner);
        _;
    }
}