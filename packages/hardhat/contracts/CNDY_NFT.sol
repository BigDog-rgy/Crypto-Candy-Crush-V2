// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/// @title Crypto Candy Crush NFT Contract
/// @author BigDog
/// @dev This contract leverages OpenZeppelin's ERC721URIStorage to handle the minting and management of unique NFTs for the game Crypto Candy Crush.
/// @notice This contract is under development and managed by an amateur developer.

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CNDY_NFT is ERC721URIStorage, ReentrancyGuard {
    using Strings for uint256;

    /// @dev Counter to track the number of NFTs minted and to ensure each NFT has a unique ID.
    uint256 private _currentTokenId = 1;

    /// @notice Initializes the contract by setting the NFT name and ticker.
    constructor() ERC721("CryptoCandy", "CNDY") {}

    /// @notice Mints a new NFT to the msg.sender with a unique token ID.
    /// @dev The _safeMint function checks that the recipient address can receive ERC721 tokens.
    /// @dev The _setTokenURI is called to associate metadata with the newly minted token.
    function mintCNDY() public nonReentrant {
        _safeMint(msg.sender, _currentTokenId);
        _setTokenURI(_currentTokenId, generateTokenURI(_currentTokenId));
        _currentTokenId++;
    }

    /// @notice Generates a token URI for the given token ID.
    /// @param tokenId The ID of the token to generate the URI for.
    /// @return The generated token URI.
    function generateTokenURI(uint256 tokenId) private view returns (string memory) {
        // This function should return a valid URI pointing to the metadata of the NFT
        return string(abi.encodePacked("https://api.mysite.com/metadata/", Strings.toString(tokenId)));
    }
}