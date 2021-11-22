// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Proposal is Ownable {
  // EXCHANGE : 1, TRANSFER : 2
  enum ProposalType {
    EXCHANGE,
    TRANSFER
  }

  struct Voter {
    address voterAddress;
    uint256 votedAt;
    bool approved;
  }

  enum Status {
    ON,
    OFF
  }

  Voter[] private _voters;
  address public creator; // Address of the shareholder who created the proposal
  string public description; // A plain text description of the proposal
  string public title;
  uint256 public votingDeadline; // A unix timestamp, denoting the end of the voting period
  Status public open; // True if the proposal's votes have yet to be counted, otherwise False
  bool public proposalPassed; // True if quorum has been reached, the votes have been counted, and the majority said yes
  mapping(address => bool) public votedYes;
  uint64 public numberOfYesVote;
  mapping(address => bool) public votedNo;
  uint64 public numberOfNoVote;
  uint256 public createdAt;

  event ProposalClosed(address indexed proposalAddress, uint256 timestamp);
  event ProposalVoted(
    address indexed proposalAddress,
    address indexed voter,
    bool isVotedYes
  );
  event ProposalUnvoted(address indexed proposalAddress, address indexed voter);

  constructor(
    address _creator,
    string memory _description,
    string memory _title,
    uint256 _debatingPeriod
  ) {
    creator = _creator;
    description = _description;
    title = _title;
    votingDeadline = _debatingPeriod;
    open = Status.ON;
    proposalPassed = false;
    createdAt = block.timestamp;
  }

  function getVoters() external view returns (Voter[] memory) {
    return _voters;
  }

  function checkApprovalStatus()
    external
    view
    returns (uint64 approvalPercentage)
  {
    return (numberOfYesVote * 100) / (numberOfYesVote + numberOfNoVote);
  }

  function _checkIsVoted() private view returns (bool) {
    return votedYes[_msgSender()] == true || votedNo[_msgSender()] == true;
  }

  function _checkIsNotVoted() private view returns (bool) {
    return votedYes[_msgSender()] != true && votedNo[_msgSender()] != true;
  }

  function close() public {
    require(creator == _msgSender(), "not an owner");
    open = Status.OFF;
    emit ProposalClosed(address(this), block.timestamp);
  }

  function voteYes() public {
    require(_checkIsNotVoted(), "the address has voted already");
    votedYes[_msgSender()] = true;
    _voters.push(Voter(_msgSender(), block.timestamp, true));
    numberOfYesVote += 1;
    emit ProposalVoted(address(this), msg.sender, true);
  }

  function voteNo() public {
    require(_checkIsNotVoted(), "the address has voted already");
    votedNo[_msgSender()] = true;
    _voters.push(Voter(_msgSender(), block.timestamp, false));
    numberOfNoVote += 1;
    emit ProposalVoted(address(this), msg.sender, true);
  }

  function unvote() public {
    require(_checkIsVoted(), "the address did not vote yet");
    if (votedYes[_msgSender()] == true) {
      delete votedYes[_msgSender()];
      numberOfYesVote -= 1;
    }
    if (votedNo[_msgSender()] == true) {
      delete votedNo[_msgSender()];
      numberOfNoVote -= 1;
    }
    emit ProposalUnvoted(address(this), msg.sender);
  }
}
