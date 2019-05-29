const UBBI = artifacts.require("UBBI");


module.exports = function (deployer, network, accounts) {
    // You can pass other parameters like gas or change the from
    const totalSupply = 100000;
    const usableTokens = 80000;
    deployer.deploy(UBBI, totalSupply, usableTokens, { from: accounts[0] });
}