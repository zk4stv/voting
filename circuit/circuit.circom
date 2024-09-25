pragma circom 2.0.0;

template IsZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== -in*inv + 1;
}

template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();

    isz.in <== in[0] - in[1];

    out <== isz.out;
}

template VoterCheck() {
    signal input vote;
    signal input nullifier;
    signal output out;

    component isEqual = IsEqual();

    isEqual.in[0] <== vote;
    isEqual.in[1] <== 0;

    out <== isEqual.out;
}

component main = VoterCheck();