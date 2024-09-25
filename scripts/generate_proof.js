const { groth16 } = require("snarkjs");
const path = require("path");
const fs = require("fs");

const wasmPath = path.join(__dirname, "../circuit", "circuit_js", "circuit.wasm");
const zkeyPath = path.join(__dirname, "../circuit", "circuit_final.zkey");

const generateProof = async (input) => {
  const { proof, publicSignals } = await groth16.fullProve(
    input,
    wasmPath,
    zkeyPath
  );

  const proofJson = JSON.stringify(proof, null, 2);
  const publicSignalsJson = JSON.stringify(publicSignals, null, 2);

  fs.writeFileSync(path.join(__dirname, "../proof.json"), proofJson);
  fs.writeFileSync(path.join(__dirname, "../publicSignals.json"), publicSignalsJson);

  console.log("Proof and public signals generated and saved.");
};

const main = async () => {
  const input = {
    vote: 1,
    nullifier: 12345,
  };

  await generateProof(input);
};

main();