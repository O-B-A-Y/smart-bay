// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../../interfaces/IDAO.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO is IDAO {
  struct Proposal {
    address recipient; // The address where the `amount` will go to if the proposal is accepted
    address creator; // Address of the shareholder who created the proposal
    uint256 amount; // The amount to transfer to `recipient` if the proposal is accepted.
    string description; // A plain text description of the proposal
    uint256 votingDeadline; // A unix timestamp, denoting the end of the voting period
    bool open; // True if the proposal's votes have yet to be counted, otherwise False
    bool proposalPassed; // True if quorum has been reached, the votes have been counted, and the majority said yes
    bytes32 proposalHash; // A hash to check validity of a proposal
    // Deposit in wei the creator added when submitting their proposal. It
    // is taken from the msg.value of a newProposal call.
    uint256 proposalDeposit;
    // true if more tokens are in favour of the proposal than opposed to it at
    // least `preSupportTime` before the voting deadline
    bool preSupport;
    mapping(address => bool) votedYes; // Simple mapping to check if a shareholder has voted for it
    mapping(address => bool) votedNo; // Simple mapping to check if a shareholder has voted against it
  }

  string public name;
  uint64 public limitNumberOfMembers;
  uint64 public totalNumberOfMembers;
  uint256 public limitFund;
  uint256 public fund;
  address public creator;
  uint256 public totalFund;
  bool public isActivated;

  mapping(address => bool) public allowedRecipients;

  Proposal[] public proposals;

  constructor(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint256 limitFund_
  ) IDAO()  {
    name = name_;
    limitNumberOfMembers = limitNumberOfMembers_;
    limitFund = limitFund_;
    creator = msg.sender;
    isActivated = false;
  }

  function newProposal(
    address _recipient,
    uint256 _amount,
    string memory _description,
    bytes memory _transactionData,
    uint256 _debatingPeriod,
    bool _newCurator
  ) external override payable returns (uint256 _proposalID) {}

  function vote(uint256 _proposalID) external override returns (bool) {}

  function unvote(uint256 _proposalID) external override returns (bool) {}

  function executeProposal(uint256 _proposalID, bytes memory _transactionData)
    external
    override
    returns (bool _success)
  {}

  function changeAllowedRecipients(address _recipient, bool _allowed)
    external
    override
    returns (bool _success)
  {}
  
  function toggleIsActivated(bool _isActivated) override external returns (bool _success){
      isActivated = _isActivated;
      return true;
  }
  
  function stake(uint256 _amount) external override payable returns(bool){
    IERC20 token = IERC20(msg.sender);
    uint256 erc20balance = token.balanceOf(msg.sender);
    require (_amount <= erc20balance, "Amount is low");
    token.transfer(address(this), msg.value);
    if (isActivated == false){
        isActivated = true;
    }
    return true;
  }
}
