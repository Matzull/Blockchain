// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;
contract PiggyMapping {
    event Print(string message);

    struct Client {
        uint balance;
        string name;
    }

    mapping(address => Client) _clients;

    address[] _addresses;

    function deposit()external payable
    {
        require(
                bytes(_clients[msg.sender].name).length != 0, 
                "Client doesnt exist."
                );
       _clients[msg.sender].balance += msg.value;
    }

    function addClient(string memory name)external payable
    {
        require(
                bytes(name).length != 0, 
                "Name cannot be an empty string."
                );

        require(
                bytes(_clients[msg.sender].name).length == 0, 
                "Already existing user."
                );

        _clients[msg.sender] = Client(msg.value, name);
        _addresses.push(msg.sender);
    }

    function withdraw(uint amountInWei)external
    {
        require(
                bytes(_clients[msg.sender].name).length != 0, 
                "Client doesnt exist."
                );
        require(
                _clients[msg.sender].balance >= amountInWei, 
                "Client doesnt have enoough funds."
                );
        payable(msg.sender).transfer(amountInWei);
        _clients[msg.sender].balance -= amountInWei;
    }

    function getBalance()external view returns(uint)
    {
        return  _clients[msg.sender].balance;
    }

    function checkBalances()external view returns (bool)
    {
        uint sum = 0;
        for(uint i = 0; i < _addresses.length; i++)
        {
            sum += _clients[_addresses[i]].balance;
        }
        return (sum == address(this).balance);
    }

}