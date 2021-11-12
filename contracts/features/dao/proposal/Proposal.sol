// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Proposal is Ownable {
  // EXCHANGE : 1, TRANSFER : 2
  enum ProposalType {
    EXCHANGE,
    TRANSFER
  }

  address public creator; // Address of the shareholder who created the proposal
  string public description; // A plain text description of the proposal
  string public title;
  uint256 public votingDeadline; // A unix timestamp, denoting the end of the voting period
  bool public open; // True if the proposal's votes have yet to be counted, otherwise False
  bool public proposalPassed; // True if quorum has been reached, the votes have been counted, and the majority said yes
  mapping(address => bool) public votedYes; // Simple mapping to check if a shareholder has voted for it
  mapping(address => bool) public votedNo; // Simple mapping to check if a shareholder has voted against it

  constructor(
    string memory _description,
    string memory _title,
    uint256 _debatingPeriod
  ) {
    creator = _msgSender();
    description = _description;
    title = _title;
    votingDeadline = _debatingPeriod;
    open = false;
    proposalPassed = false;
  }

  function close() public onlyOwner {
    open = false;
  }
}
