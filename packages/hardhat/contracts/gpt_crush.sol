// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ISimpleNFT {
    function getRewardMultiplier(address account) external view returns (uint256);
}

contract SimpleToken is ERC20, Ownable {
    ISimpleNFT public simpleNFT;

    // Store user scores
    mapping(address => uint256) public userScores;

    constructor() ERC20("SimpleToken", "STK") {}

    function setNFTContract(address _simpleNFT) external onlyOwner {
        simpleNFT = ISimpleNFT(_simpleNFT);
    }

    // Function to submit game score
    function submitScore(uint256 score) external {
        userScores[msg.sender] = score;
    }

    // Function to mint tokens based on score and NFT multiplier
    function mintToken() external {
        uint256 score = userScores[msg.sender];
        require(score > 0, "No score submitted.");

        //uint256 multiplier = simpleNFT.getRewardMultiplier(msg.sender);
        uint256 amount = score;

        _mint(msg.sender, amount);

        // Reset the user's score after minting
        userScores[msg.sender] = 0;
    }

    //q should this be external, if only the nft contract can mint (maybe private?)
    //q what if user accidentally calls this function without calling mintnft(), burning their tokens for nothing?
    function burnForNFT(address account, uint256 amount) external {
        _burn(account, amount);
    }
}
