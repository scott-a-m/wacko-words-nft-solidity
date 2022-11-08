require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: process.env.QUICKNODE_DEV_KEY,
      accounts: [process.env.GOERLI_KEY],
    },
  },
};
