pragma solidity >=0.5.0;

contract bankingApplication{
  struct accounts {
    bool hasAccount;
    uint balance;
  }
  uint private totalBalance;
  address payable private admin;

  mapping (address => accounts) ledger;

  constructor() public{
    totalBalance =0;
    admin = msg.sender;
    ledger[msg.sender].hasAccount = true;
    ledger[msg.sender].balance =0;
  }

  function deposit() public payable returns (string memory) {
    require(msg.value>0,"Check the deposit amount");
    require(address(msg.sender).balance-msg.value>0,"Invalid Transaction");
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");
    totalBalance += msg.value;
    ledger[msg.sender].balance += msg.value;
    return "Deposit : Success";
  }

  function withDraw(uint256 amount) public payable returns(string memory, uint){
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");
    require((ledger[msg.sender].balance-amount)>0,"Inavlid Transaction");
    require(amount>0,"Amount should be greater than 0");
    totalBalance -= amount;
    ledger[msg.sender].balance -= amount;
    require(msg.sender.send(amount),"Transfer Failed");
    return ("New Balance ",ledger[msg.sender].balance);
  }

  function getBalance() public returns(uint) {
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");
    return ledger[msg.sender].balance;
  }

  function createAccount() public returns (string memory) {
    require(!ledger[msg.sender].hasAccount,"Account Already Exists");
    ledger[msg.sender].balance=0;
    ledger[msg.sender].hasAccount=true;
    return "Account created. Welcome!";
  }

  function getContractBalance() public returns (uint){
    require(msg.sender==admin,"You are not authorized");
    return address(this).balance;
  }

  function () external payable {

  }
}
