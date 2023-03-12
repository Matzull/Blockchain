// SPDX-License-Identifier: GPL-3.0
import "./DhondtPollingStation.sol";
pragma solidity >= 0.8.0;
contract Election{

    address _authorityAddress;
    uint _numberOfParties;

    struct Region {
        DhondtPollingStation station;
        uint votes;
        bool isSet;
    }

    mapping(uint => Region) _regions;

    mapping(address => bool) _voters;

    uint[] _activeRegions;

    modifier onlyAuthority() {
        require(msg.sender == _authorityAddress); _;
    }

    modifier freshId(uint regionId) {
        require(_regions[regionId].isSet); _;
    }

    modifier validId(uint regionId) {
        require(_regions[regionId].isSet); _;
    }

    modifier hasntVoted(address voter)
    {
        require(!_voters[voter]); _;
    }

    constructor(uint numberOfParties)
    {
        _numberOfParties = numberOfParties;
        _authorityAddress = msg.sender;
    }

    function createPollingStation(uint regionId, address presidentAddress) external freshId(regionId) onlyAuthority returns(address)
    {
        _regions[regionId].station = new DhondtPollingStation(presidentAddress, _numberOfParties, regionId);
        _activeRegions.push(regionId);
        mapping(uint => uint) indexToRegionIDs;
        return address(_regions[regionId].station);
    }

    function castVote(uint regionId, uint partyId) external validId(regionId) hasntVoted(msg.sender)
    {
        if (!(_regions[regionId].station).castVote(partyId)) {
            revert("Failed to vote.");
        }
    }

    function getResults() external onlyAuthority() {
        for (uint256 i = 0; i < _activeRegions.length; i++) {
            _regions[_activeRegions]
        }
    }
}