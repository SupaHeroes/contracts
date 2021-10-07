// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/access/Ownable.sol";

//contract template for initiating a project
contract Project is Ownable {
    mapping(address => uint256) public userDeposit;
    //variable for projectname

    
    string projectName;
    //variable for projectstarter (EOA projectstarter)
    address payable projectStarter;
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
    //amount of supporter
    uint256 amountUser;

    //put owner in constructor to use for initializing project
    constructor(
        string memory _projectName, 
        address payable _projectStarter, 
        uint256 _fundingEndTime, 
        uint256 _fundTarget, 
        uint256 _projectEndTime
        ) {

        projectName = _projectName;
        projectStarter = _projectStarter;
        fundingEndTime = _fundingEndTime;
        fundTarget = _fundTarget;
        projectEndTime = _projectEndTime;
        isInitialized = true;
        
    }

    //q: correct use of constructor?
    //q: double use of setting owner?


    function deposit(uint256 amount) public payable{
        require(fundingEndTime > block.timestamp, "Funding ended");
        require(currentBalance + amount < fundTarget, "amount higher than fund target");

        userDeposit[msg.sender] += amount;
        currentBalance += amount;
    }

    //q: how to make storage of amounts that have been deposited before, to see if amount is greater than fundTarget - previous deposits
    //q: re-entrancy guard necessary?

    //emergency function to stop the funding (and stop the project)
    function stopProject() public onlyOwner {
        fundingEndTime = block.timestamp;
        projectEndTime = block.timestamp;
    }

    //q: proper use of block.timestamp?

    function detailsProject() public view returns (string memory Name,  address Starter, uint256 Target, uint256 Balance){
        Name = projectName;
        Starter = projectStarter;
        Target = fundTarget;
        Balance = currentBalance;
        return (Name, Starter, Target, Balance);
    } 

    //How to see these variables when calling function?

    //function for returning the funds
    function withdrawFunds() public returns(bool success) {   
        require(userDeposit[msg.sender] >= 0);// guards up front
        amountUser = userDeposit[msg.sender];
        userDeposit[msg.sender] -= userDeposit[msg.sender];         // optimistic accounting
        payable(msg.sender).transfer(amountUser);            // transfer
        return true;
        }
 

    function payOut(uint amount) public returns(bool success) {
        require(msg.sender == projectStarter);
        require(fundingEndTime < block.timestamp);
        
        uint fundAmount = currentBalance;
        currentBalance = 0;
        projectStarter.transfer(amount);
        return true;
    }


}