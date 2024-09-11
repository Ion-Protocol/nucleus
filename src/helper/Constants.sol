// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { IPriceFeed } from "../interfaces/IPriceFeed.sol";

IPriceFeed constant ETH_PER_WEETH_CHAINLINK = IPriceFeed(0x5c9C449BbC9a6075A2c061dF312a35fd1E05fF22);
IPriceFeed constant ETH_PER_EZETH_CHAINLINK = IPriceFeed(0x636A000262F6aA9e1F094ABF0aD8f645C44f641C);
IPriceFeed constant ETH_PER_RSETH_CHAINLINK = IPriceFeed(0x03c68933f7a3F76875C0bc670a58e69294cDFD01);
IPriceFeed constant ETH_PER_RSWETH_CHAINLINK = IPriceFeed(0xb613CfebD0b6e95abDDe02677d6bC42394FdB857);
IPriceFeed constant ETH_PER_PUFETH_REDSTONE = IPriceFeed(0x76A495b0bFfb53ef3F0E94ef0763e03cE410835C);
IPriceFeed constant ETH_PER_APXETH_REDSTONE = IPriceFeed(0x19219BC90F48DeE4d5cF202E09c438FAacFd8Bea);

address constant SWBTC = 0x8DB2350D78aBc13f5673A411D4700BCF87864dDE;
address constant WBTC_ETHEREUM = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

// Setup initial roles configurations
// --- Users ---
// 1. VAULT_STRATEGIST (BOT EOA)
// 2. MANAGER (CONTRACT)
// 3. TELLER (CONTRACT)
// --- Roles ---
// 1. STRATEGIST_ROLE
//     - manager.manageVaultWithMerkleVerification
//     - assigned to VAULT_STRATEGIST
// 2. MANAGER_ROLE
//     - boringVault.manage()
//     - assigned to MANAGER
// 3. TELLER_ROLE
//     - boringVault.enter()
//     - boringVault.exit()
//     - assigned to TELLER
// --- Public ---
// 1. teller.deposit

uint8 constant STRATEGIST_ROLE = 1;
uint8 constant MANAGER_ROLE = 2;
uint8 constant TELLER_ROLE = 3;
uint8 constant UPDATE_EXCHANGE_RATE_ROLE = 4;
uint8 constant SOLVER_ROLE = 5;
