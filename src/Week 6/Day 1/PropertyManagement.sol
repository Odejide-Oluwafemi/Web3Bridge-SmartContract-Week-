// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PropertyToken is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}

contract PropertyManagement {
    // Errors
    error Property__InvalidPrice();
    error Property__OnlyThePropertyOwnerCanPerformThisAction();
    error Property__PropertyListingFailed();
    error Property__404_NotFound();

    // State Variables
    uint constant public PROPERTY_LISTING_PRICE = 1000;
    PropertyToken immutable token;
    
    struct Property {
        uint id;
        string name;
        uint price;
        bool isListedForSale;
        address owner;
    }
    
    Property[] private allProperties;
    mapping(uint propertyId => Property property) private idToProperty;

    // Modifier
    modifier onlyPropertyOwner(uint _id) {
        if (idToProperty[_id].owner != msg.sender) revert Property__OnlyThePropertyOwnerCanPerformThisAction();
        _;
    }

    // Functions
    constructor(address tokenAddress) {
        token = PropertyToken(tokenAddress);
    }

    function createNewProperty(string memory _name, uint256 _price) public {
        if (_price == 0) revert Property__InvalidPrice();
        
        bool success = token.transferFrom(msg.sender, address(this), PROPERTY_LISTING_PRICE);
        if(!success) revert Property__PropertyListingFailed();

        uint256 _id = block.timestamp;

        Property memory newProperty = Property({
            id: _id,
            name: _name,
            price: _price,
            isListedForSale: false,
            owner: msg.sender
        });

        allProperties.push(newProperty);
        idToProperty[_id] = newProperty;
    }

    function removeProperty(uint _id) public onlyPropertyOwner(_id) {
        bool found;

        for(uint index; index < allProperties.length; index++) {
            if (allProperties[index].id == _id) {
                allProperties[index] = allProperties[allProperties.length - 1];
                allProperties.pop();

                idToProperty[_id] = Property(0, "", 0, false, address(0));

                found = true;
            }
        }

        if(!found) revert Property__404_NotFound();
    }

    function setPropertyForSale(uint _id, bool forSale) public onlyPropertyOwner(_id) {
        Property storage property = idToProperty[_id];
        property.isListedForSale = forSale;


    }

    //=========================
    //    Getter Functions
    //=========================
    function getPropertyById(uint _id) external view returns (Property memory) {
        return idToProperty[_id];
    }

    function getAllProperties() external view returns (Property[] memory) {
        return allProperties;
    }

    function getProperty(uint _id) external view returns(Property memory property) {
        for(uint index; index < allProperties.length; index++) {
            if (allProperties[index].id == _id) {
                property = allProperties[index];
            }
        }
    }
}