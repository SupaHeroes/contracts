// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/access/Ownable.sol";

//contract template for initiating a project
contract CampaignBalance is Ownable {
    mapping(address => uint256) public userDeposit;
    //variable for projectname

    
    string projectName;
    //variable for projectstarter (EOA projectstarter)
    address projectStarter;
    //starttime of fundingperiod (is this necessary?)
    uint256 fundingStartTime;
    //endtime of fundingperiod
    uint256 fundingEndTime;
    //Targetamount for funding
    uint256 fundTarget;
    //current balance of the project
    uint256 currentBalance;
    //starttime of projectperiod (starting after fundingperiod)
    uint256 projectStartTime;
    //endtime of the project
    uint256 projectEndTime;
    //is the project initialized succesful?
    bool isInitialized;
    //amount of refund
    uint256 returnAmount;
    //amount that is funded
    uint256 fundAmount;



    //put owner in constructor to use for initializing project
    constructor() public Ownable() {
        isInitialized == false;
    }

    //q: correct use of constructor?
    //q: double use of setting owner?

    //function to initialize project, only for Supahero.
    function Initialize(
        string calldata _projectName,
        address _projectStarter,
        uint256 _fundingEndTime,
        uint256 _fundTarget,
        uint256 _projectEndTime
    ) public onlyOwner returns (bool) {
        require(isInitialized == false, "already initialized");
        require(_fundingEndTime > block.timestamp, "block height must be greater than current block");

        projectName = _projectName;
        projectStarter = _projectStarter;
        fundingEndTime = _fundingEndTime;
        fundTarget = _fundTarget;
        projectEndTime = _projectEndTime;
        isInitialized = true;
        return true;
    }

    //more require necessary?

    function deposit(uint256 amount) public {
        require(fundingEndTime > block.timestamp, "Funding ended");
        require(currentBalance + amount < fundTarget, "amount higher than fund target");

        userDeposit[msg.sender] = userDeposit[msg.sender] += amount;
        currentBalance = currentBalance += amount;
    }

    //q: how to make storage of amounts that have been deposited before, to see if amount is greater than fundTarget - previous deposits
    //q: re-entrancy guard necessary?

    //emergency function to stop the funding (and stop the project)
    function stopProject() public onlyOwner {
        fundingEndTime = block.timestamp;
        projectEndTime = block.timestamp;
    }

    //q: proper use of block.timestamp?

    function detailsProject() public view returns (string memory Name, string memory Starter, uint256 Target, uint256 Balance){
        Name = projectName;
        Target = fundTarget;
        Balance = currentBalance;
    }
    
    //How to see these variables when calling function?

    //function for returning the funds
    function returnFunds() public {
        require(userDeposit[msg.sender] > 0);

        uint256 returnAmount = currentBalance[msg.sender];
        currentBalance[msg.sender] = 0;

        (bool sent, bytes memory data) = msg.sender.transfer{value: returnAmount}("");
        require(sent, "Failed to withdraw");
    }

    function payOut() public {
        require(msg.sender == projectStarter);
        require(fundingEndTime < block.timestamp);
        
        uint256 fundAmount = currentBalance;
        currentBalance = 0;
        (bool sent, bytes memory data) = msg.sender.transfer{value: fundAmount}("");
        require(sent, "Failed to withdraw");


    }


}