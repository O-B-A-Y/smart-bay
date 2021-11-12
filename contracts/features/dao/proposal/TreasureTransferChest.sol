// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./TransferProposal.sol";

contract TreasureTransferChest {
  uint64 public totalNumberOfProposals;
  TransferProposal[] public listOfTransferProposals;
  mapping(uint64 => TransferProposal) transferProposals;

  event NewTransferProposalAdded(
    string _title,
    address _sourceAddress,
    address _destinationAddress,
    uint256 _amount
  );

  function _newTransferProposal(
    string memory _title,
    string memory _description,
    uint256 _debatingPeriod,
    address _recipient,
    uint256 _amount
  ) internal returns (TransferProposal) {
    TransferProposal p = new TransferProposal(
      _description,
      _title,
      _debatingPeriod,
      _recipient,
      _amount
    );
    totalNumberOfProposals += 1;
    transferProposals[totalNumberOfProposals] = p;
    listOfTransferProposals.push(p);

    emit NewTransferProposalAdded(_title, msg.sender, _recipient, _amount);
    return p;
  }

  function getAllProposals() external view returns (TransferProposal[] memory) {
    return listOfTransferProposals;
  }

  function getProposal(uint64 _proposalId)
    external
    view
    returns (TransferProposal)
  {
    return transferProposals[_proposalId];
  }
}
