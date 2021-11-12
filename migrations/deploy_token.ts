module.exports = (artifacts: Truffle.Artifacts, _: Web3) => {
  return async (deployer: Truffle.Deployer, network: Network, _: string[]) => {
    const ObayToken = artifacts.require("ObayToken");

    await deployer.deploy(ObayToken);
    const token = await ObayToken.deployed();
    console.log(
      `ObayToken is deployed at ${token.address} in network: ${network}`
    );
  };
};
