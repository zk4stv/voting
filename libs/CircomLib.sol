pragma solidity ^0.8.0;

library CircomLib {
    function addmod(uint256 a, uint256 b, uint256 p) internal pure returns (uint256) {
        uint256 c = a + b;
        if (c >= p) {
            c -= p;
        }
        return c;
    }

    function mulmod(uint256 a, uint256 b, uint256 p) internal pure returns (uint256) {
        uint256 c = a * b;
        return c % p;
    }

    function scalarMul(uint256[2] memory p, uint256 s, uint256 p_) internal pure returns (uint256[2] memory) {
        return [mulmod(p[0], s, p_), mulmod(p[1], s, p_)];
    }

    function negate(uint256[2] memory p, uint256 p_) internal pure returns (uint256[2] memory) {
        return [p_[0] - p[0], p_[1] - p[1]];
    }

    function addition(uint256[2] memory p1, uint256[2] memory p2, uint256 p_) internal pure returns (uint256[2] memory r) {
        r[0] = addmod(p1[0], p2[0], p_);
        r[1] = addmod(p1[1], p2[1], p_);
    }

    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[24] memory input,
        uint256[2] memory vk_alpha1,
        uint256[2] memory vk_beta2,
        uint256[2] memory vk_gamma2,
        uint256[2] memory vk_delta2,
        uint256[24] memory vk_ic,
        uint256 p
    ) internal pure returns (bool) {
        
        uint256[2] memory acc;
        acc[0] = input[0];
        acc[1] = input[1];

        uint256[2] memory vk_x;

        for (uint256 i = 0; i < input.length; i++) {
            require(input[i] < p, "verifier-gte-snark-scalar-field");
        }

        require(vk_ic.length == input.length, "verifier-wrong-vk-ic-length");

        for (uint256 i = 0; i < vk_ic.length; i++) {
            require(vk_ic[i] < p, "verifier-gte-vk-ic-snark-scalar-field");
        }

        vk_x = vk_ic[0] == 0 ? negate(vk_ic[1] == 0 ? [0, 0] : scalarMul([vk_ic[1], 0], input[0], p), p) : scalarMul([vk_ic[0], 0], input[0], p);

        for (uint256 i = 1; i < input.length; i++) {
            uint256[2] memory tmp;
            tmp = vk_ic[i] == 0 ? negate(vk_ic[i + 1] == 0 ? [0, 0] : scalarMul([vk_ic[i + 1], 0], input[i], p), p) : scalarMul([vk_ic[i], 0], input[i], p);
            vk_x = addition(vk_x, tmp, p);
        }

        acc = addition(acc, vk_x, p);

        uint256[24] memory input_;
        for (uint256 i = 0; i < input.length; i++) {
            input_[i] = input[i];
        }

        uint256[2] memory one = [1, 0];

        if (scalarMul(a, input_[0], p)[0] == 0) {
            return false;
        }

        if (scalarMul(b[0][1], input_[1], p)[0] == 0) {
            return false;
        }

        return true;
    }
}