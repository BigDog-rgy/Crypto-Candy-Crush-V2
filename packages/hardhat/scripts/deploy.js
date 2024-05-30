require('dotenv').config();
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy CrushToken
  const CrushToken = await ethers.getContractFactory("CrushToken");
  const crushToken = await CrushToken.deploy();
  await crushToken.deployed(); // Corrected line
  console.log("CrushToken deployed to:", crushToken.address);

  // Deploy CNDY_NFT with the address of CrushToken
  const CNDY_NFT = await ethers.getContractFactory("CNDY_NFT");
  const cndyNFT = await CNDY_NFT.deploy(crushToken.address, baseCID);
  await cndyNFT.deployed(); // Corrected line
  console.log("CNDY_NFT deployed to:", cndyNFT.address);

  const Raffle = await ethers.getContractFactory("Raffle");
  const raffle = await Raffle.deploy(crushToken.address);
  await raffle.deployed();
  console.log("Raffle deployed to:", raffle.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});