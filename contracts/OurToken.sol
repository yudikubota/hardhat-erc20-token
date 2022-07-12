// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MemoToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MemoToken", "MMT") {
        _mint(msg.sender, initialSupply);
    }
}
