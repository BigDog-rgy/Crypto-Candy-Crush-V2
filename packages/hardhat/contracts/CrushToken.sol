// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/// @title Crypto Candy Crush CRUSH Contract
/// @author BigDog
/// @dev Collects wETH entry fees, calculates earnings and mints CRUSH rewards from gameplay, keeps record of CRUSH holdings to addresses, allows for burning of CRUSH for CNDY, and handles deprication of CRUSH when idle.

//todo recieveing user scores from frontend gameplay, calculating CRUSH rewards from score, decay mechanism for idle CRUSH

import "./Raffle.sol";
import "./CNDY_NFT.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CrushToken is ERC20, Ownable {

    error TransferNotAllowed(string reason);

    address public cndyContractAddress;
    mapping(address => uint256) private _playerScores;
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    constructor() ERC20("Crush", "CRUSH") {}

    // Override the transfer functions to prevent transfers
    function transfer(address, uint256) public override returns (bool) {
        revert TransferNotAllowed("transfer not allowed");
    }

    function transferFrom(address, address, uint256) public override returns (bool) {
        revert TransferNotAllowed("transfer not allowed");
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        _balances[to] += amount;
        _totalSupply += amount;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
    }

    function burnForCNDY(uint256 amount) public {
        require(msg.sender == cndyContractAddress, "Only CNDY Contract can initiate burn");
        _burn(msg.sender, amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
    }

    /* options: 
        1) trust players to directly give their scores (bad)
        2) off-chain signature verification -> game server calcs score, signs with priv key, then contract verifies signature with pub key
        3) commit-reveal scheme -> players commit hash of score along and a secret, then reveal the acutal score and the secret (how do we know the score is real tho?)
        4) oracle-based reporting -> request score verification upon user-submitted gameplay score
    */
   function setPlayerScore(uint256 score) public {
    _playerScores[msg.sender] = score;
   }

    function getPlayerScore(address player) public view returns (uint256) {
        return _playerScores[player];
    }

    function calculateCRUSHReward(uint256 score, uint256 multiplier) public view returns (uint256 amount) {
        amount = score * multiplier;
        return amount;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function getTotalSupply() public view returns (uint256) {
        return _totalSupply;
    }
}