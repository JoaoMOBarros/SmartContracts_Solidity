// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Agreement{

    address payable public seller;
    address payable public buyer;
    uint public value;

    enum State {Created, Locked, Released, Inactive}

    State public state;

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value/2;
    }

    /// The function cannot be called at the current state
    error InvalidState();

    ///Only the seller can call this function
    error OnlySeller();

    ///Only the buyer can call this function
    error OnlyBuyer();

    modifier onlySeller(){
        if(msg.sender != seller){
            revert OnlySeller();
        }
        _;
    }

    modifier onlyBuyer(){
        if(msg.sender != buyer){
            revert OnlyBuyer();
        }
        _;
    }

    modifier inState(State state_){
        if(state != state_){
            revert InvalidState();
        }
        _;
    }

    function confirmPurchase() external inState(State.Created) payable {
        require(msg.value >= (2*value), "Please send in 2x the purchase amount");
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    function confirmReceived() external onlyBuyer inState(State.Locked){
        state = State.Released;
        buyer.transfer(value);
    }

    function paySeller() external onlySeller inState(State.Released){
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }

    function abort() external onlySeller inState(State.Created){
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }

    function withdraw() external onlySeller inState(State.Locked){
        state = State.Inactive;
        buyer.transfer(2*value);
        seller.transfer(address(this).balance);
    }


}