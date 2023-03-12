// SPDX-License-Identifier: GPL-3.0
pragma solidity > 0.8.0;
import "ArrayUtils.sol";
import "ERC721simplified.sol";

contract MonsterTokens is ERC721{
    struct Weapons {
        string[] names; // name of the weapon
        uint[] firePowers; // capacity of the weapon
    }
    struct Character {
        string name; // character name
        Weapons weapons; // weapons assigned to this character
        uint tokenId; // Character id
        address tokenOwner;
        address approved;
    }
    
    uint _n_characters; // number of characters
    address _Owner;
    Character[] _characters;

    modifier onlyContractOwner() {
        require(msg.sender == _Owner, "Only the contract owner can do this action.");
        _;
    }

    modifier onlyTokenOwner(uint charTokenId) {
        require(msg.sender == _characters[charTokenId].tokenOwner, "Only the token owner can do this action.");
        _;
    }

    modifier onlyApproved() {
        require(msg.sender == _characters[charTokenId].approved, "Only the managers can do this action.");
        _;
    }

    function createMonsterToken(string charName, address owner) external onlyContractOwner returns (uint)
    {
        _characters.push(new Character(charName, new uint[](0), ++_n_characters, owner));
        return _n_characters;
    }

    function addWeapon(uint charTokenId, string weapon, uint firePower) external onlyTokenOwner(charTokenId) onlyApproved(charTokenId)
    {
        require(!arrayUtils.contains(_characters[charTokenId].weapons.names, weapon), "Cannot add an already existing weapon.");
        _characters[charTokenId].weapons.push(new Weapon(weapon, firePower));
    }

    function incrementFirePower(uint charTokenId, uint8 percentaje) external
    {
        arrayUtils.increment(_characters[charTokenId].weapons.firePower, percentaje);
    }

    function collectProfits() onlyContractOwner external
    {

    }

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    // APPROVAL FUNCTIONS
    function approve(address _approved, uint256 _tokenId) external payable onlyOwner(_tokenId)
    {
        uint256 totalFirePower = arrayUtils.sum(_characters[_tokenId].weapons.firePower);
        require(totalFirePower >= msg.value, "Value should be greater than " + totalFirePower + " Wei");
        _characters[_tokenId].approved = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    // TRANSFER FUNCTION
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable onlyOwner(_tokenId) onlyApproved(_tokenId)
    {
        uint256 totalFirePower = arrayUtils.sum(_characters[_tokenId].weapons.firePower);
        require(totalFirePower >= msg.value, "Value should be greater than " + totalFirePower + " Wei");
        require(_from == _characters[_tokenId]._Owner, "Can only transfer from the owner of the token.");
        _characters[_tokenId]._Owner = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    // VIEW FUNCTIONS (GETTERS)
    function balanceOf(address _owner) external view returns (uint256)
    {
        arrayUtils.addressBalance(_characters[owner], owner);
    }

    function ownerOf(uint256 _tokenId) external view returns (address);
    function getApproved(uint256 _tokenId) external view returns (address);
}