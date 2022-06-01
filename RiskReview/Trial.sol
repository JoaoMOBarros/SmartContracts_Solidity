// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './Report.sol';
import './User.sol';

contract Trial{

    struct TrialVote{
        User user;
        int weight;
        string comment;
    }

    Report public report;
    address[] public judges;
    bool public isTrialOpen;
    TrialVote[] public votes;

    constructor(Report _report){
        report = _report;
        isTrialOpen = true;
    }

    /// You should have at least 15 points of reputation before judging a report
    error MinReputation();

    /// You can only judge a report when your account is at least 3 days old.
    error MinTimeCreation();

    modifier onlyQualifiedPeer(User _user){
        if(_user.reputation() < int(15)){
            revert MinReputation();
        }
        if(block.timestamp - _user.createdAt() < 259200){
            revert MinTimeCreation();
        }
        _;
    }

    // You can vote only once
    error OnlyOnce();

    modifier onlyOnce(){
        for(uint i = 0; i< judges.length -1; i++){
            if(judges[i] == msg.sender){
                revert OnlyOnce();
            }
        }
        _;
    }

    //1 - Upvote ; -1 - Downvote

    function castVote(User _user, int _vote, string memory comment) public onlyOnce(){
        require(isTrialOpen == true, "This trial no longer can receive votes");
        TrialVote memory _trialVote = TrialVote(_user, _vote*_user.reputation(), comment);
        judges.push(msg.sender);
        votes.push(_trialVote);
    }

}
