// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

import "./IDAO.sol";

interface IDAOFactory {
  // Require to  create a HD Wallet first before create a DAO
  event CreatedDAO(string indexed name, address indexed creator, address indexed daoAddress);

  function createNewDAO(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint256 limitFund_
  ) external returns (bool);

  function getAllDAOs() external returns (IDAO[] memory);

  function getDAO(address daoAddress) external view returns (IDAO);
}
