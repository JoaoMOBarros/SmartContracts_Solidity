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


}