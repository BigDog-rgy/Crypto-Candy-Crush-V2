// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/// @title Crypto Candy Crush NFT Contract
/// @author BigDog
/// @dev This contract leverages OpenZeppelin's ERC721URIStorage to handle the minting and management of unique NFTs for the game Crypto Candy Crush.
/// @notice This contract is under development and managed by an amateur developer.

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "./CrushToken.sol";

contract CNDY_NFT is ERC721URIStorage, ReentrancyGuard, Ownable {
    uint256 public tokenCounter;
    CrushToken public crushToken;

    mapping(uint256 => string) private _tokenCIDs;

    /// @notice Initializes the contract by setting the NFT name and ticker.
    // q why set CrushToken addy here?
    constructor(address _crushTokenAddress) ERC721("CNDY NFT", "CNDY") {
        tokenCounter = 0;
        crushToken = CrushToken(_crushTokenAddress);

        _tokenCIDs[0] = "QmbDUmCgoF6nMZq1tVzTP5trsmg6MUHRaLYY3Gqz9wpw6J"; // VITALIK_CID
        _tokenCIDs[1] = "QmRNMyp2FiHGPT6funHBYYqXdLufARKKXrfqWHxhEiLidS"; // COBIE_CID
        _tokenCIDs[2] = "QmZM4hc6nSYVKNgjfm1jxhZtF4CvcqTcWDXWP17C8DPneP"; // CZ_CID
        _tokenCIDs[3] = "QmcokV9AfW2rxNMuhjd2Agzpr4himUtET4W9FF2QxqYonY"; // MILADY_CID
    }

    /// @notice Mints a new NFT to the msg.sender with a unique token ID after burning CRUSH tokens.
    /// @dev The _safeMint function checks that the recipient address can receive ERC721 tokens.
    /// @dev The _setTokenURI is called to associate metadata with the newly minted token.
    // q is the math here 'safe'?
    function mintCNDY(uint256 tokenId) public nonReentrant {
        require(tokenId < 4, "Invalid token ID");
        uint256 crushBalance = crushToken.balanceOf(msg.sender); // Get the CRUSH balance of msg.sender
        uint256 crushToBurn = crushBalance / 10; // Calculate 10% of the CRUSH holdings

        crushToken.burnForCNDY(crushToBurn); // Call the burn function in CRUSH contract

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, generateTokenURI(tokenId));
        tokenCounter++;
    }

// missing functions set and getCNDYMultiplier

    function generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        // This function should return a valid URI pointing to the metadata of the NFT
        return string(abi.encodePacked("ipfs://", _tokenCIDs[tokenId]));
    }

    function setBaseURI(uint256 tokenId, string memory cid) public onlyOwner {
        _tokenCIDs[tokenId] = cid;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) { 
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}