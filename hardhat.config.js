require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: { compilers: [
    {
        version: '0.8.20',
        settings: {
            evmVersion: 'paris'
        }
    }
  ]},
  defaultNetwork: "canto",
  networks: {
    sepolia: {
      url: process.env.RPC,
      accounts: {
        mnemonic: process.env.mnemonic,
        path: "m/44'/60'/0'/0",
        initialIndex: 0,
        count: 20,
        passphrase: "",
      },
      gas: 5000000,
      // gasPrice: '15000000000'
    },
    canto: {
      url: process.env.RPC,
      accounts: {
        mnemonic: process.env.mnemonic,
        path: "m/44'/60'/0'/0",
        initialIndex: 0,
        count: 20,
        passphrase: "",
      },
      gas: 5000000,
      // gasPrice: '15000000000'
    },
  },
};
