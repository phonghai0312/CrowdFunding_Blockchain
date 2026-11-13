// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    // State variables
    address public creator;
    uint public goal;
    uint public deadline;
    uint public totalRaised;

    // Tracks individual contributions
    mapping(address => uint) public contributions;

    // Events for off-chain monitoring
    event Funded(address indexed contributor, uint amount);
    event CreatorPaid(address recipient, uint amount);
    event Refunded(address contributor, uint amount);

    // Initializes the campaign with a funding goal and duration
    constructor(uint _goalInEther, uint _durationInSeconds) {
        creator = msg.sender;
        goal = _goalInEther * 1 ether;
        //deadline = block.timestamp + (_durationInDays * 1 days);
        deadline = block.timestamp + _durationInSeconds; // Đã bỏ "* 1 days"
    }

    // Ensures the campaign is currently active
    modifier campaignActive() {
        require(block.timestamp < deadline, "Campaign has ended");
        _;
    }

    // Ensures the campaign has concluded
    modifier campaignEnded() {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        _;
    }

    // Allows users to contribute ETH to the campaign
    function contribute() public payable campaignActive {
        require(msg.value > 0, "Contribution must be greater than zero");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit Funded(msg.sender, msg.value);
    }

    // Allows the creator to withdraw funds if the goal is met
    function withdrawFunds() public campaignEnded {
        require(msg.sender == creator, "Unauthorized: Only creator can withdraw");
        require(totalRaised >= goal, "Funding goal not reached");

        uint amount = totalRaised;
        
        // CEI Pattern: Update state before external call to prevent Reentrancy attacks
        totalRaised = 0; 

        (bool success, ) = payable(creator).call{value: amount}("");
        require(success, "Withdrawal failed");

        emit CreatorPaid(creator, amount);
    }

    // Allows backers to claim a refund if the goal is not met
    function refund() public campaignEnded {
        require(totalRaised < goal, "Goal reached: Refunds are unavailable");
        
        uint amount = contributions[msg.sender];
        require(amount > 0, "No funds to refund");

        // CEI Pattern: Update state before external call to prevent Reentrancy attacks
        contributions[msg.sender] = 0; 

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");

        emit Refunded(msg.sender, amount);
    }
}