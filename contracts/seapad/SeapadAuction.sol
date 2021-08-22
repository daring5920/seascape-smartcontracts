pragma solidity ^0.6.7;

import "./../openzeppelin/contracts/access/Ownable.sol";
import "./../openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./../crowns/erc-20/contracts/CrownsToken/CrownsToken.sol";
import "./SeapadTier.sol";
import "./SeapadPrefund.sol";

/**
 *  @title Seapad Public Auction
 *  @notice Public Auction - the third phase of fundraising. It's the final stage.
 */
contract SeapadAuction is Ownable {

    SeapadTier private seapadTier;
    SeapadPrefund private seapadPrefund;
    CrownsToken private crowns;

    struct Project {
        uint256 startTime;
        uint256 endTime;
        uint256 spent;          // Total Spent Crowns for this project
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(address => bool)) public participants;

    event AddProject(uint256 indexed projectId, uint256 startTime, uint256 endTime);
    event Participate(uint256 indexed projectId, address indexed participant, uint256 amount, uint256 time);

    constructor(address _crowns, address tier, address prefund) public {
        require(_crowns != address(0) && tier != address(0) && prefund != address(0), "Seapad: ZERO_ADDRESS");
        require(tier != prefund, "Seapad: SAME_ADDRESS");
        require(tier != _crowns, "Seapad: SAME_ADDRESS");

        seapadTier = SeapadTier(tier);
        seapadPrefund = SeapadPrefund(prefund);
        crowns = CrownsToken(_crowns);
    }

    /// @notice Add the last stage period for the project
    /// @dev the Start time of this phase is the end time of Prefund phase.
    function addProject(uint256 projectId, uint256 endTime) external onlyOwner {
        require(projectId > 0, "Seapad: INVALID_PARAMETER");
        require(endTime > 0 && now < endTime, "Seapad: INVALID_TIME");
        Project storage project = projects[projectId];
        require(project.startTime == 0, "Seapad: ALREADY_ADDED");

        uint256 prefundEndTime = seapadPrefund.getEndTime(projectId);
        require(prefundEndTime > 0 && prefundEndTime < endTime, "Seapad: INVALID_SUBMISSION_TIME");
    
        project.startTime = prefundEndTime;
        project.endTime = endTime;

        emit AddProject(projectId, prefundEndTime, endTime);
    }

    /// @notice User participates in the Public Auction
    /// @param amount of Crowns that user wants to spend
    function participate(uint256 projectId, uint256 amount) external {
        require(projectId > 0 && amount > 0, "Seapad: ZERO_VALUE");
        Project storage project = projects[projectId];

        require(project.startTime > 0, "Seapad: INVALID_PROJECT_ID");
        require(now >= project.startTime, "Seapad: NOT_STARTED_YET");
        require(now <= project.endTime, "Seapad: FINISHED");
        require(participants[projectId][msg.sender] == false, "Seapad: PARTICIPATED_ALREADY");

        uint8 tierLevel = seapadTier.getTierLevel(msg.sender);
        require(tierLevel > 0, "Seapad: NOT_QUALIFIED");

        require(crowns.spendFrom(msg.sender, amount), "Seapad: CWS_UNSPEND");

        project.spent = project.spent + amount;
        participants[projectId][msg.sender] = true;

        emit Participate(projectId, msg.sender, amount, now);
    }

    function getEndTime(uint256 projectId) external view returns(uint256) {
        if (projectId == 0) {
            return 0;
        }

        return projects[projectId].endTime;
    }
}