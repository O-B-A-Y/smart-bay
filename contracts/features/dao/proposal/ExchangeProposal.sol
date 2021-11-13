// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./Proposal.sol";

contract ExchangeProposal is Proposal {
  address private _fromTokenAddress;
  address private _toTokenAddress;
  ProposalType constant proposalType = ProposalType.EXCHANGE;

  constructor(
    address _creator,
    string memory description_,
    string memory title_,
    uint256 debatingPeriod_,
    address fromTokenAddress_,
    address toTokenAddress_
  ) Proposal(_creator, description_, title_, debatingPeriod_) {
    _fromTokenAddress = fromTokenAddress_;
    _toTokenAddress = toTokenAddress_;
  }
}
