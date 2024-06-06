// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface ISimpleToken {
    function burnForNFT(address account, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}

contract SimpleNFT is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    ISimpleToken public simpleToken; 
    string[] private _tokenURIs;

    struct NFTAttributes {
        uint256 multiplier;
        string rarity;
    }

    mapping(uint256 => NFTAttributes) private _nftAttributes;
    mapping(uint256 => string) private _tokenURIsMapping;

    event Minted(address indexed minter, uint256 tokenId, uint256 amountBurned);

    constructor(address _simpleToken, string[] memory tokenURIs) ERC721("SimpleNFT", "SNFT") {
        simpleToken = ISimpleToken(_simpleToken);
        _tokenURIs = tokenURIs;
    }

    function mintNFT() public nonReentrant {
        uint256 tokenId = _tokenIdCounter.current();
        //q if you want a contrained supply of nfts, how do you properly define this?
        //require(tokenId < _tokenURIs.length, "All NFTs minted already");

        uint256 tokenBalance = simpleToken.balanceOf(msg.sender);
        require(tokenBalance > 0, "No SimpleToken to burn");

        uint256 tokensToBurn = tokenBalance / 10;
        simpleToken.burnForNFT(msg.sender, tokensToBurn);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURIs[tokenId]);

        _tokenIdCounter.increment();

        // Retrieve and store attributes from JSON
        NFTAttributes memory attributes = _getAttributesFromURI(_tokenURIs[tokenId]);
        _nftAttributes[tokenId] = attributes;

        emit Minted(msg.sender, tokenId, tokensToBurn);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        if (bytes(_tokenURI).length > 7 && keccak256(abi.encodePacked(substring(_tokenURI, 0, 7))) == keccak256(abi.encodePacked("ipfs://"))) {
            _tokenURI = substring(_tokenURI, 7, bytes(_tokenURI).length);
        }
        _tokenURIsMapping[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIsMapping[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function _getAttributesFromURI(string memory _tokenURI) internal pure returns (NFTAttributes memory) {
        //function to parse JSON from the IFPS URI and extract the attributes
        if (keccak256(abi.encodePacked(_tokenURI)) == keccak256(abi.encodePacked("ipfs://QmYs1boGizK6BnSj2AVALZiyDCy1RP8YJrdhPDYjRGWkDN"))) {
            return NFTAttributes(2, "Rare");
        } else {
            return NFTAttributes(1, "Common");
        }
    }

    function getRewardMultiplier(uint256 tokenId) external view returns (uint256) {
        return _nftAttributes[tokenId].multiplier;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}
