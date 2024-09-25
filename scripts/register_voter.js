const { ethers } = require("hardhat");

async function main() {
  const VoterRegistration = await ethers.getContractFactory("VoterRegistration");
  const voterRegistration = await VoterRegistration.attach(
    "YOUR_VOTER_REGISTRATION_CONTRACT_ADDRESS" 
  );

  const [owner] = await ethers.getSigners();

  const voterAddress = "YOUR_VOTER_ADDRESS"; 

  const tx = await voterRegistration.registerVoter(voterAddress);
  await tx.wait();

  console.log(`Voter ${voterAddress} registered successfully.`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });