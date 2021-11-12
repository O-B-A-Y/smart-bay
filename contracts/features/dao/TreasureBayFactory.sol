// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ITreasureBayFactory.sol";
import "./TreasureBay.sol";

contract TreasureBayFactory is ITreasureBayFactory {
  ITreasureBay[] private _listOfBays;
  mapping(address => ITreasureBay) _mapOfBays;

  function createNewBay(string memory name_, uint64 limitNumberOfMembers_)
    external
    override
    returns (bool)
  {
    TreasureBay bay = new TreasureBay(name_, limitNumberOfMembers_);
    _listOfBays.push(bay);
    _mapOfBays[address(bay)] = bay;

    emit NewBayCreated(name_, msg.sender, address(bay));
    return true;
  }

  function getAllBays() external view override returns (ITreasureBay[] memory) {
    return _listOfBays;
  }

  function getBay(address bayAddress)
    external
    view
    override
    returns (ITreasureBay)
  {
    return _mapOfBays[address(bayAddress)];
  }
}
