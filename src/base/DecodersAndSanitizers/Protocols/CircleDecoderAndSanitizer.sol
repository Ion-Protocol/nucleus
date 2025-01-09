// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import { BaseDecoderAndSanitizer } from "src/base/DecodersAndSanitizers/BaseDecoderAndSanitizer.sol";

abstract contract TempestDecoderAndSanitizer is BaseDecoderAndSanitizer {
    function depositForBurn(
        uint256 amount,
        uint32 destinationDomain,
        bytes32 mintRecipient,
        address burnToken
    )
        external
        view
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(destinationDomain, mintRecipient, burnToken);
    }

    function receiveMessage(bytes message, bytes attestation) external view returns (bytes memory addressesFound) {
        // nothing to sanitize
    }
}
