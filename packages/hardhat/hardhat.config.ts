import { HardhatUserConfig } from "hardhat/config";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-deploy";
import * as dotenv from "dotenv";

dotenv.config();

const deployerPrivateKey = process.env.DEPLOYER_PRIVATE_KEY!;
const alchemyApiKey = process.env.ALCHEMY_API_KEY!;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  defaultNetwork: "hardhat",
  namedAccounts: {
    deployer: {
      default: 0, // Use the first account as deployer
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
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
};

export default config;
