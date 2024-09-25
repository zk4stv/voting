const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  const BallotBox = await ethers.getContractFactory("BallotBox");
  const ballotBox = await BallotBox.attach(
    "YOUR_BALLOT_BOX_CONTRACT_ADDRESS"
  );

  const proof = JSON.parse(fs.readFileSync("./proof.json", "utf8"));
  const publicSignals = JSON.parse(fs.readFileSync("./publicSignals.json", "utf8"));

  const tx = await ballotBox.castVote(
    proof.pi_a,
    proof.pi_b,
    proof.pi_c,
    publicSignals
  );
  await tx.wait();

  console.log("Vote cast successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });