import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys the CrushToken contract using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployCrushToken: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  console.log("Deployer account:", deployer);
  // Deploy the CrushToken contract
  const crushTokenDeployment = await deploy("CrushToken", {
    from: deployer,
    args: [], // No constructor arguments for CrushToken
    log: true,
    autoMine: true,
  });

  //const deployerSigner = await ethers.getSigner(deployer);

  // Get the deployed contract to interact with it after deploying
  //const crushToken = await ethers.getContractAt("CrushToken", crushTokenDeployment.address, deployerSigner);
  console.log("CrushToken deployed to:", crushTokenDeployment.address);
};

export default deployCrushToken;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags CrushToken
deployCrushToken.tags = ["CrushToken"];
