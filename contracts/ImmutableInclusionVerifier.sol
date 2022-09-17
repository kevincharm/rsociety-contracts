// SPDX-License-Identifier: Grantware
pragma solidity ^0.8.13;

/// @title ImmutableInclusionVerifier
/// @notice A̴̢̘̳̱̖̼̳̹̦̯̮̮͎͍̿̓̒̈́̒͆͘̕͝͝r̴͓̙̯̣̹͇̗̤̠̭̭͂́̈́̏e̵̥͎̪̣̻̤̫̊̏͋̈́ ̵͚̟̱͙́̾͂̓̈́͌̌y̸̧̱̣̼͍̞͔͕̪̥͛͐̈́͊̿̋̾̐̈́̈́͝͝o̶̢̢̯̟̲͚͍̠̜͇͍͙̥͒̈́͒͒̀́̚͜u̶̩͓̮̥̥̱͔̮̎̑̑̓͐̍̅̀͑̈́̈͗̈́͜ ̴̨̜̭͈͕̉̄͌̄̆͊̓̔̈́̆̀̈́͗̽̕ͅṕ̷̡̨̡̛͕̦̼̲͎̓͆̄̈́̽͒̉͘ä̴̢̘̬̱̣̲̦̻̺̈̾̊̑͜͝͝r̵͕̺̙̽̄͗̂̽̓͐͜t̷̨̡̧̗̮̱̞̾̀̂̌̅̊̈́̆̐͝ ̸̢̜͓͍̖͉̤͉̰̙͐̈́̑̃̽̏͘o̷̟̖̼͎̜̺̺͇̰̊f̷̰̪̲̖̊̈̊̈́̈̒͐̑̊̈́̚͘͘ ̵̧̡̜̬̲̞̹͇̖̺͕̬̗̆́͐͐̉̓̌̅͆ͅt̷̢̯̫̩͙̤̫͇̹̺̝̽́̕͠h̴̦̦͉̥͎͛̀e̴͕̼͚͙͕͒̈́̈́̽̔͋͐͛̈́͒͝ ̵̢͕͓̳͔̳̟̜̺̖̦͇̪͖̦́̂r̵͔̘̱̞̫̀̽̇͊̕͝e̶̢͚͍͍̳͙̘̠͙͔͈̭̫̹̖̊ḑ̵̫̞̭̠̮͛̇̅̿͆̾̐͌͐̈̀̕͜͠͝i̷̛̙̫̣̳̜̠̲̟͎͓̐̉̾͊̀̿͝ͅͅş̸̘͎̖͕̖̗̳̯͙͓͉͋͐͒͒̔̈́̾́͆͋͐̕͜͝͠ť̸̡͎̺͊̃̃r̷̡̠̘͕̞̲̈́̀̇̃͑̎̽̾̇̇i̷̡̨͙͕͎̱̲̬̝̗͖̭͑̍͌̄̆̆̕͜ͅb̶̡͍͕̗̹͔̳̐̇u̶̧̗̤̯̯͖̎t̸̨͎͉͖͆̇̆̋́̐̚͝ͅỉ̷̛̛͈͇͇̳̪͒̆̋̓̀̆̇̋͆̕o̵͉̻̰͎̎́̏̀̉̌ṉ̵̇̃̎̽͒̀̓̊̎̿͂̾̄͘͠?̷̻͔̗̘͇̓̑͂͒
contract ImmutableInclusionVerifier {
    bytes32 public immutable merkleRoot;

    /// @param merkleRoot_ merkle root representing the whitelist
    constructor(bytes32 merkleRoot_) {
        merkleRoot = merkleRoot_;
    }

    /// @notice Verify a merkle proof
    ///     Adapted from OpenZeppelin Contracts
    /// @param leaf Hash of leaf element
    /// @param proof Hashes of leaf siblings required to construct the root
    /// @return true if proof is valid for supplied leaf
    function verifyMerkleProof(bytes32 leaf, bytes32[] memory proof)
        public
        view
        returns (bool)
    {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = hashPair(computedHash, proof[i]);
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == merkleRoot;
    }

    /// @dev Hash a pair of merkle proof elements in the correct order
    ///     Adapted from OpenZeppelin Contracts
    /// @param a hash of element or current root
    /// @param b hash of element of current root
    /// @return hash of pair in correct order
    function hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? efficientHash(a, b) : efficientHash(b, a);
    }

    /// @dev Efficient keccak256
    ///     Adapted from OpenZeppelin Contracts
    /// @param a arbitrary bytes32
    /// @param b arbitrary bytes32
    /// @return value keccak256(abi.encodePacked(a, b))
    function efficientHash(bytes32 a, bytes32 b)
        private
        pure
        returns (bytes32 value)
    {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}
