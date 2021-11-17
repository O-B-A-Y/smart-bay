// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ITreasureBayFactory.sol";
import "./TreasureBay.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasureBayFactory is ITreasureBayFactory, Ownable {
  ITreasureBay[] private _listOfBays;
  mapping(address => ITreasureBay) _mapOfBays;

  function createNewBay(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint64 limitNumberOfTreasureHunters_
  ) external override returns (bool) {
    TreasureBay bay = new TreasureBay(
      name_,
      limitNumberOfMembers_,
      limitNumberOfTreasureHunters_
    );
    _listOfBays.push(bay);
    _mapOfBays[address(bay)] = bay;

    emit NewBayCreated(name_, _msgSender(), address(bay));
    return true;
  }

  function deleteBay(address bayAddress) external onlyOwner {
    for (uint256 index = 0; index < _listOfBays.length; index++) {
      if (address(_listOfBays[index]) == bayAddress) {
        _listOfBays[index] = _listOfBays[index + 1];
        _listOfBays.pop();
      }
    }
    delete _mapOfBays[bayAddress];
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
