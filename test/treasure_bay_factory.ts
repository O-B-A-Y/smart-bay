const TreasureBayFactory = artifacts.require("TreasureBayFactory");
const TreasureBay = artifacts.require("TreasureBay");

contract("TreasureBayFactory", async function (/* accounts */) {
  it("should deploy smart contract properly", async () => {
    let scopedInstance = await TreasureBayFactory.deployed();
    console.log(scopedInstance.address);
    assert(scopedInstance.address !== "");
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
      limitMembers: 200,
    };
    await instance.createNewBay(mockBayData.name, mockBayData.limitMembers);
    let allBays = await instance.getAllBays();
    assert(allBays.length > 0, "treasure bay is not created");
    let bay = await TreasureBay.at(allBays[0]);
    let bayName = await bay.name();
    assert(bayName === mockBayData.name, "treasure bay name is not matched");
  });
});
