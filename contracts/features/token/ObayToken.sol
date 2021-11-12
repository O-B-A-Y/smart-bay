// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ObayToken is ERC20("ObayToken", "OBAY"), Ownable {
  constructor() {
    _mint(msg.sender, 1 ether);
  }

  function getTokenAddress() public view returns(address){
      return address(this);
  }

  /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (Bayer).
  function mint(address _to, uint256 _amount) public onlyOwner {
    require(_to == owner(), "[OBAY_ERROR] NO PERMISSION TO MINT TOKEN");
    _mint(_to, _amount);
  }

  function burn(address _to, uint256 _amount) public onlyOwner {
    require(_to == owner(), "[OBAY_ERROR] NO PERMISSION TO BURN TOKEN");
    _burn(_to, _amount);
  }
}
