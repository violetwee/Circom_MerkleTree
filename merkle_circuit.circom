pragma circom 2.0.0;
include "mimcsponge.circom";

/*
  Takes in the left and right leaf values, and outputs the hash of the values.
  out = hash(left + right)
*/
template Node(){
  signal input left;
  signal input right;
  signal output out;

  component mimc = MiMCSponge(2, 220, 1);
  mimc.ins[0] <== left;
  mimc.ins[1] <== right;
  mimc.k <== 0;
  out <== mimc.outs[0];
} 

/*
  Takes in the number of leaves and outputs the merkle root
*/
template MerkleCircuit(n) {
  signal input leaves[n]; // number of leaves
  signal output root; // merkle root

  // Construct Merkle Tree
  var nNodes = n - 1; // total number of nodes (excluding the leaves)
  // create a Node for each leaf pair
  // For leaves=4, we should have (4-1) Nodes.
  // For leaves=8, we should have (8-1) Nodes.
  component node[nNodes]; 
  for (var i = 0; i < nNodes; i++) {
    node[i] = Node(); 
  }

  var index = 0; // track the index of the Node
  var offset = 0; // track which sets of hashes in Node to hash next, in order to derive the next parent hash
  
  // hash all leaves
  // Node now contains the parent nodes of all leaf pairs
  for(var i = 0; i < n - 1; i += 2) {
        node[index].left <== leaves[i];
        node[index].right <== leaves[i + 1];
        index += 1;
  }
  var nNodesForHeight = index; 

  // loop through hashes to get root
  while (nNodesForHeight > 0) { // tree is not full yet
    for(var i = 0; i < nNodesForHeight - 1; i += 2) {
      // take the hashes of the leaf pairs and create a new Node (as next level of parents)
      node[index].left <== node[i + offset].out;
      node[index].right <== node[i + 1 + offset].out;
      index += 1;
    }
    offset += nNodesForHeight; // offset the Nodes that have been processed
    nNodesForHeight = nNodesForHeight / 2; // set number of nodes for next height ie. 4 -> 2 -> 1
  }

  root <== node[index - 1].out; // the last hash is the root
}

component main {public [leaves]} = MerkleCircuit(8);