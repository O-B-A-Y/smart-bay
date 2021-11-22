import moment from "moment";

module.exports = (artifacts: Truffle.Artifacts, _: Web3) => {
  return async (deployer: Truffle.Deployer, network: Network, _: string[]) => {
    const TreasureBayFactory = artifacts.require("TreasureBayFactory");
    const ObayTreasury = artifacts.require("ObayTreasury");

    await deployer.deploy(ObayTreasury);
    const treasury = await ObayTreasury.deployed();
    console.log(
      `ObayTreasury is deployed at ${treasury.address} in network: ${network}`
    );

    await treasury.createNewProposal(
      "Adding OBAY/USDT pair liquidity pool",
      "Considering between Uniswap V3 and Sushiswap for the OBAY/USDT liquidity pool, this will be for the OBAY IDO",
      moment().add(28, "days").unix()
    );

    await treasury.createNewProposal(
      "Construct a governance structure for OBAY token",
      "Including token allocation and govern the community by public sale ",
      moment().add(27, "days").unix()
    );

    await treasury.createNewProposal(
      "Security checking for smart contracts",
      "Must check before pushing to production. There might be a malicious code",
      moment().add(27, "days").unix()
    );

    await deployer.deploy(TreasureBayFactory);
    const treasureBayFactory = await TreasureBayFactory.deployed();
    console.log(
      `TreasureBayFactory is deployed at ${treasureBayFactory.address} in network: ${network}`
    );
  };
};
