import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

/**
 * Deploys the SimpleToken and SimpleNFT contracts using the deployer account.
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployContracts: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  // Deploy SimpleToken first
  const simpleTokenDeployment = await deploy("SimpleToken", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const simpleTokenAddress = simpleTokenDeployment.address;

  const tokenURIs = ["ipfs://QmYs1boGizK6BnSj2AVALZiyDCy1RP8YJrdhPDYjRGWkDN"];

  // Deploy SimpleNFT with the SimpleToken address as an argument
  const simpleNFTDeployment = await deploy("SimpleNFT", {
    from: deployer,
    args: [simpleTokenAddress, tokenURIs],
    log: true,
    autoMine: true,
  });

  const simpleNFTAddress = simpleNFTDeployment.address;

  log(`SimpleToken deployed to: ${simpleTokenAddress}`);
  log(`SimpleNFT deployed to: ${simpleNFTAddress}`);
};

export default deployContracts;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. npx hardhat deploy --tags SimpleToken,SimpleNFT
deployContracts.tags = ["SimpleToken", "SimpleNFT"];
