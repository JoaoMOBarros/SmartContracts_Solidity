// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './Report.sol';

contract User{

    enum Activity{Vote, PeerReviewAccepted, PeerReviewRejected, ReportAccepeted, ReportRejected}

    struct ActivityReceipt{
        Activity activity;
        uint timestamp;
    }

    address public owner;
    uint public createdAt;
    Report[] reports;
    ActivityReceipt[] activities;
    int public reputation;

    constructor(){
        owner = msg.sender;
        createdAt = block.timestamp;
        reputation = 0;
    }

    function getActivityReputation(Activity activity_) private pure returns (int score){
        if(activity_ == Activity.Vote) return 1;
        if(activity_ == Activity.PeerReviewAccepted) return 4 ;
        if(activity_ == Activity.PeerReviewRejected) return -1 ;
        if(activity_ == Activity.ReportAccepeted) return 7 ;
        if(activity_ == Activity.ReportRejected) return -2 ;
    }

    function addActivity(uint8 activity_) external {
        ActivityReceipt memory receipt = ActivityReceipt(Activity(activity_), block.timestamp);
        activities.push(receipt);
        reputation += getActivityReputation(Activity(activity_));
    }

    function getAllUserReposts() public view returns(Report[] memory){
        return reports;
    }

    function getAllUserActivities() public view returns(ActivityReceipt[] memory){
        return activities;
    }

}