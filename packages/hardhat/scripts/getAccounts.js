// Example script to display accounts
const { ethers } = require("hardhat");

async function main() {
  const accounts = await ethers.getSigners();
  console.log("Accounts:", accounts.map(account => account.address));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
