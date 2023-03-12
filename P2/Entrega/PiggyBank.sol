// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.8.0;
contract PiggyBank {
    event Print(string message);

    function deposit()external payable
    {
        //Function to deposit funds in contract account
    }

    function withdraw(uint amountInWei)external
    {
        if(amountInWei <= address(this).balance)
        {
            payable(msg.sender).transfer(amountInWei);
        }
        else
        {
            emit Print("Error: Insuficcient funds");
        }
    }

    function getBalance()external view returns(uint)
    {
        return address(this).balance;
    }

}