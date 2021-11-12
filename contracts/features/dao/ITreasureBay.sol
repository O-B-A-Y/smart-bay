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

  // function newProposal(
  //   address _recipient,
  //   uint256 _amount,
  //   string memory _description,
  //   bytes memory _transactionData,
  //   uint256 _debatingPeriod,
  //   bool _newCurator
  // ) external payable returns (uint256 _proposalID);

  // function vote(uint256 _proposalID) external returns (bool);

  // function unvote(uint256 _proposalID) external returns (bool);

  // function executeProposal(uint256 _proposalID, bytes memory _transactionData)
  //   external
  //   returns (bool _success);

  // function changeAllowedRecipients(address _recipient, bool _allowed)
  //   external
  //   returns (bool _success);

  function toggleIsActivated(bool isActivated) external returns (bool _success);
}
