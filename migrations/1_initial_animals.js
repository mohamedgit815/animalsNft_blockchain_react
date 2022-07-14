const AnimalsNft = artifacts.require("../contracts/AnimalNft.sol");

module.exports = function (deployer) {
  deployer.deploy(AnimalsNft);
};