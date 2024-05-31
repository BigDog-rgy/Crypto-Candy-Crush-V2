import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys the CrushToken contract using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployCrushToken: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deployments } = hre;
  const { deploy } = deployments;

  // Deploy the CrushToken contract
  const crushTokenDeployment = await deploy("CrushToken", {
    from: deployer,
    args: [], // No constructor arguments for CrushToken
    log: true,
    autoMine: false, // Faster deployment on local networks
  });

  //const deployerSigner = await ethers.getSigner(deployer);

  // Get the deployed contract to interact with it after deploying
  //const crushToken = await ethers.getContractAt("CrushToken", crushTokenDeployment.address, deployerSigner);
  console.log("CrushToken deployed to:", crushTokenDeployment.address);

  // Interact with the deployed contract
  const crushToken = await ethers.getContractAt("CrushToken", crushTokenDeployment.address);
  const tx = await crushToken.setPlayerScore(deployer, 100);
  await tx.wait();
  console.log("Player score set successfully");
};

export default deployCrushToken;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags CrushToken
deployCrushToken.tags = ["CrushToken"];
