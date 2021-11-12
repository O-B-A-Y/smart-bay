const TreasureBayFactory = artifacts.require("TreasureBayFactory.sol");

module.exports = function (deployer, _network) {
  deployer.deploy(TreasureBayFactory);
};
