// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract RiskReview{

    enum ThreatLevel {Low, Moderate, Substatial, Severe, Critical}
    enum Vote {Positive, Negative}

    struct vote{
        address owner;
        Vote status;
    }

    struct Review{
        address owner;
        Vote peerVotes;
        string version;
        int votes;
        ThreatLevel level;
    }

    mapping (string => Review[]) postedReviews;

    /// This review cannot be found
    error UnavailableReview();

    /// This package does not have reviews so far
    error UnavailablePackage();

    // modifier checkReview(string calldata packageName, int index){
    //     if(postedReviews[packageName] == 0) {
    //         revert UnavailablePackage();
    //     }
    //     if(postedReviews[packageName].length <= index) {
    //         revert UnavailableReview();
    //     }

    //     Review storage review_ = postedReviews[packageName][index];

    //     _;
    // }

    function createReview(string calldata packageName, string calldata packageVersion, uint8 threatLevel) external {
        Review memory review_;

        review_.owner = msg.sender;
        review_.version = packageVersion;
        review_.votes = 0;
        review_.level = ThreatLevel(threatLevel);

        postedReviews[packageName].push(review_);
    }

    // function getReviewsByPackage(string calldata packageName) external view returns (Review[] memory){
    //     return postedReviews[packageName];
    // }

    // function retrieveReview(string calldata packageName, int calldata index){
        
    // }

}

