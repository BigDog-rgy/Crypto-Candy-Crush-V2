async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy CNDY_NFT contract
  const CNDY_NFT = await ethers.getContractFactory("CNDY_NFT");
  const cndyNft = await CNDY_NFT.deploy();

  // Ensure the contract is deployed
  await cndyNft.deployed();

  console.log("CNDY_NFT deployed to:", cndyNft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
