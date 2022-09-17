// SPDX-License-Identifier: Grantware
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ImmutableInclusionVerifier} from "./ImmutableInclusionVerifier.sol";

/// @title RedistributionChef
/// @notice J̴̢̨̢̩̫̞̳̻̰͓͖͇̤̝̝͓͉̣͓͎̜͔͓͓͔̣̟̱̮͎̖̣̼̠̝̩͚͕̼͓͍̫̜̳̗̀̉̊̏̊̆̃͌̔̍͐̑̂̕̕͝͝͝͝ͅǫ̸̧̡̛̛͚̙̜̰̣̻̥̬̱̝̝̍̄̈́̀̿͆͋̉̐̾̈́̀̀̂̑͒͊̒̄̏͊̅͛̒̂̂͊̀̀̽͂̍͘̚͝i̶̧̨̧̡̛̱̪̭̰̫͙̖̮͙̜̺̮̠͉̫̟̩̲͇̳͙̦̰̣̼̖͇̠̔̆̓̅̒̏̿̌͛̅̽̅̽̔́͗̄͑͌́͑̈́̉͆́̉͑́́̓̂̃͊̒͗̚̚͘͜͜͠͠͝ͅͅͅn̷͇̖̺̩̲̙̮̪͎̥͓͐͜ͅ ̶̡̢̡̛̛͚̪̩̦̩̣̖͙̙͚͚̠͇̪̙̱͚͚͓̟͙̣̫͈̣̺̝̩̺͍̦̭͆͂̃̈́̈́̄̈̀̀̂̄̇̃͐͂̍͊͗̍́͊̄͊͑̌̔͘͝t̸̡͙̱̬̳̘̻̠͉̠͈̪̲͙̠̉̎͊̌̄̊͒͆͋͊́͐̑̓̀̚͘̚͠͝ͅh̵̡̢̨̨̢̛̛̟̼͈̘̦̖̳̱̭͇̱̱̺̠̗͎̬͚͙̠̰̝͚̱͎͇͐̏̒͌̀̾̊̿́̎͒̍̈́͆͐͌̋͌͑̋͆̄͂̐͋̇̄̑͌̎̑͌̇͘̚͝͝e̷͇̤̼̪̥͓̦̔̋̆͗̀̓̉̾͊̂̉̄̏͌́͛ͅ ̷̓̄̒̈̏͂̉̉̊̋̽̑̆̈̑͒̈́́̎͐͐͗͂̓̎̒͝͠ͅr̸͍̤͍̐̅̾͋͛̿͗͒̃̊͒̃̃͆͋̍̓̀̄̽͌̇͂́́͗̂̈́̿̊͒̌̕̚͝͠ȩ̵̢̛̣̠͎͚͖̥͇̟͖̭̣̭̳̽̃̈́̿̈̌͐̂̀̄̓͑̄̍̽̃̓͆̀̎̐̓̂̿̆͒́́̑̿̀͜͝͠͝d̶̡̧͔̦̳̣̜̺̙̅̅̾́̒͗̆͊̃̎̔̀͒̐̂̀̈̂̿̆͘̚į̶̢̢̥̜̘̬̳͖̯̤͇̪̰̺̻͙̖̲̣̭͚̟͚̟͖̯͉͔̳͖͚͉̳̤̮̦̖̩͓͓͚̭͛̈́̽̋̏̄̃͆͜ş̷̢̛͇̲̱͓͚̻͓̞̺̞̬͇̰͖͈̥̠̳̘͔͙̞̫̠̩̬̞̙͔͉̘͍͔̜̗͕͓͓̫̎̈́̐̎̍̑̓̓̆̍͐͆̊̕̕͜͝͠t̷̢̡̨̛̛̛͎͓̮̲̭̜̣̠̩̼͍̘̮̟͙̣̗̱͇̜̙̥͇̹̻̱̤̫̮͖̤̬̼̘̑̊̃̿̂͒̆̅͐͛̎̑̓̄̾͜͝ṟ̸̨̧̡̨̛̛̫̬̯̰͖̼̘̼̯͉͓̖͎̜͔̮̘͈͉̮͕̲͈̘͙̘̥͙̤̖͔͓͖͚͈͉̳̮̩̫̏̾͐͑̓͂̀̋́̀̍͋͊̽͑͒̔͋̆͊͐̿̅̿͌̋̚̚͝ͅi̴̢̡̢̭̗̣͓͔̥͖̠̗̳̠͖̳͕̳̰̠͇̻͖͇͙̗̣̺̲̙͎̘̭̮̹̳̺̊̐͗͆̀̄̇̊̓̽̾̾͐̽̈̑̎̒̅͗̑̅͑́̒̈̅̓̈͛͛̐̽͋̃͆͋̚̚̚̕̚͝ͅb̸̡̧̦͖̥̯͕̼̦̰̳̯͇̫̪̤̣̳̣̝̹͔̎͜ų̵̧̢̢͇͖̣̖̣̬̼̲͇̟̟̫̫͚̮̘̥̘̠̙̙͈͉̣͍̖͎̜̦̾͆̾͋̆̃̀̈̍̉̓̾̕͘͜͝ͅt̶̨̡̡̡̨̨̨̩͍̹̥͕̫̫͙̲͖͖̼̦̙̮̱̩͕͎̣͕̘̰̘͖̥̹̼̮̮͙̦͍̙͇̼̄͌̊̾́̚͜͝ͅi̵̢̲͈̫͓̬̮̺̯̰̥̹̜̙̞͇͕̠̦͇̣̲͕̯͚̖̝̍͒̈́̊͂̐͛̏̾̿̊͗̏̕̚͜͜ŏ̵̡̡̨̡̝̦͚̦͕͓̼̯͔͓͔̳̬̝͇͕͇̬̘̰̖̝͕̙̣̳̱̭͔̞̻͎̐̍̿̽̔͒̾̽͌̑̆̑̐͐͊̓͛̾́̆̇̔͊̈́̓̒͌̌͗̈̾͊̐̎̈́͘͝͝͝ͅͅͅņ̴̨̻̺̘͔̰̗̙̜̱̘̳̺̙͔̞̬̰̩̭͎͇͐͒̒̄̊́̾̊̄͋̈́̀̆̑̓͗̍̒͗̒̓̂̏̂̀̽̀̃͛̕͘͜͝͝͠͝!̷̢̢̢̨̢̨̛̝̦̲̳͚̯̤͕̩̞̞̻̥̙̖̟̦͈̠̜̰̱̲͕̖̬͓͕̬̦̙̞̠̻̺͖͎̅̀͗͊̂̔͐͑̉́͊̒̽͌̔̇̀͊̈̐̔͜͝
contract RedistributionChef is ImmutableInclusionVerifier, Ownable {
    using SafeERC20 for ERC20;

    /// @notice Total number of participants
    uint256 public immutable totalParticipants;
    /// @notice DAI contract
    ERC20 public immutable dai;
    /// @notice Mapping of whether an address has claimed their redistribution share or not
    mapping(address => bool) public hasClaimed;
    /// @notice List of addresses that have claimed
    address[] public claimooors;
    /// @notice The timestamp after which it will be possible for claimoooooors to claim
    ///     the remaining unclaimed Dai in the contract
    uint256 public immutable claimExpiryTimestamp;

    constructor(
        address daiAddress,
        uint256 totalParticipants_,
        uint256 claimExpiryTimestamp_,
        bytes32 merkleRoot
    ) Ownable() ImmutableInclusionVerifier(merkleRoot) {
        dai = ERC20(daiAddress);
        totalParticipants = totalParticipants_;
        claimExpiryTimestamp = claimExpiryTimestamp_;
    }

    /// @notice Claim your redistribution share. Only call this function after the DAI winnings
    ///     have been deposited to this contract. You can only call this function once per address.
    /// @param proof Proof of inclusion of caller in the merkle tree
    function claim(bytes32[] calldata proof) external {
        require(
            !hasClaimed[msg.sender],
            "There is no greater guilt than discontentment"
        );
        require(
            verifyMerkleProof(keccak256(abi.encodePacked(msg.sender)), proof),
            "Not part of the redistribution"
        );

        uint256 daiBalance = dai.balanceOf(address(this));
        // Weak safeguard: prevent people from claiming if the contract's Dai balance is empty
        require(daiBalance > 0, "One minute of patience, ten years of peace");

        // Calculate claim amount first, before updating internal accounting
        uint256 participantsLeft = totalParticipants - claimooors.length;
        require(participantsLeft > 0);
        uint256 claimAmount = dai.balanceOf(address(this)) / participantsLeft;

        // Internal effects
        hasClaimed[msg.sender] = true;
        claimooors.push(msg.sender);

        // External interaction: transfer calculated Dai claim to caller
        dai.safeTransfer(msg.sender, claimAmount);
    }

    /// @notice Redistribute remaining Dai in the contract, available after some
    ///     specified block timestamp `claimExpiryTimestamp`.
    function redistributeRemainder() external {
        require(
            block.timestamp > claimExpiryTimestamp,
            "Claims have not expired"
        );
        uint256 nClaimooors = claimooors.length;
        require(nClaimooors > 0, "No claims have been made");
        uint256 perAccountClaimAmount = dai.balanceOf(address(this)) /
            nClaimooors;
        for (uint256 i = 0; i < nClaimooors; ++i) {
            dai.safeTransfer(claimooors[i], perAccountClaimAmount);
        }
    }

    /// @notice Get number of claimoooors
    function getNumClaimooors() external view returns (uint256) {
        return claimooors.length;
    }

    /// @notice Withdraw balance of token from contract
    /// @param tokenAddress Address of ERC-20 to rescue
    function rescueTokens(address tokenAddress) external onlyOwner {
        bool claimExpiredAndNobodyClaimedWinnings = tokenAddress ==
            address(dai) &&
            block.timestamp > claimExpiryTimestamp &&
            claimooors.length == 0;
        require(
            tokenAddress != address(dai) || claimExpiredAndNobodyClaimedWinnings
        );
        ERC20 token = ERC20(tokenAddress);
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }

    /// @notice Rescue ETH force-sent to contract
    function rescueETH() external onlyOwner {
        (bool sent, bytes memory data) = msg.sender.call{
            value: address(this).balance
        }("");
        require(sent);
    }
}
