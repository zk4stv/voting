const { groth16 } = require("snarkjs");
const path = require("path");

const wasmPath = path.join(__dirname, "../circuit", "circuit_js", "circuit.wasm");
const zkeyPath = path.join(__dirname, "../circuit", "circuit_final.zkey");

const generateZkey = async () => {
  const { zkey } = await groth16.setup(wasmPath);
  
  const zkeyJson = JSON.stringify(zkey, null, 2);
  fs.writeFileSync(zkeyPath, zkeyJson);

  console.log("Zkey generated and saved.");
};

generateZkey();