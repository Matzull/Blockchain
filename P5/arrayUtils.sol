pragma solidity ^0.4.23;


/**
contains: this function has two parameters, an array of type string[] and a variable
val of type string and returns a Boolean value that indicates whether val is in the
array or not.
 */
library arrayUtils {

	function contains(string[] array, string val) internal pure returns (bool) 
	{
		for (uint256 i = 0; i < array.length; i++) {
			if(array[i] == val)
			{
				return true;
			}
		}
		return false;
	}

	// Computes how many tokens are associated with a single account 
	function addressBalance(address[] array, address owner) internal pure returns (uint)
	{
		uint ret = 0;
		for (uint256 index = 0; index < array.length; index++) {
			if(array[i] == owner)
			{
				ret++;
			}
		}
		return ret;
	}

	//increment: this function has two parameters, an array of type uint[] and a percentage
	// of type uint8. It must modify the contents of the array, incrementing each array element
	// by the percentage passed as second parameter.
	function increment(uint[] array, uint8 percentaje) internal pure
	{
		for (uint256 i = 0; i < array.length; i++) {
			array[i] *= (percentaje/100);
		}
	}

	//sum: This function has one parameter of type uint[] and returns the sum of its elements.
	function sum(uint[] array) internal pure returns (uint256)
	{
		uint256 ret;
		for (uint256 i = 0; i < array.length; i++) {
			ret += array[i];
		}
		return ret;
	}

}