var MyContract = artifacts.require("bankingApplication");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};
