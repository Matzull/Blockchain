// SPDX-License-Identifier: GPL-3.0
pragma solidity > 0.8.0;

/**
contains: this function has two parameters, an array of type string[] and a variable
val of type string and returns a Boolean value that indicates whether val is in the
array or not.
 */
library arrayUtils {

	function contains(string[] storage array, string memory val) internal view returns (bool) 
	{
		for (uint256 i = 0; i < array.length; i++) {
			if(keccak256(bytes(array[i])) == keccak256(bytes(val)))
			{
				return true;
			}
		}
		return false;
	}

	// Removes an element index of the list array
	function removeElement(uint index, uint[] storage array) internal {
		require(index < array.length, "Index out of range");
		for (uint i = index; i < array.length-1; i++){
			array[i] = array[i+1];
		}
		array.pop();
	}

	//increment: this function has two parameters, an array of type uint[] and a percentage
	// of type uint8. It must modify the contents of the array, incrementing each array element
	// by the percentage passed as second parameter.
	function increment(uint[] storage array, uint8 percentaje) internal
	{
		for (uint256 i = 0; i < array.length; i++) {
			array[i] *= (percentaje/100);
		}
	}

	//sum: This function has one parameter of type uint[] and returns the sum of its elements.
	function sum(uint[] storage array) internal view returns (uint256)
	{
		uint256 ret;
		for (uint256 i = 0; i < array.length; i++) {
			ret += array[i];
		}
		return ret;
	}

}