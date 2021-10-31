// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../../interfaces/IDao.sol";
import "./DaoMember.sol";

contract Dao is IDao {
  string private _name;
  string private _memberName;
  mapping(address => DaoMember) public members;

  constructor(string memory name_, string memory memberName_) {
    _name = name_;
    _memberName = memberName_;
  }

  function name() public view virtual override returns (string memory) {
    return _name;
  }

  function memberName() public view virtual override returns (string memory) {
    return _memberName;
  }
}
