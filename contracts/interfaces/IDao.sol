// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./IDaoMember.sol";

interface IDao {
  function name() external view returns (string memory);

  function memberName() external view returns (string memory);
}
