// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./ITreasureBay.sol";

interface ITreasureBayFactory {
  // Require to  create a HD Wallet first before create a DAO
  event NewBayCreated(
    string indexed name,
    address indexed creator,
    address indexed bayAddress
  );

  function createNewBay(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint64 limitNumberOfTreasureHunters_
  ) external returns (bool);

  function getAllBays() external returns (ITreasureBay[] memory);

  function getBay(address bayAddress) external view returns (ITreasureBay);
}
