const dotenv = require("dotenv");
dotenv.config();
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = process.env.MNEMONIC;
var rinkeby_infura_api_key = process.env.INFURA_RINKEBY;

module.exports = {
  contracts_build_directory: "../frontend/src/artifacts",
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(mnemonic, rinkeby_infura_api_key);
      },
      network_id: 4,
      networkCheckTimeout: 999999,
      gas: 4500000,
      gasPrice: 10000000000,
    },
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.12",
    },
  },
};
