pragma solidity ^0.8.0;

import "./VoterRegistration.sol";
import "./ElectoralZkSetup.sol";

contract BallotBox {
    VoterRegistration public voterRegistration;
    ElectoralZkSetup public zkSetup;
    uint256 public electionStartTime;
    uint256 public electionEndTime;
    mapping(address => bool) public hasVoted;
    uint256 public yesVotes;
    uint256 public noVotes;

    event VoteCast(address voter, bool vote);

    constructor(address _voterRegistration, address _zkSetup, uint256 _electionStartTime, uint256 _electionEndTime) {
        voterRegistration = VoterRegistration(_voterRegistration);
        zkSetup = ElectoralZkSetup(_zkSetup);
        electionStartTime = _electionStartTime;
        electionEndTime = _electionEndTime;
    }

    function castVote(uint256[2] memory a, uint256[2][2] memory b, uint256[2] memory c, uint256[24] memory input) public {
        require(block.timestamp >= electionStartTime && block.timestamp <= electionEndTime, "Election is not active");
        require(voterRegistration.isRegistered(msg.sender), "Voter not registered");
        require(!hasVoted[msg.sender], "Voter has already voted");

        require(zkSetup.verifyProof(a, b, c, input), "Invalid proof");

        bool vote = input[0] == 1;

        hasVoted[msg.sender] = true;

        if (vote) {
            yesVotes++;
        } else {
            noVotes++;
        }

        emit VoteCast(msg.sender, vote);
    }

    function getResults() public view returns (uint256, uint256) {
        return (yesVotes, noVotes);
    }
}