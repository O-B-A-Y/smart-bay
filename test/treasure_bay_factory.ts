contract("TreasureBayFactory", function ([deployer]) {
  const TreasureBayFactory = artifacts.require("TreasureBayFactory");
  const TreasureBay = artifacts.require("TreasureBay");

  it("should deploy smart contracts properly", async () => {
    let contract = await TreasureBayFactory.deployed();
    console.log(contract.address);
    assert(contract.address !== "");
  });

  it("should have 0 treasure bays", async () => {
    let instance = await TreasureBayFactory.deployed();
    let allBays = await instance.getAllBays();
    assert(allBays.length === 0, "the number of bays in factory is not 0");
  });

  it("create a bay successfully", async () => {
    let instance = await TreasureBayFactory.deployed();
    const mockBayData = {
      name: "Binance",
      limitStakeHolders: 200,
      limitTreasureHunters: 300,
    };
    await instance.createNewBay(
      mockBayData.name,
      mockBayData.limitStakeHolders,
      mockBayData.limitTreasureHunters
    );
    let allBays = await instance.getAllBays();
    assert(allBays.length > 0, "treasure bay is not created");
    let bay = await TreasureBay.at(allBays[0]);
    await bay.createTreasureHunter();
    let treasureHunter = await bay.treasureHunters(deployer);
    assert(
      (await bay.listOfTreasureHunters()).length === 1,
      "number of treasureHunters is not updated"
    );
    assert(
      (treasureHunter as any).contractAddress === deployer,
      "treasureHunter info is not matched"
    );
    assert(
      web3.utils.fromWei(await bay.numberOfStakeholders()) === "0",
      "number of stakeholders must remain 0"
    );
    let bayName = await bay.name();
    assert(bayName === mockBayData.name, "treasure bay name is not matched");
  });

  it("delete a bay successfully", async () => {
    let instance = await TreasureBayFactory.deployed();
    const mockBayData = {
      name: "Binance",
      limitStakeHolders: 200,
      limitTreasureHunters: 300,
    };
    await instance.createNewBay(
      mockBayData.name,
      mockBayData.limitStakeHolders,
      mockBayData.limitTreasureHunters
    );
    let allBays = await instance.getAllBays();
    assert(allBays.length > 0, "treasure bay is not created");
    console.log(allBays);
    await instance.deleteBay(allBays[0]);

    let postDeletedBays = await instance.getAllBays();
    console.log(postDeletedBays);
    assert(
      postDeletedBays.length === allBays.length - 1,
      "treasure bay is not deleted"
    );
  });
});
