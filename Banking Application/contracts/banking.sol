pragma solidity >=0.5.0;

contract bankingApplication{
  event deposited(address _from, string message);
  event withdrawal(address _from, uint newBalance, string message);
  event createdAccount(address _from, string message);

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

  function deposit() public payable  {
    require(msg.value>0,"Check the deposit amount");
    require(address(msg.sender).balance-msg.value>0,"Invalid Transaction");
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");

    totalBalance += msg.value;
    ledger[msg.sender].balance += msg.value;
    emit deposited(msg.sender, "Successfull Deposit");
  }

  function withDraw(uint256 amount) public payable {
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");
    require((ledger[msg.sender].balance-amount)>0,"Inavlid Transaction");
    require(amount>0,"Amount should be greater than 0");
    totalBalance -= amount;
    ledger[msg.sender].balance -= amount;
    require(msg.sender.send(amount),"Transfer Failed");
    emit withdrawal(msg.sender,ledger[msg.sender].balance, "Successfull Withdrwal");
  }

  function getBalance() public view returns(uint) {
    require(ledger[msg.sender].hasAccount,"You need to be a member of the bank");
    return ledger[msg.sender].balance;
  }

  function createAccount() public  {
    require(!ledger[msg.sender].hasAccount,"Account Already Exists");
    ledger[msg.sender].balance=0;
    ledger[msg.sender].hasAccount=true;
    emit createdAccount(msg.sender, "Account created");
  }

  function getContractBalance() public view returns (uint){
    require(msg.sender==admin,"You are not authorized");
    return address(this).balance;
  }

  function () external payable {

  }
}
