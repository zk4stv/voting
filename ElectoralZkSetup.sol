pragma solidity ^0.8.0;

import "@openzeppelin/contracts/cryptography/ECDSA.sol";
import "./libs/CircomLib.sol";

contract ElectoralZkSetup {
    uint256 public vk_modulus;
    uint256[2] public vk_alpha1;
    uint256[2] public vk_beta2;
    uint256[2] public vk_gamma2;
    uint256[2] public vk_delta2;
    uint256[24] public vk_ic;

    constructor() {
        vk_modulus = 21888242871839275222246405745244811018421122129319129327682828284966440042739;
        vk_alpha1 = [1, 0];
        vk_beta2 = [1, 0];
        vk_gamma2 = [1, 0];
        vk_delta2 = [1, 0];
        vk_ic = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; 
    }

    function verifyProof(uint256[2] memory a, uint256[2][2] memory b, uint256[2] memory c, uint256[24] memory input) public view returns (bool) {
        return CircomLib.verifyProof(a, b, c, input, vk_alpha1, vk_beta2, vk_gamma2, vk_delta2, vk_ic, vk_modulus);
    }
}