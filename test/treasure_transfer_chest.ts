import { BN } from "bn.js";
import {
  TreasureBayFactoryInstance,
  TreasureBayInstance,
  TreasureTransferChestInstance,
} from "../types/truffle-contracts";

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("TreasureTransferChest", function ([deployer]) {
  const TreasureTransferChest = artifacts.require("TreasureTransferChest");
  const TreasureBayFactory = artifacts.require("TreasureBayFactory");
  const TreasureBay = artifacts.require("TreasureBay");
  const TransferProposal = artifacts.require("TransferProposal");

  let treasureTransferChest: TreasureTransferChestInstance;
  let treasureBayFactoryContract: TreasureBayFactoryInstance;
  let bay: TreasureBayInstance;

  before("initialized before running test", async () => {
    treasureTransferChest = await TreasureTransferChest.deployed();
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
    console.log(treasureTransferChest.address);
    assert(treasureTransferChest.address !== "");
  });

  it("initialized chest", async () => {
    let listOfTransferProposals =
      await treasureTransferChest.getAllTransferProposals();

    assert(
      listOfTransferProposals.length === 0,
      "list of proposals must be empty"
    );
  });

  it("add new proposal before staking", async () => {
    assert(
      (await bay.getAllTransferProposals()).length === 0,
      "chest must be empty"
    );

    let dateInAWeek = new Date();
    dateInAWeek.setDate(dateInAWeek.getDate() + 7);
    const deadline = Math.floor(dateInAWeek.getTime() / 1000);

    const mockProposalData = {
      title: "Testing proposal",
      description: "Hello World",
      duration: deadline,
      recipient: deployer,
      amount: "0.001",
    };
    try {
      await bay.createNewTransferProposal(
        mockProposalData.title,
        mockProposalData.description,
        new BN(mockProposalData.duration),
        mockProposalData.recipient,
        web3.utils.toWei(mockProposalData.amount)
      );
    } catch (error: any) {
      assert(error.reason === "must be a stakeholder", "must be a stakeholder");
    }
  });

  it("add new proposal after staking", async () => {
    let dateInAWeek = new Date();
    dateInAWeek.setDate(dateInAWeek.getDate() + 7);
    const deadline = Math.floor(dateInAWeek.getTime() / 1000);

    const mockProposalData = {
      title: "Testing proposal",
      description: "Hello World",
      duration: deadline,
      recipient: deployer,
      amount: "0.001",
    };

    await bay.stake({
      value: web3.utils.toWei("0.001"),
    });

    await bay.createNewTransferProposal(
      mockProposalData.title,
      mockProposalData.description,
      new BN(mockProposalData.duration),
      mockProposalData.recipient,
      web3.utils.toWei(mockProposalData.amount),
      {
        from: deployer,
      }
    );
    let listOfProposals = await bay.getAllTransferProposals();
    assert(
      (await listOfProposals).length == 1,
      "number of proposals is not updated"
    );
    let proposal = await TransferProposal.at(listOfProposals[0]);
    console.log(await proposal.creator(), deployer);
    assert(
      (await proposal.creator()) == deployer,
      "creator field has wrong value"
    );
  });

  it("vote and unvote is working", async () => {
    let listOfProposals = await bay.getAllTransferProposals();
    assert(listOfProposals.length === 1);
    let proposal = await TransferProposal.at(listOfProposals[0]);
    assert(
      proposal.address == listOfProposals[0],
      "proposal address does not match"
    );
    await proposal.voteYes();
    let numberOfYesVote = web3.utils.fromWei(await proposal.numberOfYesVote());
    assert(
      numberOfYesVote == "0.000000000000000001",
      "number of yes votes is not updated"
    );
    assert.isTrue(
      await proposal.votedYes(deployer),
      "must be in the voted yes list"
    );
    let numberOfNoVote = web3.utils.fromWei(await proposal.numberOfNoVote());
    assert(numberOfNoVote == "0", "number of no votes is wrong");
    try {
      await proposal.voteNo();
    } catch (error: any) {
      assert(
        error.reason == "the address has voted already",
        "invalid error message"
      );
    }

    await proposal.unvote();
    numberOfYesVote = web3.utils.fromWei(await proposal.numberOfYesVote());
    assert(numberOfYesVote == "0", "number of yes votes is not updated");
    assert.isFalse(
      await proposal.votedYes(deployer),
      "must not be in the voted yes list"
    );
    numberOfNoVote = web3.utils.fromWei(await proposal.numberOfNoVote());
    assert(numberOfNoVote == "0", "number of no votes is wrong");

    await proposal.voteNo();
    numberOfYesVote = web3.utils.fromWei(await proposal.numberOfYesVote());
    assert(numberOfYesVote == "0", "number of yes votes is not updated");
    numberOfNoVote = web3.utils.fromWei(await proposal.numberOfNoVote());
    assert(
      numberOfNoVote == "0.000000000000000001",
      "number of no votes is wrong"
    );
  });

  it("execute transfer proposal", () => {});
});
