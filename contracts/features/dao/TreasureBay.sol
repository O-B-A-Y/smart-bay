// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ITreasureBay.sol";
import "./TreasurePool.sol";
import "./proposal/ExchangeProposal.sol";
import "./proposal/TransferProposal.sol";
import "./proposal/TreasureExchangeChest.sol";
import "./proposal/TreasureTransferChest.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TreasureBay is
  ITreasureBay,
  TreasurePool,
  TreasureTransferChest,
  TreasureExchangeChest
{
  struct TreasureHunter {
    address contractAddress;
    uint256 joinedAt;
  }
  string private _name;
  address private _creator;
  uint64 public totalNumberOfTreasureHunters;
  uint64 private _limitNumberOfTreasureHunters;
  mapping(address => TreasureHunter) public treasureHunters;
  bool private _isActivated = false; // If there are more than 3 members, activated
  mapping(address => bool) public allowedRecipients;

  event NewTreasureHunter(address treasureHunter, uint256 timestamp);

  modifier onlyStakeholder() {
    require(stakeholders[msg.sender].balance > 0, "must be a stakeholder");
    _;
  }

  modifier onlyTreasureHunter() {
    require(
      treasureHunters[msg.sender].contractAddress != address(0x0),
      "must be a treasureHunter"
    );
    _;
  }

  constructor(
    string memory name_,
    uint64 limitNumberOfStakeholders_,
    uint64 limitNumberOfTreasureHunters_
  ) payable ITreasureBay() {
    limitNumberOfStakeholders = limitNumberOfStakeholders_;
    _limitNumberOfTreasureHunters = limitNumberOfTreasureHunters_;
    _name = name_;
    _creator = _msgSender();
  }

  function name() public view virtual returns (string memory) {
    return _name;
  }

  function creator() public view virtual returns (address) {
    return _creator;
  }

  function limitNumberOfTreasureHunters() public view virtual returns (uint64) {
    return _limitNumberOfTreasureHunters;
  }

  function createTreasureHunter() public returns (TreasureHunter memory) {
    require(
      totalNumberOfTreasureHunters <= _limitNumberOfTreasureHunters,
      "surpass limit number of treasureHunters"
    );
    totalNumberOfTreasureHunters += 1;
    if (totalNumberOfTreasureHunters > 5) {
      toggleIsActivated(true);
    }
    treasureHunters[_msgSender()] = TreasureHunter(
      _msgSender(),
      block.timestamp
    );
    emit NewTreasureHunter(
      treasureHunters[_msgSender()].contractAddress,
      block.timestamp
    );
    return treasureHunters[_msgSender()];
  }

  function toggleIsActivated(bool isActivated_) public returns (bool _success) {
    _isActivated = isActivated_;
    return true;
  }

  function createNewTransferProposal(
    string memory _title,
    string memory _description,
    uint64 _debatingPeriod,
    address _recipient,
    uint256 _amount
  ) public onlyStakeholder {
    _newTransferProposal(
      _title,
      _description,
      _debatingPeriod,
      _recipient,
      _amount
    );
  }

  // function vote(uint256 _proposalID) external override returns (bool) {}

  // function unvote(uint256 _proposalID) external override returns (bool) {}

  // function executeProposal(uint256 _proposalID, bytes memory _transactionData)
  //   external
  //   override
  //   returns (bool _success)
  // {}

  // function changeAllowedRecipients(address _recipient, bool _allowed)
  //   external
  //   override
  //   returns (bool _success)
  // {}
}
