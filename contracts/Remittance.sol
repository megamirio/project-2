pragma solidity ^0.4.18;

import "./Own.sol";

contract Remittance is Own {
  
  bytes32 public paymentHash;
  uint public  deadline;

  event LogPayment(address receiver, uint amount);

  function Remittance(bytes32 _paymentHash, uint _deadline) payable public {
    paymentHash = _paymentHash;
    deadline = _deadline;
  }

  modifier hasMoney()
  {
    require(address(this).balance > 0);
    _;
  }

  function withdraw() public
  onlyOwner
  hasMoney
  returns(bool success)
  {
      require(block.number > deadline);
      return msg.sender.call.value(address(this).balance)();
  }

  function receiveMoney(string pass1, string pass2) 
  public
  hasMoney
  returns(bool success)
  {
    require(block.number <= deadline);
    require(keccak256(pass1, pass2) == paymentHash);

    LogPayment(msg.sender, address(this).balance);
    return msg.sender.call.value(address(this).balance)();     
  }

}
