/*jshint esversion: 6 */
/*jshint esversion: 8 */
const bankingContract = artifacts.require('bankingApplication');
const assert = require("chai").assert;
const truffleAssert = require('truffle-assertions');

contract('testBanking',function(accounts){
  let instance;
  let tx;
  const bankOwner = accounts[0];
  const customer = accounts[1];

  before(async() =>{
    instance = await bankingContract.new({from:bankOwner});
  });
  it("Checking account creating", async() =>{
    tx = await instance.createAccount({from:customer});
    truffleAssert.eventEmitted(tx,'createdAccount',(ev)=>{
      return ev._from==customer&&ev.message=="Account created";
    });
  });
  it("Checking deposit", async() =>{
    tx = await instance.deposit({from:bankOwner,value:100000});
    truffleAssert.eventEmitted(tx,'deposited',(ev)=>{
      return ev._from==bankOwner&&ev.message=="Successfull Deposit";
    });
  });
});
