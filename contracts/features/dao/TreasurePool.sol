// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

contract TreasurePool {
  struct Stakeholder {
    uint256 balance;
    address walletAddress;
    uint256 claimedInterval;
  }
  mapping(address => Stakeholder) public stakeholders;
  address public admin;
  address public daoAddress;
  uint256 public totalStakedAmount;
  uint64 public limitNumberOfStakeholders;
  uint64 public totalNumberOfStakeholders;
  Stakeholder stakeholder;

  event NewStakeholder(address stakeholder);
  event RemoveStakeholder(address stakeholder);
  event Stake(address stakeholder, uint256 amount);
  event Unstake(address stakeholder, uint256 amount);
  event NewPoolCreated();

  constructor() {
    admin = msg.sender;
  }

  modifier isStakeholder() {
    require(stakeholders[msg.sender].balance > 0, "Not a stakeholder");
    _;
  }

  function _init(uint256 _amount) internal {
    stakeholder = Stakeholder(_amount, msg.sender, 3 days);
    stakeholders[msg.sender] = stakeholder;
    totalStakedAmount += _amount;
    emit NewPoolCreated();
  }

  function _stake() internal {
    if (stakeholders[msg.sender].balance == 0) {
      stakeholder = Stakeholder(msg.value, msg.sender, 3 days);
      stakeholders[msg.sender] = stakeholder;
      emit NewStakeholder(msg.sender);
    } else {
      stakeholders[msg.sender].balance += msg.value;
    }
    totalStakedAmount += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  function _unstake() internal isStakeholder {
    require(
      msg.value <= stakeholders[msg.sender].balance,
      "Insufficient staked amount"
    );
    payable(msg.sender).transfer(msg.value);
    stakeholders[msg.sender].balance -= msg.value;
    if (stakeholders[msg.sender].balance == 0) {
      delete stakeholders[msg.sender];
      emit RemoveStakeholder(msg.sender);
    }
    totalStakedAmount -= msg.value;
    emit Unstake(msg.sender, msg.value);
  }

  function _claim() internal isStakeholder {
    require(
      block.timestamp > stakeholders[msg.sender].claimedInterval,
      "Too early"
    );
    stakeholders[msg.sender].claimedInterval = 3 days;
    // TODO Handle interest rate and claimable tokens
  }
}
