pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256  amountOfTokens, uint256 amountOfETH);

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender){
        yourToken = YourToken(tokenAddress);
    }

    uint256 public constant tokensPerEth = 100;
    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }
    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner{
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 amount) public {
        yourToken.approve(address(this), amount);
        yourToken.transferFrom(msg.sender, address(this), amount);
        uint256 amountOfETH = amount / tokensPerEth;
        (bool success, ) = payable(msg.sender).call{value: amountOfETH}("");
        require(success, "Failed to send Ether");
        emit SellTokens(msg.sender, amount, amountOfETH);
    }
}
