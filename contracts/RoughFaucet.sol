// SPDX-License-Identifier: GPL-3.0

/* create a withdrawal function inside a contract
  * Limit the withdrawal
  * Send ammount to address
  * Accept incoming ammount
*/

pragma solidity >=0.7.0 <0.9.0;

contract Faucet2 {
  // define a payable address variable 'owner'
  address payable owner;

  constructor () {
    owner = payable(msg.sender);
  }
  // latest solidity version requires address payable to use transfer or send
  function withdraw (uint withdraw_amount) public {
    //event Withdrawal (address indexed to, uint amount);
    //event Deposit (address indexed from, uint amount);

    require(withdraw_amount <= 0.01 ether);
    payable(msg.sender).transfer(withdraw_amount);
    //emit Withdrawal(msg.sender, withdraw_amount);
  }

  //receive external funds
  receive() external payable{
    //emit Deposit(msg.sender, msg.value);
  }

  // modifier wraps around the function to be modified
  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  // the destroy function is modified with 'onlyOwner' access
  // Code becomes more reusable
  function destroy() public onlyOwner{
    selfdestruct(owner);
  }
}
