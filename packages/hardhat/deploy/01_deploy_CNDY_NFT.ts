import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
// import { Contract } from "ethers";

/**
 * Deploys the CNDY_NFT contract using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployCNDYNFT: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deployments } = hre;
  const { deploy, get } = deployments;

  // Get the deployed CrushToken contract
  const crushTokenDeployment = await get("CrushToken");

  // Deploy the CNDY_NFT contract
  const cndyNftDeployment = await deploy("CNDY_NFT", {
    from: deployer,
    args: [crushTokenDeployment.address], // Pass CrushToken address as constructor argument
    log: true,
    autoMine: false, // Faster deployment on local networks
  });

  console.log("CNDY_NFT deployed to:", cndyNftDeployment.address);
};

export default deployCNDYNFT;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags CNDY_NFT
deployCNDYNFT.tags = ["CNDY_NFT"];
