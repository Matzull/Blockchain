// SPDX-License-Identifier: GPL-3.0
import "./PollingStation.sol";
import "./DhondtElectionRegion.sol";
pragma solidity >= 0.8.0;
contract DhondtPollingStation is DhondElectionRegion, PollingStation{

    constructor (address presidentAddress, uint numberOfParties, uint regionId) PollingStation(presidentAddress) DhondElectionRegion(numberOfParties, regionId)
    {
    }

    function castVote(uint partyId) external override returns (bool)
    {
        require(
            super.registerVote(partyId),
            "Couldn`t cast vote."
        );
        return registerVote(partyId);
    }

    function getResults() external view override returns(uint[] memory)
    {
        require(
            votingFinished,
            "Voting process has not finished yet."
        );
        return _results;
    }
}