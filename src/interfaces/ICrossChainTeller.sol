// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {ERC20} from "@solmate/tokens/ERC20.sol";

error CrossChainLayerZeroTellerWithMultiAssetSupport_InvalidChain();
error CrossChainLayerZeroTellerWithMultiAssetSupport_InvalidSource();
error CrossChainLayerZeroTellerWithMultiAssetSupport_InvalidDestination();
error CrossChainLayerZeroTellerWithMultiAssetSupport_ZeroMessageGasLimit();

struct BridgeData{
    uint256 chainId;
    address destinationChainReceiver;
    ERC20 bridgeFeeToken;
    uint256 maxBridgeFee;
    bytes data;
}

struct Chain{
    address targetTeller;
    bool allowMessagesFrom;
    bool allowMessagesTo;
    uint256 gasLimit;
}

interface ICrosschainTeller {

    event MessageSent(bytes32 messageId, uint256 shareAmount, address to);
    event MessageReceived(bytes32 messageId, uint256 shareAmount, address to);



    /**
     * @dev function to deposit into the vault AND bridge cosschain in 1 call
     * @param depositAsset ERC20 to deposit
     * @param depositAmount amount of deposit asset to deposit
     * @param minimumMint minimum required shares to receive
     * @param data Bridge Data
     */
    function depositAndBridge(ERC20 depositAsset, uint256 depositAmount, uint256 minimumMint, BridgeData calldata data) external;

    /**
     * @dev only code for bridging for users who already deposited
     * @param shareAmount to bridge
     * @param data bridge data
     */
    function bridge(uint256 shareAmount, BridgeData calldata data) external;

    /**
     * @dev adds an acceptable chain to bridge to
     * @param chainId of chain
     * @param allowMessagesFrom allow messages from this chain
     * @param allowMessagesTo allow messages to the chain
     * @param target address of the target teller on this chain
     * @param gasLimit to pass to bridge
     */
    function addChain(uint chainId, bool allowMessagesFrom, bool allowMessagesTo, address target, uint gasLimit) external;

    /**
     * @dev block messages from a particular chain
     * @param chainId of chain
     */
    function stopMessagesFromChain(uint chainId) external;

    /**
     * @dev allow messages from a particular chain
     * @param chainId of chain
     */
    function allowMessagesFromChain(uint chainId) external;

    /**
     * @dev set the target teller to receive messages
     * @param target address
     */
    function setTargetTeller(uint256 chainId, address target) external;
}