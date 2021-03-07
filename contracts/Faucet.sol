// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Make an 'owned' parent with constructor + modifier
contract owned {
  address payable owner;

  constructor() {
    owner = payable(msg.sender);
  }

  modifier onlyOwner {
    require(payable(msg.sender) == owner);
    _;
  }
}

//Make a 'mortal' child with destructor
contract mortal is owned {
  function destroy() public onlyOwner{
    selfdestruct(owner);
  }
}

//Use the 'mortal' as parent in Faucet for withdraw + receive function
contract Faucet is mortal {
  address faucetAddress = address(this);
  event Withdrawal (address indexed to, uint amount);
  event Deposit (address indexed from, uint amount);

  function withdraw(uint withdraw_amount) public{
    require(withdraw_amount <= 0.01 ether);
    //Optional error handling, requires more gas
    require(faucetAddress.balance >= withdraw_amount,
      "Insufficient balance in faucet");
    payable(msg.sender).transfer(withdraw_amount);
    emit Withdrawal(msg.sender, withdraw_amount);
  }

  receive() external payable{
    emit Deposit(msg.sender, msg.value);
  }
}
