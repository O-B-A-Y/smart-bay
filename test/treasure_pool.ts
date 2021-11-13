import {
  TreasureBayFactoryInstance,
  TreasureBayInstance,
} from "../types/truffle-contracts";

contract("TreasurePool", function (accounts: string[]) {
  const TreasureBayFactory = artifacts.require("TreasureBayFactory");
  const TreasureBay = artifacts.require("TreasureBay");

  let treasureBayFactoryContract: TreasureBayFactoryInstance;
  let bay: TreasureBayInstance;

  before("initialized before running test", async () => {
    treasureBayFactoryContract = await TreasureBayFactory.deployed();

    /** Create a new bay */
    const mockBayData = {
      name: "Binance",
      limitStakeHolders: 200,
      limitTreasureHunters: 300,
    };
    await treasureBayFactoryContract.createNewBay(
      mockBayData.name,
      mockBayData.limitStakeHolders,
      mockBayData.limitTreasureHunters
    );
    let allBays = await treasureBayFactoryContract.getAllBays();
    bay = await TreasureBay.at(allBays[0]);
  });

  it("should deploy smart contracts properly", async () => {
    let contract = await TreasureBayFactory.deployed();
    console.log(contract.address);
    assert(contract.address !== "");
  });

  it("create a pool successfully", async () => {
    await bay.createTreasureHunter();
    let treasureHunter = await bay.treasureHunters(accounts[0]);
    assert(
      (treasureHunter as any).contractAddress === accounts[0],
      "treasureHunter info is not matched"
    );
    assert(
      (await bay.listOfTreasureHunters()).length === 1,
      "number of treasureHunters is not updated"
    );
    assert(
      web3.utils.fromWei(await bay.totalNumberOfStakeholders()) === "0",
      "number of stakeholders remain 0"
    );
    assert(
      web3.utils.fromWei(await bay.totalStakedAmount()) === "0",
      "wrong init staked number for dao"
    );
  });

  it("stake to pool successfully", async () => {
    await bay.stake({
      value: web3.utils.toWei("0.001"),
    });
    assert(
      web3.utils.fromWei(await bay.numberOfStakeholders()) ===
        "0.000000000000000001",
      "number of stakeholders must remain 1"
    );
    assert(
      web3.utils.fromWei(await bay.totalStakedAmount()) === `${0.001}`,
      "wrong staked number accumulated"
    );

    let stakeHolder = await bay.stakeholders(accounts[0]);
    assert(
      (stakeHolder as any).contractAddress === accounts[0],
      "stakeholder info is not matched"
    );
    assert(
      web3.utils.fromWei((stakeHolder as any).balance) === `${0.001}`,
      "stakeholder balance is wrong"
    );

    try {
      await bay.unstake({
        value: web3.utils.toWei("0.0005"),
      });
      assert(
        web3.utils.fromWei(await bay.totalStakedAmount()) === `${0.0005}`,
        "wrong staked number accumulated"
      );
    } catch (error: any) {
      assert(
        error.reason === "Must staked for 7 days before unstaking",
        "error message is not valid"
      );
    }
  });
});
