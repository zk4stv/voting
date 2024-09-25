pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VoterRegistration is Ownable {
    mapping(address => bool) public registeredVoters;

    event VoterRegistered(address voter);

    function registerVoter(address _voter) public onlyOwner {
        require(!registeredVoters[_voter], "Voter already registered");
        registeredVoters[_voter] = true;
        emit VoterRegistered(_voter);
    }

    function isRegistered(address _voter) public view returns (bool) {
        return registeredVoters[_voter];
    }
}