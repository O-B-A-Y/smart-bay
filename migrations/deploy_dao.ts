module.exports = (artifacts: Truffle.Artifacts, _: Web3) => {
  return async (deployer: Truffle.Deployer, network: Network, _: string[]) => {
    const TreasureBayFactory = artifacts.require("TreasureBayFactory");

    await deployer.deploy(TreasureBayFactory);
    const treasureBayFactory = await TreasureBayFactory.deployed();
    console.log(
      `TreasureBayFactory is deployed at ${treasureBayFactory.address} in network: ${network}`
    );

    // /** Liquidity pool aka Fund */
    // const TreasurePool = artifacts.require("TreasurePool");
    // await deployer.deploy(TreasurePool);
    // const treasurePool = await TreasurePool.deployed();
    // console.log(
    //   `TreasurePool is deployed at ${treasurePool.address} in network: ${network}`
    // );

    // /** Proposal storages */
    // const TreasureTransferChest = artifacts.require("TreasureTransferChest");
    // await deployer.deploy(TreasureTransferChest);
    // const treasureTransferChest = await TreasureTransferChest.deployed();
    // console.log(
    //   `TreasureTransferChest is deployed at ${treasureTransferChest.address} in network: ${network}`
    // );

    // const TreasureExchangeChest = artifacts.require("TreasureExchangeChest");
    // await deployer.deploy(TreasureExchangeChest);
    // const treasureExchangeChest = await TreasureExchangeChest.deployed();
    // console.log(
    //   `TreasureExchangeChest is deployed at ${treasureExchangeChest.address} in network: ${network}`
    // );
  };
};
