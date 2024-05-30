import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
// import { Contract } from "ethers";

/**
 * Deploys the Raffle contract using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployRaffle: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deployments } = hre;
  const { deploy, get } = deployments;

  // Get the deployed CrushToken contract
  const crushTokenDeployment = await get("CrushToken");

  // Deploy the Raffle contract
  const raffleDeployment = await deploy("Raffle", {
    from: deployer,
    args: [crushTokenDeployment.address], // Pass CrushToken address as constructor argument
    log: true,
    autoMine: true, // Faster deployment on local networks
  });

  console.log("Raffle deployed to:", raffleDeployment.address);
};

export default deployRaffle;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags Raffle
deployRaffle.tags = ["Raffle"];
