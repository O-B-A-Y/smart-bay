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
  string public name;
  address public creator;
  uint64 public limitNumberOfTreasureHunters;
  TreasureHunter[] private _listOfTreasureHunters;
  mapping(address => TreasureHunter) public treasureHunters;
  bool private _isActivated = false; // If there are more than 3 members, activated
  mapping(address => bool) public allowedRecipients;
  uint256 public createdAt;

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
    limitNumberOfTreasureHunters = limitNumberOfTreasureHunters_;
    name = name_;
    creator = _msgSender();
    createdAt = block.timestamp;
  }

  function listOfTreasureHunters()
    public
    view
    virtual
    returns (TreasureHunter[] memory)
  {
    return _listOfTreasureHunters;
  }

  function createTreasureHunter() public returns (TreasureHunter memory) {
    require(
      _listOfTreasureHunters.length <= limitNumberOfTreasureHunters,
      "surpass limit number of treasureHunters"
    );
    treasureHunters[_msgSender()] = TreasureHunter(
      _msgSender(),
      block.timestamp
    );
    _listOfTreasureHunters.push(treasureHunters[_msgSender()]);
    if (_listOfTreasureHunters.length > 5) {
      _isActivated = true;
    }
    emit NewTreasureHunter(
      treasureHunters[_msgSender()].contractAddress,
      block.timestamp
    );
    return treasureHunters[_msgSender()];
  }

  function createNewTransferProposal(
    string memory _title,
    string memory _description,
    uint64 _debatingPeriod,
    address _recipient,
    uint256 _amount
  ) public onlyStakeholder returns (uint256) {
    return
      _newTransferProposal(
        _title,
        _description,
        _debatingPeriod,
        _recipient,
        _amount
      );
  }

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
