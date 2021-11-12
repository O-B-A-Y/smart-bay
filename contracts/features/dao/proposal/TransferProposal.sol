// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./Proposal.sol";

contract TransferProposal is Proposal {
  address public recipient; // The address where the `amount` will go to if the proposal is accepted
  uint256 public amount; // The amount to transfer to `recipient` if the proposal is accepted.
  ProposalType constant proposalType = ProposalType.TRANSFER;

  constructor(
    string memory _description,
    string memory _title,
    uint256 _debatingPeriod,
    address _recipient,
    uint256 _amount
  ) Proposal(_description, _title, _debatingPeriod) {
    recipient = _recipient;
    amount = _amount;
  }
}
