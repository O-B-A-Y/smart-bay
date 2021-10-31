// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../../interfaces/IDaoMember.sol";

contract DaoMember is IDaoMember {
  function totalStakedToken() external view returns (uint256) {}

  function info() external view returns (string memory) {}

  function vote() external returns (bool) {}

  function unvote() external returns (bool) {}

  function stake() external returns (bool) {}
}
