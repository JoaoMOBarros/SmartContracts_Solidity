// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Report{

    enum ThreatLevel {Low, Moderate, Substatial, Severe, Critical}

    address owner;
    mapping (address => int) peerReview;
    string package;
    string version;
    int votes;
    ThreatLevel level;

    constructor(string memory packageName, string memory packageVersion, uint8 threatLevel){
        owner = msg.sender;
        package = packageName;
        version = packageVersion;
        votes = 0;
        level = ThreatLevel(threatLevel);
    }

    modifier removePreviousReview(){
        if(peerReview[msg.sender] != 0){
            votes -= peerReview[msg.sender];
            peerReview[msg.sender] = 0;
        }
        _;
    }

    /// The owner cannot vote in its own report
    error OnlyPeer();

    /// Only the owner of report can call this function
    error OnlyOwner();

    modifier onlyPeer(){
        if(msg.sender == owner){
            revert OnlyPeer();
        }
        _;
    }

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert OnlyOwner();
        }
        _;
    }

    function upvote() external removePreviousReview() onlyPeer(){
        peerReview[msg.sender] = 1;
        votes++;
    }

    function downvote() external removePreviousReview() onlyPeer(){
        peerReview[msg.sender] = -1;
        votes--;
    }

    function getVotesFromReport() public view returns (int){
        return votes;
    }
}