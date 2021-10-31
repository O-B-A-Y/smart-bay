// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../../interfaces/IDao.sol";

contract Dao is IDao {
  string private _name;
  uint64 private _limitNumberOfMembers;
  uint64 private _totalNumberOfMembers;
  uint256 private _limitFund;
  uint256 private _fund;

  mapping(address => bool) public allowedRecipients;

  Proposal[] public proposals;

  constructor(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint256 limitFund_
  ) IDao() {
    _name = name_;
    _limitNumberOfMembers = limitNumberOfMembers_;
    _limitFund = limitFund_;
  }

  function name() public view virtual override returns (string memory) {
    return _name;
  }

  function limitNumberOfMembers() public view virtual returns (uint64) {
    return _limitNumberOfMembers;
  }

  function totalNumberOfMembers() public view virtual returns (uint64) {
    return _totalNumberOfMembers;
  }

  function newProposal(
    address _recipient,
    uint256 _amount,
    string memory _description,
    bytes memory _transactionData,
    uint256 _debatingPeriod,
    bool _newCurator
  ) external payable returns (uint256 _proposalID) {}

  function vote(uint256 _proposalID) external returns (bool) {}

  function unvote(uint256 _proposalID) external returns (bool) {}

  function executeProposal(uint256 _proposalID, bytes memory _transactionData)
    external
    returns (bool _success)
  {}

  function changeAllowedRecipients(address _recipient, bool _allowed)
    external
    returns (bool _success)
  {}
}
