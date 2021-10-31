// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IDao {
  struct Proposal {
    // The address where the `amount` will go to if the proposal is accepted
    address recipient;
    // The amount to transfer to `recipient` if the proposal is accepted.
    uint256 amount;
    // A plain text description of the proposal
    string description;
    // A unix timestamp, denoting the end of the voting period
    uint256 votingDeadline;
    // True if the proposal's votes have yet to be counted, otherwise False
    bool open;
    // True if quorum has been reached, the votes have been counted, and
    // the majority said yes
    bool proposalPassed;
    // A hash to check validity of a proposal
    bytes32 proposalHash;
    // Deposit in wei the creator added when submitting their proposal. It
    // is taken from the msg.value of a newProposal call.
    uint256 proposalDeposit;
    // True if this proposal is to assign a new Curator
    bool newCurator;
    // true if more tokens are in favour of the proposal than opposed to it at
    // least `preSupportTime` before the voting deadline
    bool preSupport;
    // Number of Tokens in favor of the proposal
    uint256 yea;
    // Number of Tokens opposed to the proposal
    uint256 nay;
    // Simple mapping to check if a shareholder has voted for it
    mapping(address => bool) votedYes;
    // Simple mapping to check if a shareholder has voted against it
    mapping(address => bool) votedNo;
    // Address of the shareholder who created the proposal
    address creator;
  }

  event ProposalAdded(
    uint256 indexed proposalID,
    address recipient,
    uint256 amount,
    string description
  );
  event Voted(uint256 indexed proposalID, bool position, address indexed voter);

  function name() external view returns (string memory);

  function limitNumberOfMembers() external view returns (uint64);

  function newProposal(
    address _recipient,
    uint256 _amount,
    string memory _description,
    bytes memory _transactionData,
    uint256 _debatingPeriod,
    bool _newCurator
  ) external payable returns (uint256 _proposalID);

  function vote(uint256 _proposalID) external returns (bool);

  function unvote(uint256 _proposalID) external returns (bool);

  function executeProposal(uint256 _proposalID, bytes memory _transactionData)
    external
    returns (bool _success);

  function changeAllowedRecipients(address _recipient, bool _allowed)
    external
    returns (bool _success);
}
