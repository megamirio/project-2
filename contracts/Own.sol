pragma solidity ^0.4.18;

contract Own {

    address private owner;

    event LogNewOwner(address indexed sender, address indexed newOwner);

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
        require(newOwner != 0);
        owner = newOwner;
        LogNewOwner(msg.sender, newOwner);
    }

    function getOwner()
    public view
    returns (address) {
        return owner;
    }
}