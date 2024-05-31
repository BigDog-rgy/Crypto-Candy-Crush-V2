// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./CrushToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*
Setting Raffle Duration
    Managing the time intervals at which raffles occur.
Maintaining a Leaderboard
    Keeping track of player scores and possibly other metrics like:
        Frequency of play
        Historical performance
Selecting a Winner
    Implementing the logic to choose a winner based on:
        The leaderboard
        Random selection tempered by player scores
Handling Payouts
    Distributing prizes, which could be in:
        CRUSH
        Other tokens
        Special in-game assets

Contract interactions: 
    Calls CRUSH to mint tokens based on submitted game scores
    Listens
*/

contract Raffle is Ownable{
    CrushToken private _crushContract;

    // leaderboard for top 50 scores per raffle
    mapping(address => uint256) public leaderboard;
    uint256 public raffleEndTime;
    uint256 public raffleDuration = 1 days;

    uint256 public constant rewardTier1 = 100;
    uint256 public constant rewardTier2 = 200;
    uint256 public constant rewardTier3 = 300;

    constructor(address crushContractAddress) {
        _crushContract = CrushToken(crushContractAddress);
        transferOwnership(msg.sender);
    }

    // q should player score go to Raffle or CRUSH
    // q can leaderboard be in order by highest scores
    function enterRaffle() public {
        require(block.timestamp <= raffleEndTime, "Raffle has ended");
        uint256 playerScore = _crushContract.getPlayerScore(msg.sender);
        leaderboard[msg.sender] = playerScore;
    }

    function startNewRaffle() public {
        raffleEndTime = block.timestamp + raffleDuration;
    }

    function determineWinner() private view returns (address) {
        require(block.timestamp > raffleEndTime, "Raffle is still active");
        // logic to select winner based on leaderboard
    }

    function rafflePayout() private view {
        // logic to calculate payout from fee pool to current raffle's winner from determineWinner()
    }
}

/* 
    Gets player score from frontend
    Checks leaderboard of top 50 scores for current raffle, if score is in the leaderboard, use formula to calculate CRUSH reward
    Emit event (if needed) of pending CRUSH rewards (attack vector, can only mint your rewards), CRUSH contract listens for these events mints to appropriate address
    User can enter their entire CRUSH balance into raffle (100% CRUSH slashing for winner, 15% slashing for all entrants), or withhold their CRUSH from the raffle and purchase a CNDY NFT at the price of 25% of their CRUSH holdings.
*/