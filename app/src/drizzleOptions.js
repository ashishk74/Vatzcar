import Web3 from "web3";
import Asset from "./contracts/Asset.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:8545"),
  },
  contracts: [Asset],
  //events: {
    //Asset: ["NewAssetNo"]
  //},
};

export default options;
