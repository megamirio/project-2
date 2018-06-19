pragma solidity ^0.4.18;

contract Own {

    address public owner;
    event LogNewOwner(address sender, address newOwner);

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function Own() public {
        owner = msg.sender;
    }

    function changeOwner(address newOwner) public
    onlyOwner
    {
        require(newOwner!=0);
        owner = newOwner;
        LogNewOwner(msg.sender, newOwner);
    }
}