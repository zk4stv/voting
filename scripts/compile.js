const path = require("path");
const compiler = require("circom");

const circuitPath = path.join(__dirname, "../circuit", "circuit.circom");

compiler(circuitPath).then((circuit) => {
  const jsonPath = path.join(__dirname, "../circuit", "circuit.json");
  const wasmPath = path.join(__dirname, "../circuit", "circuit_js", "circuit.wasm");

  circuit.r1cs.writeToFile(jsonPath);
  circuit.wasm.writeToFile(wasmPath);
});