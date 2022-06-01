// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import './User.sol';
import './Trial.sol';

contract Report{

    enum States {Review, Published, Flagged}

    User public owner;
    uint public createdAt;
    Trial trial;

    mapping (address => int) public peerReview;
    string public package;
    string public version;
    int public votes;
    uint public level;
    States public state;

    constructor(User _user, string memory packageName, string memory packageVersion, uint threatLevel){
        owner = _user;
        package = packageName;
        version = packageVersion;
        votes = 0;
        level = threatLevel;
        createdAt = block.timestamp;
        state = States.Review;
    }

    modifier removePreviousReview(){
        if(peerReview[msg.sender] != 0){
            votes -= peerReview[msg.sender];
            peerReview[msg.sender] = 0;
        }
        _;
    }

    /// You have to wait until the judging is performed.
    error NotJudged();

    modifier ifPublished(States _state){
        if(_state != States.Published){
            revert NotJudged();
        }
        _;
    }

    /// The owner cannot vote in its own report
    error OnlyPeer();

    modifier onlyPeer(){
        if(msg.sender == owner.owner()){
            revert OnlyPeer();
        }
        _;
    }

    /// Only the owner of report can call this function
    error OnlyOwner();

    modifier onlyOwner(){
        if(msg.sender != owner.owner()){
            revert OnlyOwner();
        }
        _;
    }

    function upvote() external removePreviousReview() onlyPeer() ifPublished(state){
        peerReview[msg.sender] = 1;
        votes++;
    }

    function downvote() external removePreviousReview() onlyPeer() ifPublished(state){
        peerReview[msg.sender] = -1;
        votes--;
    }

    function updateReportAfterTrial(int _score, uint8 _state) external {
        require(state == States.Review, "Cannot perform this action");
        state = States(_state);
        votes = _score;
    }

}