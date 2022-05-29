// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract RiskReview{
    string public name;
    string public version;
    int public votes = 0;
    uint256 public level;

    constructor(string memory packageName, string memory packageVersion, uint256 riskLevel){
        name = packageName;
        version = packageVersion;
        level = riskLevel;
    }

    function upvote() public {
        votes +=1;
    }

    function downvote() public {
        votes -=1;
    }

    function getVotes() public view returns (int){
        return votes;
    }
}

