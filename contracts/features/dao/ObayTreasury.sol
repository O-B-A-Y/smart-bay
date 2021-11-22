// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TreasurePool.sol";
import "./proposal/TreasureWoodyChest.sol";
import "../token/ObayToken.sol";

contract ObayTreasury is TreasurePool, TreasureWoodyChest {
  IERC20 public token;
  uint64 private _lockedDuration = 7 days;
  uint64 private _defaultClaimedInterval = 3 days;

  constructor() {
    limitNumberOfStakeholders = 10000;
    token = new ObayToken();
  }

  function createNewProposal(
    string memory _title,
    string memory _description,
    uint64 _debatingPeriod
  ) public onlyOwner returns (uint256) {
    return _newProposal(_title, _description, _debatingPeriod);
  }

  function stakeNative() public payable {
    require(msg.value > 0, "invalid staked amount");
    require(msg.value > minimumStakedAmount, "invalid staked amount");

    // Check if the stakeholder is added or not
    if (stakeholders[_msgSender()].balance == 0) {
      createStakeholder();
    }
    token.transferFrom(msg.sender, address(this), msg.value);
    stakeholders[_msgSender()].balance += msg.value;
    totalStakedAmount += msg.value;
    emit Stake(_msgSender(), msg.value);
  }

  function unstakeNative() public payable isStakeholder {
    require(
      block.timestamp > stakeholders[_msgSender()].joinedAt + _lockedDuration,
      "Must staked for 7 days before unstaking"
    );
    require(
      msg.value <= stakeholders[_msgSender()].balance,
      "Insufficient staked amount"
    );
    token.transferFrom(address(this), msg.sender, msg.value);
    stakeholders[_msgSender()].balance += msg.value;
    if (stakeholders[_msgSender()].balance == 0) {
      removeStakeholder(_msgSender());
    }
    totalStakedAmount -= msg.value;
    emit Unstake(_msgSender(), msg.value);
  }
}
