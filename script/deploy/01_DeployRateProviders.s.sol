// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.21;

import { IRateProvider } from "./../../../src/interfaces/IRateProvider.sol";
import { EthPerWstEthRateProvider } from "./../../../src/oracles/EthPerWstEthRateProvider.sol";

import { BaseScript } from "./../Base.s.sol";
import { stdJson as StdJson } from "@forge-std/StdJson.sol";
import { ConfigReader } from "../ConfigReader.s.sol";
import { console } from "@forge-std/Test.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { EthPerTokenRateProvider, IPriceFeed } from "src/oracles/EthPerTokenRateProvider.sol";

/// NOTE This script must change based on the supported assets of each vault deployment.
contract DeployRateProviders is BaseScript {
    using StdJson for string;
    using Strings for address;

    function run(string memory fileName, string memory configFileName) public {
        string memory path = string.concat(CONFIG_PATH_ROOT, configFileName);
        string memory config = vm.readFile(path);
        _run(fileName, config);
    }

    function run() public {
        string memory config = requestConfigFileFromUser();
        _run(Strings.toString(block.chainid), config);
    }

    function _run(string memory fileName, string memory config) internal {
        string memory chainConfig = getChainConfigFile();

        address[] memory assets = config.readAddressArray(".teller.assets");
        uint256 maxTimeFromLastUpdate = config.readUint(".rateProvider.maxTimeFromLastUpdate");

        for (uint256 i; i < assets.length; ++i) {
            require(assets[i].code.length > 0, "asset must have code");
            string memory rateProviderKey =
                string(abi.encodePacked(".assetToRateProviderAndPriceFeed.", assets[i].toHexString(), ".rateProvider"));
            address rateProvider = chainConfig.readAddress(rateProviderKey);
            // must deploy new rate provider and set the value
            if (rateProvider == address(0)) {
                address priceFeed = chainConfig.readAddress(
                    string(abi.encodePacked(".assetToRateProviderAndPriceFeed.", assets[i].toHexString(), ".priceFeed"))
                );
                uint8 decimals = uint8(
                    chainConfig.readUint(
                        string(
                            abi.encodePacked(".assetToRateProviderAndPriceFeed.", assets[i].toHexString(), ".decimals")
                        )
                    )
                );
                string memory description = chainConfig.readString(
                    string(
                        abi.encodePacked(".assetToRateProviderAndPriceFeed.", assets[i].toHexString(), ".description")
                    )
                );
                uint256 priceFeedType = chainConfig.readUint(
                    string(
                        abi.encodePacked(".assetToRateProviderAndPriceFeed.", assets[i].toHexString(), ".priceFeedType")
                    )
                );
                rateProvider =
                    deployRateProvider(description, priceFeed, maxTimeFromLastUpdate, decimals, priceFeedType);
                string memory chainConfigFilePath = string.concat(CONFIG_CHAIN_ROOT, fileName, ".json");
                rateProvider.toHexString().write(chainConfigFilePath, rateProviderKey);
            }
        }
    }

    function deploy(ConfigReader.Config memory config) public override broadcast returns (address) { }

    function deployRateProvider(
        string memory description,
        address priceFeed,
        uint256 maxTimeFromLastUpdate,
        uint8 decimals,
        uint256 priceFeedType
    )
        public
        broadcast
        returns (address)
    {
        require(maxTimeFromLastUpdate > 0, "max time from last update = 0");
        require(priceFeed.code.length > 0, "price feed must have code");

        EthPerTokenRateProvider rateProvider = new EthPerTokenRateProvider(
            description,
            IPriceFeed(priceFeed),
            maxTimeFromLastUpdate,
            decimals,
            EthPerTokenRateProvider.PriceFeedType(priceFeedType)
        );

        return address(rateProvider);
    }
}
