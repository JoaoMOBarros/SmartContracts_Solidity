// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import './Report.sol';

contract RiskReview{

    mapping (string => Report[]) postedReviews;

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

    modifier checkPackage(string calldata packageName){
        if(postedReviews[packageName].length == 0) {
            revert UnavailablePackage();
        }
        _;
    }

    function getArraySum(int[] memory _array) 
        public 
        pure 
        returns (int sum_) 
    {
        sum_ = 0;
        for (uint i = 0; i < _array.length; i++) {
            sum_ += _array[i];
        }
    }

    function createReview(string calldata packageName, string calldata packageVersion, uint8 threatLevel) external {
        Report newReport = new Report(packageName, packageVersion, threatLevel);

        postedReviews[packageName].push(newReport);
    }

    function getReviewsByPackage(string calldata packageName) external view returns (Report[] memory){
        return postedReviews[packageName];
    }

    function getPackageScore(string calldata packageName) public view checkPackage(packageName) returns (uint){
        Report[] memory reports = postedReviews[packageName];
        int[] memory votes;
        for(uint i = 0; i<reports.length; i++){
            votes[i] = reports[i].getVotesFromReport();
        } 
        uint sumVotes = uint(getArraySum(votes));
        return sumVotes/reports.length;
    }

}
