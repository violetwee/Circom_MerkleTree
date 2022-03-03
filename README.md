# Circom_MerkleTree

This is a demo project on using circom to take a list of number inputs as leaves of a Merkle Tree and outputs the Merkle root.
The MiMCSponge hash function from circomlib is used for the Merkle Tree.

# Requirements
Ensure that you have circom installed. 
- [Circom](https://docs.circom.io/getting-started/installation/) - Circom installation and docs
- [CircomLib](https://github.com/iden3/circomlib) - Library of circuit templates, including MiMCSponge

# Testing
To test with 8 leaves, check that merkle_circuit.circom is called with MerkleCircuit(8).

From terminal, run
```
./compile.sh -f merkle_circuit -j input_8.json
```
Args:
```
-f : Circom circuit filename, excluding extension. Used to read the .circom file to compile. Also used as filename prefix for other generated files
-j : JSON inputs for generating witness. Ensure that there are 8 inputs if testing with 8 leaves. Inputs should equal to number of leaves.
```
