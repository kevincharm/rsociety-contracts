// SPDX-License-Identifier: Grantware
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockDai is ERC20 {
    constructor() ERC20("Mock Dai", "MDAI") {}

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
