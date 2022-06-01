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
    mapping(address=>TrialVote) public votes;

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
        for(uint i = 0; i < judges.length; i++){
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
        votes[msg.sender]= _trialVote;
    }

    function calculateTotalScore() internal view returns (int score){
        for(uint i = 0; i < judges.length; i++){
            score += votes[judges[i]].weight;
        }
    }

    function publishReport(int _score) internal {
        if(_score >= 0){
            report.updateReportAfterTrial(_score, 1);
        }
        else{
            report.updateReportAfterTrial(_score, 2);
        }
    }

    function distributeReputation() external {
        require(isTrialOpen == true, "Reputation already distributed");
        //First close the trial too avoid rentry attaks;
        isTrialOpen = false;
        int score = 0;
        int currentScore = calculateTotalScore();

        //Update report onwer score
        if(currentScore > int(-1)){
            //ReportAccepted (add 7p)
            report.owner().addActivity(3);
        }
        else{
            //ReportRejected (add -2p)
            report.owner().addActivity(4);
        }

        for(uint i=0; i < judges.length; i++){
            if(votes[judges[i]].weight * currentScore >= 0){
                //PeerReviewApproved (add 4p)
                votes[judges[i]].user.addActivity(1);
                score++;
            }
            else{
                //PeerReviewRejected (add -1p)
                votes[judges[i]].user.addActivity(2);
                score--;
            }
        }

        publishReport(score);

    }

}
