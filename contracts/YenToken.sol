// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YenToken is ERC20, Ownable {

    mapping(uint256 => uint256) public prices;

    constructor() ERC20("Yen", "YEN") {
        prices[1] = 100; // Legendary Sword
        prices[2] = 50;  // Healing Potion
        prices[3] = 25;  // Magic Scroll
    }

    function mint(address _to, uint256 _value) public onlyOwner {
        _mint(_to, _value);
    }

    function transferTokens(address _to, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Error: Insufficient Yen Tokens");
        approve(_to, _value); // Approve the transfer
        transferFrom(msg.sender, _to, _value); // Transfer using allowance mechanism
    }

    function redeemToken(uint8 _option) external {
        require(_option >= 1 && _option <= 3, "Please select a valid item."); // Validate item selection
        require(balanceOf(msg.sender) >= prices[_option], "Error: Insufficient funds to redeem the item.");
        
        // Directly transfer tokens to the owner
        _transfer(msg.sender, owner(), prices[_option]);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Error: Insufficient Degen Tokens");
        approve(address(this), _value); // Approve the contract to burn tokens
        _burn(msg.sender, _value); // Burn the approved tokens
    }

    function showShopItems() external pure returns (string memory) {
        return "The items on sale are the following: [1] Legendary Sword (100) [2] Healing Potion (50) [3] Magic Scroll (25)";
    }

    function decimals() public pure override returns (uint8) {
        return 0; // No decimal places for the token
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender); // Simplified balance retrieval
    }
}
