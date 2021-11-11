// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../../interfaces/IDAOFactory.sol";
import "./DAO.sol";

contract DAOFactory is IDAOFactory {
  IDAO[] private _listOfDAOs;
  mapping(address => IDAO) _mapOfDAOs;

  function createNewDAO(
    string memory name_,
    uint64 limitNumberOfMembers_,
    uint256 limitFund_
  ) external override returns (bool) {
    DAO dao = new DAO(
      name_,
      limitNumberOfMembers_,
      limitFund_
    );
    _listOfDAOs.push(dao);
    _mapOfDAOs[address(dao)] = dao;
    
    emit CreatedDAO(name_, msg.sender, address(dao));
    return true;
  }

  function getAllDAOs() external override view returns (IDAO[] memory) {
    return _listOfDAOs;
  }

  function getDAO(address daoAddress) external override view returns (IDAO) {
    return _mapOfDAOs[address(daoAddress)];
  }
}
