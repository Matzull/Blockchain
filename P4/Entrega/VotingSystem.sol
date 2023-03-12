// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;

contract DhondtElectionRegion {

    mapping(uint => uint) private weights;
    uint regionID;
    uint[] results;

    constructor(uint numParties, uint _regionID) {
        regionID = _regionID;
        savedRegionInfo();
        results = new uint[](numParties);
    }

    function savedRegionInfo() private {
        weights[28] = 1; // Madrid
        weights[8] = 1; // Barcelona
        weights[41] = 1; // Sevilla
        weights[44] = 5; // Teruel
        weights[42] = 5; // Soria
        weights[49] = 4; // Zamora
        weights[9] = 4; // Burgos
        weights[29] = 2; // Malaga
    }

    function registerVote(uint partyID) internal returns (bool) {
        require(partyID < results.length, "Invalid partyID.");
        results[partyID] += weights[regionID];
        return true;
    }
}

abstract contract PollingStation {

    bool public votingFinished;
    bool private votingOpen;
    address president;

    modifier onlyPresident() {
        require(msg.sender == president, "Only the president can do this action.");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen == true, "Voting must be opened.");
        _;
    }

    modifier votingIsFinished() {
        require(votingFinished, "Voting must be finished.");
        _;
    }

    constructor(address _president) {
        president = _president;
        votingFinished = false;
        votingOpen = false;
    }

    function openVoting() external onlyPresident() {
        votingOpen = true;
    }

    function closeVoting() external onlyPresident() {
        votingFinished = true;        
    }

    function castVote(uint partyID) virtual external returns (bool);

    function getResults() virtual external view returns (uint[] memory);

}

contract DhondtPollingStation is PollingStation, DhondtElectionRegion {

    constructor(address regionalPresident, uint numParties, uint regionID) PollingStation(regionalPresident) DhondtElectionRegion(numParties, regionID) {}

    function castVote(uint partyID) override external votingIsOpen() returns (bool) {
        registerVote(partyID);
        return true;
    }

    function getResults() override external view votingIsFinished() returns (uint[] memory) {
        return results;
    }
}

contract Election {

    address authority;
    mapping(address => bool) voters;
    mapping(uint => DhondtPollingStation) pollingStations;
    uint numParties;
    mapping(uint => uint) indexToRegionIDs;
    uint numOfRegions;

    modifier onlyAuthority() {
        require(msg.sender == authority, "Only authority can use this operation.");
        _;
    }

    modifier freshID(uint regionID) {
        require(address(pollingStations[regionID]) == address(0), "RegionID already in use.");
        _;
    }

    modifier validID(uint regionID) {
        require(address(pollingStations[regionID]) != address(0), "No Polling Station with that regionID exists.");
        _;
    }

    modifier hasntVoted(address voter) {
        require(voters[voter] == false, "Voter has already voted.");
        _;
    }

    constructor(uint _numParties) {
        authority = msg.sender;
        numParties = _numParties;
        numOfRegions = 0;
    }

    function createPollingStation(uint regionID, address regionalPresident) external onlyAuthority() freshID(regionID) returns (address) {
        DhondtPollingStation pollingStation = new DhondtPollingStation(regionalPresident, numParties, regionID);
        pollingStations[regionID] = pollingStation;
        indexToRegionIDs[numOfRegions] = regionID;
        numOfRegions += 1;
        return address(pollingStation);
    }

    function castVote(uint regionID, uint partyID) external validID(regionID) hasntVoted(msg.sender) {
        DhondtPollingStation station = pollingStations[regionID];
        bool success = station.castVote(partyID);
        if (!success) {
            revert("Failed to vote.");
        }
    }

    function getResults() external view onlyAuthority() returns (uint[] memory) {
        uint[] memory results = new uint[](numParties);
        for (uint i = 0; i <= numOfRegions; i++) {
            uint regionID = indexToRegionIDs[i];
            DhondtPollingStation stationToCount = pollingStations[regionID];
            try stationToCount.getResults() returns (uint[] memory res) {
                for (uint party = 0; party < results.length; party++) {
                    results[party] += res[party];
                }
            }
            catch {
                revert("Not all votings are finished.");
            }
        }
        return results;
    }
}