// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ITreasureBay.sol";
import "./TreasurePool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TreasureBay is ITreasureBay, TreasurePool {
  // struct Proposal {
  //   address recipient; // The address where the `amount` will go to if the proposal is accepted
  //   address creator; // Address of the shareholder who created the proposal
  //   uint256 amount; // The amount to transfer to `recipient` if the proposal is accepted.
  //   string description; // A plain text description of the proposal
  //   uint256 votingDeadline; // A unix timestamp, denoting the end of the voting period
  //   bool open; // True if the proposal's votes have yet to be counted, otherwise False
  //   bool proposalPassed; // True if quorum has been reached, the votes have been counted, and the majority said yes
  //   bytes32 proposalHash; // A hash to check validity of a proposal
  //   // Deposit in wei the creator added when submitting their proposal. It
  //   // is taken from the msg.value of a newProposal call.
  //   uint256 proposalDeposit;
  //   // true if more tokens are in favour of the proposal than opposed to it at
  //   // least `preSupportTime` before the voting deadline
  //   bool preSupport;
  //   mapping(address => bool) votedYes; // Simple mapping to check if a shareholder has voted for it
  //   mapping(address => bool) votedNo; // Simple mapping to check if a shareholder has voted against it
  // }
  uint64 private BAY_CREATION_FEE = 0.03 ether;
  string public name;
  uint256 public fund;
  address public creator;
  // If there are more than 3 members, activated
  bool public isActivated = false;

  mapping(address => bool) public allowedRecipients;

  // TODO Proposal[] public proposals;

  constructor(string memory name_, uint64 limitNumberOfStakeholders_)
    payable
    ITreasureBay()
  {
    limitNumberOfStakeholders = limitNumberOfStakeholders_;
    name = name_;
    creator = msg.sender;
    stakeholder = Stakeholder(msg.value, msg.sender, 3 days);
    // Initialize a staking pool
    _init(BAY_CREATION_FEE);
  }

  // function newProposal(
  //   address _recipient,
  //   uint256 _amount,
  //   string memory _description,
  //   bytes memory _transactionData,
  //   uint256 _debatingPeriod,
  //   bool _newCurator
  // ) external payable override returns (uint256 _proposalID) {}

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

  function toggleIsActivated(bool _isActivated)
    external
    override
    returns (bool _success)
  {
    isActivated = _isActivated;
    return true;
  }

  // function stake(uint256 _amount)
  //   external
  //   payable
  //   override
  // {
  //   IERC20 token = ERC20(msg.sender);
  //   uint256 erc20balance = token.balanceOf(msg.sender);
  //   token.approve(address(this), _amount);
  //   require(_amount <= erc20balance, "Amount is low");
  //   // token.transferFrom(msg.sender, address(this), _amount);
  //   // if (isActivated == false) {
  //   //   isActivated = true;
  //   // }
  // }
}
