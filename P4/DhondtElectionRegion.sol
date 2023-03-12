// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;
contract DhondElectionRegion {
    event Print(string message);

    mapping(uint => uint)private _weights;

    uint _regionId;
    uint[] _results;
    uint _numberOfParties;

    function savedRegionInfo() private{
    _weights[28] = 1; // Madrid
    _weights[8] = 1; // Barcelona
    _weights[41] = 1; // Sevilla
    _weights[44] = 5; // Teruel
    _weights[42] = 5; // Soria
    _weights[49] = 4; // Zamora
    _weights[9] = 4; // Burgos
    _weights[29] = 2; // Malaga
    }

    constructor(uint numberOfParties, uint regionId)
    {
        _regionId = regionId;
        _numberOfParties = numberOfParties;
        savedRegionInfo();
    }

    function registerVote(uint partyId) internal returns (bool) {
        if(partyId < _numberOfParties && partyId >= 0)
        {
            return false;
        }
        _results[partyId]+=_weights[_regionId];
        return true;
    }
}