// SPDX-License-Identifier: GPL-3.0
pragma solidity > 0.8.0;
import "arrayUtils.sol";
import "ERC721.sol";

contract MonsterTokens is ERC721simplified{
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
    mapping(address => uint[]) _balances;

    modifier onlyContractOwner() {
        require(msg.sender == _Owner, "Only the contract owner can do this action.");
        _;
    }

    modifier onlyTokenOwner(uint charTokenId) {
        require(msg.sender == _characters[charTokenId].tokenOwner, "Only the token owner can do this action.");
        _;
    }

    modifier onlyApproved(uint charTokenId) {
        require(msg.sender == _characters[charTokenId].approved, "Only the managers can do this action.");
        _;
    }

    function createMonsterToken(string calldata charName, address owner) external onlyContractOwner returns (uint)
    {
        _characters.push(new Character(charName, new uint[](0), ++_n_characters, owner, address(0)));
        _balances[owner].push(_n_characters);
        return _n_characters;
    }

    function addWeapon(uint charTokenId, string calldata weapon, uint firePower) external onlyTokenOwner(charTokenId) onlyApproved(charTokenId)
    {
        require(!arrayUtils.contains(_characters[charTokenId].weapons.names, weapon), "Cannot add an already existing weapon.");
        _characters[charTokenId].weapons.names.push(weapon);
        _characters[charTokenId].weapons.firePower.push(firePower);
    }

    function incrementFirePower(uint charTokenId, uint8 percentaje) external
    {
        arrayUtils.increment(_characters[charTokenId].weapons.firePower, percentaje);
    }

    function collectProfits() onlyContractOwner external
    {

    }

    // APPROVAL FUNCTIONS
    function approve(address _approved, uint256 _tokenId) external payable onlyTokenOwner(_tokenId)
    {
        uint256 totalFirePower = arrayUtils.sum(_characters[_tokenId].weapons.firePower);
        require(totalFirePower >= msg.value, "Value should be greater than " + totalFirePower + " Wei");
        _characters[_tokenId].approved = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    // TRANSFER FUNCTION
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable onlyTokenOwner(_tokenId) onlyApproved(_tokenId)
    {
        uint256 totalFirePower = arrayUtils.sum(_characters[_tokenId].weapons.firePower);
        require(totalFirePower >= msg.value, "Value should be greater than " + totalFirePower + " Wei");
        require(_from == _characters[_tokenId]._Owner, "Can only transfer from the owner of the token.");
        _characters[_tokenId]._Owner = _to;
        arrayUtils.removeElement(_tokenId, _balances[_from]);
        _balances[_to].push(_tokenId);
        emit Transfer(_from, _to, _tokenId);
    }

    // VIEW FUNCTIONS (GETTERS)
    function balanceOf(address _owner) external view returns (uint256)
    {
        return _balances[_owner].length();
    }

    function ownerOf(uint256 _tokenId) external view returns (address)
    {
        require(_tokenId > 1000 && _tokenId <= _n_characters, "Invalid token Id");
        return _characters[_tokenId].tokenOwner;
    }
    function getApproved(uint256 _tokenId) external view returns (address)
    {
        require(_tokenId > 1000 && _tokenId <= _n_characters, "Invalid token Id");
        return _characters[_tokenId].approved;
    }
}