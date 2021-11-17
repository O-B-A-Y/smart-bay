// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

interface ITreasureBay {
  event ProposalAdded(
    uint256 indexed proposalID,
    address recipient,
    uint256 amount,
    string description
  );
  event Voted(uint256 indexed proposalID, bool position, address indexed voter);

  // function executeProposal(uint256 _proposalID, bytes memory _transactionData)
  //   external
  //   returns (bool _success);

  // function changeAllowedRecipients(address _recipient, bool _allowed)
  //   external
  //   returns (bool _success);

  // function toggleIsActivated(bool isActivated) external returns (bool _success);
}
