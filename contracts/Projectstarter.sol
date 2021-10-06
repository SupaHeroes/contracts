// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "OpenZeppelin/openzeppelin-contracts@4.3.0/contracts/access/Ownable.sol";
import "./Project.sol";

contract Projectstarter is Ownable {
    Project[] public projects;
    function createProject(
        string memory _projectName, 
        address payable _projectStarter, 
        uint256 _fundingEndTime, 
        uint256 _fundTarget, 
        uint256 _projectEndTime)
        public onlyOwner {
        Project project = new Project(
            _projectName, 
            _projectStarter,
            _fundingEndTime,
            _fundTarget,
            _projectEndTime            
        );
        projects.push(project);
    }
}