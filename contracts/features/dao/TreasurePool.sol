// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "@openzeppelin/contracts/utils/Context.sol";

contract TreasurePool is Context {
  struct Stakeholder {
    uint256 balance;
    address contractAddress;
    uint256 claimedInterval;
    uint256 joinedAt;
  }
  Stakeholder[] private _listOfStakeholders;
  mapping(address => Stakeholder) public stakeholders;
  uint64 public numberOfStakeholders;
  address public admin;
  uint256 public totalStakedAmount;
  uint64 public limitNumberOfStakeholders;
  uint64 public totalNumberOfStakeholders;
  uint64 private _lockedDuration = 7 days;
  uint64 private _defaultClaimedInterval = 3 days;
  uint64 public minimumStakedAmount;

  event NewStakeholder(address stakeholder);
  event RemoveStakeholder(address stakeholder);
  event Stake(address stakeholder, uint256 amount);
  event Unstake(address stakeholder, uint256 amount);
  event NewPoolCreated(address owner, uint256 lockedAmount);

  constructor() {
    admin = _msgSender();
  }

  modifier isStakeholder() {
    require(stakeholders[_msgSender()].balance > 0, "Not a stakeholder");
    _;
  }

  function createStakeholder() public returns (Stakeholder memory) {
    require(
      numberOfStakeholders <= limitNumberOfStakeholders,
      "surpass limit number of stakeholders"
    );
    stakeholders[_msgSender()] = Stakeholder(
      0,
      _msgSender(),
      block.timestamp + _defaultClaimedInterval,
      block.timestamp
    );
    _listOfStakeholders.push(stakeholders[_msgSender()]);
    numberOfStakeholders += 1;
    emit NewStakeholder(stakeholders[_msgSender()].contractAddress);
    return stakeholders[_msgSender()];
  }

  function stake() public payable {
    require(msg.value > 0, "invalid staked amount");
    require(msg.value > minimumStakedAmount, "invalid staked amount");

    // Check if the stakeholder is added or not
    if (stakeholders[_msgSender()].balance == 0) {
      createStakeholder();
    }
    stakeholders[_msgSender()].balance += msg.value;
    totalStakedAmount += msg.value;
    emit Stake(_msgSender(), msg.value);
  }

  function unstake() public payable isStakeholder {
    require(
      block.timestamp > stakeholders[_msgSender()].joinedAt + _lockedDuration,
      "Must staked for 7 days before unstaking"
    );
    require(
      msg.value <= stakeholders[_msgSender()].balance,
      "Insufficient staked amount"
    );
    payable(_msgSender()).transfer(msg.value);
    stakeholders[_msgSender()].balance += msg.value;
    if (stakeholders[_msgSender()].balance == 0) {
      removeStakeholder(_msgSender());
    }
    totalStakedAmount -= msg.value;
    emit Unstake(_msgSender(), msg.value);
  }

  function removeStakeholder(address stakeholder) public {
    for (uint256 index = 0; index < _listOfStakeholders.length; index++) {
      if (_listOfStakeholders[index].contractAddress == _msgSender()) {
        _listOfStakeholders[index] = _listOfStakeholders[index + 1];
        _listOfStakeholders.pop();
      }
    }
    delete stakeholders[stakeholder];
    numberOfStakeholders -= 1;
    emit RemoveStakeholder(stakeholder);
  }

  function claim() public payable isStakeholder {
    require(
      block.timestamp > stakeholders[_msgSender()].claimedInterval,
      "Too early"
    );
    stakeholders[_msgSender()].claimedInterval = 3 days;
    // TODO Handle interest rate and claimable tokens
  }

  function listOfStakeholders()
    public
    view
    virtual
    returns (Stakeholder[] memory)
  {
    return _listOfStakeholders;
  }
}
