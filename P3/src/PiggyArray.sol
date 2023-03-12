// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;
contract PiggyArray {
    event Print(string message);

    struct Client {
        uint balance;
        string name;
        address c_address;
    }

    Client[] _clients;

    function findUser(address user_address) internal view returns (uint, bool)
    {
        for(uint i = 0; i < _clients.length; i++)
        {
            if(user_address == _clients[i].c_address)
            {
                return (i, true);
            }
        }
        return (0, false);
    }    

    function deposit()external payable
    {
        (uint idx, bool found) = findUser(msg.sender);

        require(found,"Client doesnt exist.");
       _clients[idx].balance += msg.value;
    }

    function addClient(string memory name)external payable
    {
        (uint idx, bool found) = findUser(msg.sender);
        require(
                bytes(name).length != 0, 
                "Name cannot be an empty string."
                );

        require(!found,"Already existing user.");

        Client memory client = Client(msg.value, name, msg.sender);
        _clients.push(client);
    }

    function withdraw(uint amountInWei)external
    {
        (uint idx, bool found) = findUser(msg.sender);
        require(
                found, 
                "Client doesnt exist."
                );
        require(
                _clients[idx].balance >= amountInWei, 
                "Client doesnt have enoough funds."
                );
        payable(msg.sender).transfer(amountInWei);
        _clients[idx].balance -= amountInWei;
    }

    function getBalance()external view returns(uint)
    {
        (uint idx, bool found) = findUser(msg.sender);
        require(
                found, 
                "Client doesnt exist."
                );
        return  _clients[idx].balance;
    }

}