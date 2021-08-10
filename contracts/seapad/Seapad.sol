pragma solidity ^0.6.7;

contract Seapad {

    struct Project {
        uint256 pool;
        uint256 milestones;
        uint8 milestones;
        uint256 duration;
        uint256 entranceTime;
        uint256 time;

        uint256 crownsPool;
        uint256 investAmount;
        uint256 entranceDuration.
        uint256 projectDuration.
        uint256 publicSaleDuration;
        uint256 entranceStartTime;
        uint256 tier_1_investAmount;
        uint256 tier_2_investAmount;
        uint256 tier_3_investAmount;
        uint256 tier_1_investorAmount;
        uint256 tier_2_investorAmount;
        uint256 tier_3_investorAmount;

        uint8 milestones;

        uint16 entranceLimit;
        uint16 entrances;
        uint256 collected;
    }

    enum Tier{ ONE, TWO, THREE }

    /// @todo need to ask, is there entrance limit per tier or per project.
    /// If its per tier, then that means, each tier will have its own pool for investing.
    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(address => Tier)) public entrances;
    mapping(uint256 => mapping(uint16 => address)) public entranceIndices;

    ///////////////////////////////////////////////////////////////
    //
    // The only owner callable function
    //
    ///////////////////////////////////////////////////////////////

    /// @notice add a new project to the IDO project.
    /// @param params represent project's uint256 parameters as there are too many of them. We reduce the gas fee
    /// and avoid the "stack too deep" issue.
    /// params[0] - amount of crowns
    /// params[1] - amount of accepting tokens
    /// params[2] - entrance duration.
    /// params[3] - project duration.
    /// params[4] - public sale duration.
    /// params[5] - entrance time in unix timestamp
    /// params[6] - tier 1 limit
    /// params[7] - tier 2 limit
    /// params[8] - tier 3 limit
    /// params[9] - tier 1 investor amount
    /// params[10] - tier 2 investor amount
    /// params[11] - tier 3 investor amount
    function addProject(uint256[12] memory params, uint8 milestones, uint16 entranceLimit) external {
        require(params[5] > now, "should start in the future");
        for (uint8 i = 0; i < 12; i++) {
            require(params[i] > 0, "some param is 0");
        }

        require(milestones > 0, "0 milestones were given");
        require(entraentranceLimitnceAmount > 0, "0 entrances were given");
    }

    function addPcc(uint256 projectId, address token) external {

    }

    //////////////////////////////////////////////////////////////////////
    //
    // The investor functions
    //
    //////////////////////////////////////////////////////////////////////
    function entrance(uint256 projectId, uint256 amount, uint8 v, bytes32[2] memory sig) external {
        Project storage project = projects[projectId];
        require(project.entrances < project.entranceLimit, "All entries are full");
    }

    function publicSale(uint256 projectId, uint256 amount, uint8 v, bytes32[2] memory sig) external {
        Project storage project = projects[projectId];
        require(project.entrances < project.entranceLimit, "All entries are full");
    }

    function claimIndexNft(uint256 projectId, uint8 v, bytes[2] memory sig) external {

    }

    function burnForPcc(uint256 projectId, uint256 nftId) exteral {

    }

    function burnForCws(uint256 projectId, uint256 nftId) exteral {

    }

    function stake(uint256 projectId, uint256 nftId) exteral {

    }

    // need to ask: could it be any project. or user has to choose a certain project for burning this nft.
    function burnForProject(uint256 projectId, uint256 nftId, uint256 anotherProjectId) external {

    }

    //////////////////////////////////////////////////////////////////////
    //
    // After funded functions
    //
    //////////////////////////////////////////////////////////////////////

    // do we unlock after achieving milestone or token can be unlocked any time?
    // what happens if milestones are not achieved?
    function unlockInvestment() external {

    }
}