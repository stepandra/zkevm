/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
const { PRIVATE_KEY, INFURA_API_KEY, ETHERSCAN_API_KEY } = process.env;



module.exports = {
  solidity: "^0.8.18",
  networks: {
    // other networks
    truffledashboard: {
      url: "http://localhost:24012/rpc"
    }, consensyszkevmgoerli: {
      url: `https://consensys-zkevm-goerli-prealpha.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      consensyszkevmgoerli: ETHERSCAN_API_KEY
    },
    customChains: [
      {
        network: "consensyszkevmgoerli",
        chainId: 59140,
        urls: {
          apiURL: "https://explorer.goerli.zkevm.consensys.net/api",
          browserURL: "https://explorer.goerli.zkevm.consensys.net/"
        }
      }
    ]
  }
  };

