require("@nomicfoundation/hardhat-waffle");
require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-upgrades");
require("@nomicfoundation/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.13",
  network: {
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRI_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
