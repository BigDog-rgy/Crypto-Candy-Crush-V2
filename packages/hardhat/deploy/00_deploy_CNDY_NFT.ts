import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys the CNDY_NFT contract using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployCNDYNFT: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy the CNDY_NFT contract
  await deploy("CNDY_NFT", {
    from: deployer,
    args: [], // No constructor arguments for CNDY_NFT
    log: true,
    autoMine: true, // Faster deployment on local networks
  });

  // Get the deployed contract to interact with it after deploying
  const cndyNft = await hre.ethers.getContract<Contract>("CNDY_NFT", deployer);
  console.log("CNDY_NFT deployed to:", cndyNft.address);
};

export default deployCNDYNFT;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags CNDY_NFT
deployCNDYNFT.tags = ["CNDY_NFT"];
