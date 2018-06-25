pragma solidity ^0.4.18;

import "./Own.sol";

contract Remittance is Own {

    bytes32 public paymentHash;
    uint public  deadline;
    address public receiver;

    event LogPayment(address receiver, uint amount);
    event LogRemittance(bytes32 _paymentHash, uint _deadline, address _receiver);
    event LogWithdraw(uint _amount, address _receiver);

    function Remittance(bytes32 _paymentHash, uint _deadline, address _receiver) payable public {
        paymentHash = _paymentHash;
        deadline = _deadline;
        receiver = _receiver;
        LogRemittance(_paymentHash, _deadline, _receiver);
    }

    modifier hasMoney()
    {
        require(address(this).balance > 0);
        _;
    }

    function withdraw() public
    onlyOwner
    hasMoney
    returns (bool success)
    {
        require(block.number > deadline);

        LogWithdraw(address(this).balance, msg.sender);

        return msg.sender.transfer(address(this).balance)();
    }

    function receiveMoney(string pass1, string pass2)
    public
    hasMoney
    returns (bool success)
    {
        require(block.number <= deadline);
        require(keccak256(pass1, pass2) == paymentHash);

        require(msg.sender == receiver);

        LogPayment(msg.sender, address(this).balance);
        return msg.sender.transfer(address(this).balance)();
    }

}
