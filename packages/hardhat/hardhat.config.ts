import { HardhatUserConfig } from "hardhat/config";
import "hardhat-deploy";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import * as dotenv from "dotenv";

dotenv.config();

const alchemyApiKey = process.env.ALCHEMY_API_KEY || "";
const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY || "";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  namedAccounts: {
    deployer: {
      default: 0, // Use the first account as the deployer
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
      forking: {
        url: `https://eth-mainnet.g.alchemy.com/v2/${alchemyApiKey}`,
        enabled: true,
      },
      accounts: [{ privateKey: deployerPrivateKey, balance: "1000000000000000000000" }] as any,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: [deployerPrivateKey],
    },
    // You can add more networks like mainnet, ropsten, etc.
  },
};

export default config;
