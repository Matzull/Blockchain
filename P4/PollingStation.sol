// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.0;
abstract contract PollingStation{

    bool public votingFinished;
    bool private _votingOpen;

    address _presidentAddress;

    modifier onlyOwner() {
        require(msg.sender == _presidentAddress); _;
    }

    modifier isOpen() {
        require(_votingOpen == true); _;
    }

    modifier isClosed() {
        require(_votingOpen == false); _;
    }

    constructor(address presidentAddress)
    {
        _presidentAddress = presidentAddress;
        votingFinished = false;
        _votingOpen = false;
    }

    function openVoting() external onlyOwner isClosed 
    {
        _votingOpen = true;
    }

    function closeVoting() external onlyOwner isOpen{
        _votingOpen = false;
        votingFinished = true;
    }

    function castVote(uint partyId) external virtual returns (bool);

    function getResults() external virtual returns(uint[] memory);

}