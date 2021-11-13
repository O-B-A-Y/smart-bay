// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./TransferProposal.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasureTransferChest is Ownable {
  TransferProposal[] private _listOfTransferProposals;
  mapping(address => TransferProposal) transferProposals;

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
  ) internal returns (uint256 proposalId) {
    TransferProposal p = new TransferProposal(
      _msgSender(),
      _description,
      _title,
      _debatingPeriod,
      _recipient,
      _amount
    );
    _listOfTransferProposals.push(p);
    transferProposals[address(p)] = p;

    emit NewTransferProposalAdded(_title, msg.sender, _recipient, _amount);
    return _listOfTransferProposals.length;
  }

  function getAllTransferProposals()
    external
    view
    returns (TransferProposal[] memory)
  {
    return _listOfTransferProposals;
  }

  function getTransferProposal(address _proposalAddress)
    external
    view
    returns (TransferProposal)
  {
    return transferProposals[_proposalAddress];
  }
}
