const ObayToken = artifacts.require("ObayToken.sol");

module.exports = function (deployer, _network) {
  deployer.deploy(ObayToken);
};
