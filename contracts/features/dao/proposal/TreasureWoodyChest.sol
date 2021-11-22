// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./Proposal.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasureWoodyChest is Ownable {
  Proposal[] private _listOfProposals;
  mapping(address => Proposal) proposals;

  event NewProposalAdded(string _title, address _sourceAddress);

  function _newProposal(
    string memory _title,
    string memory _description,
    uint256 _debatingPeriod
  ) internal returns (uint256 proposalId) {
    Proposal p = new Proposal(
      _msgSender(),
      _description,
      _title,
      _debatingPeriod
    );
    _listOfProposals.push(p);
    proposals[address(p)] = p;

    emit NewProposalAdded(_title, msg.sender);
    return _listOfProposals.length;
  }

  function getAllProposals() external view returns (Proposal[] memory) {
    return _listOfProposals;
  }

  function getProposal(address _proposalAddress)
    external
    view
    returns (Proposal)
  {
    return proposals[_proposalAddress];
  }
}
