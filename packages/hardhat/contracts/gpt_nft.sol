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

    event Minted(address indexed minter, uint256 tokenId, uint256 amountBurned);

    constructor(address _simpleToken) ERC721("SimpleNFT", "SNFT") {
        simpleToken = ISimpleToken(_simpleToken);
    }

    function mintNFT() public nonReentrant {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < 4, "All NFTs minted already");

        uint256 tokenBalance = simpleToken.balanceOf(msg.sender);
        require(tokenBalance > 0, "No SimpleToken to burn");

        uint256 tokensToBurn = tokenBalance / 10;
        simpleToken.burnForNFT(msg.sender, tokensToBurn);

        _safeMint(msg.sender, tokenId);
        _tokenIdCounter.increment();

        emit Minted(msg.sender, tokenId, tokensToBurn);
    }

    function getRewardMultiplier(address account) external view returns (uint256) {
        uint256 balance = balanceOf(account);
        return balance > 0 ? 2 : 1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.example.com/metadata/";
    }
}
