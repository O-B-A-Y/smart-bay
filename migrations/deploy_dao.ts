module.exports = (artifacts: Truffle.Artifacts, _: Web3) => {
  return async (deployer: Truffle.Deployer, network: Network, _: string[]) => {
    const TreasureBayFactory = artifacts.require("TreasureBayFactory");

    await deployer.deploy(TreasureBayFactory);
    const treasureBayFactory = await TreasureBayFactory.deployed();
    console.log(
      `TreasureBayFactory is deployed at ${treasureBayFactory.address} in network: ${network}`
    );
  };
};
