const { ethers } = require("hardhat");

async function main() {
  const ElectoralZkSetup = await ethers.getContractFactory("ElectoralZkSetup");
  const electoralZkSetup = await ElectoralZkSetup.deploy();
  await electoralZkSetup.deployed();
  console.log("ElectoralZkSetup deployed to:", electoralZkSetup.address);

  const VoterRegistration = await ethers.getContractFactory("VoterRegistration");
  const voterRegistration = await VoterRegistration.deploy();
  await voterRegistration.deployed();
  console.log("VoterRegistration deployed to:", voterRegistration.address);

  const BallotBox = await ethers.getContractFactory("BallotBox");
  const ballotBox = await BallotBox.deploy(
    voterRegistration.address,
    electoralZkSetup.address,
    Math.floor(Date.now() / 1000), // Start time (now)
    Math.floor(Date.now() / 1000) + 60 * 60 * 24 // End time (24 hours from now)
  );
  await ballotBox.deployed();
  console.log("BallotBox deployed to:", ballotBox.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });