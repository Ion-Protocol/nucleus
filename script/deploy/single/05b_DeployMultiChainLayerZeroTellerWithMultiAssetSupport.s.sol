// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import { AccountantWithRateProviders } from "./../../../src/base/Roles/AccountantWithRateProviders.sol";
import { MultiChainLayerZeroTellerWithMultiAssetSupport } from
    "./../../../src/base/Roles/CrossChain/MultiChainLayerZeroTellerWithMultiAssetSupport.sol";
import { BaseScript } from "./../../Base.s.sol";
import { stdJson as StdJson } from "@forge-std/StdJson.sol";
import { ConfigReader } from "../../ConfigReader.s.sol";

contract DeployMultiChainLayerZeroTellerWithMultiAssetSupport is BaseScript {
    using StdJson for string;

    function run() public returns (address teller) {
        return deploy(getConfig());
    }

    function deploy(ConfigReader.Config memory config) public override broadcast returns (address) {
        // Get Config Values

        // Require config Values
        require(config.boringVault.code.length != 0, "boringVault must have code");
        require(config.accountant.code.length != 0, "accountant must have code");
        require(config.tellerSalt != bytes32(0), "tellerSalt");
        require(config.boringVault != address(0), "boringVault");
        require(config.accountant != address(0), "accountant");

        // Create Contract
        bytes memory creationCode = type(MultiChainLayerZeroTellerWithMultiAssetSupport).creationCode;
        MultiChainLayerZeroTellerWithMultiAssetSupport teller = MultiChainLayerZeroTellerWithMultiAssetSupport(
            CREATEX.deployCreate3(
                config.tellerSalt,
                abi.encodePacked(
                    creationCode, abi.encode(broadcaster, config.boringVault, config.accountant, config.lzEndpoint)
                )
            )
        );

        // configure the crosschain functionality, assume same address
        teller.setPeer(config.peerEid, bytes32(bytes20(address(teller))));
        teller.addChain(config.peerEid, true, true, address(teller), config.maxGasForPeer, config.minGasForPeer);

        // Post Deploy Checks
        require(teller.shareLockPeriod() == 0, "share lock period must be zero");
        require(teller.isPaused() == false, "the teller must not be paused");
        require(
            AccountantWithRateProviders(teller.accountant()).vault() == teller.vault(),
            "the accountant vault must be the teller vault"
        );
        require(address(teller.endpoint()) == config.lzEndpoint, "OP Teller must have messenger set");

        return address(teller);
    }
}
