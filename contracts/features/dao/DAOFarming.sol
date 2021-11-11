// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./DAOFactory.sol";

contract DAOFarming is DAOFactory {
    function fertilize(address daoAddress) external payable returns(bool){
        _mapOfDAOs[daoAddress].stake(msg.value);
        return true;
    }
}