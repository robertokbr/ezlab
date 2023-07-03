// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

/**
 * @title Ezlab
 * @dev Cassino contract 
 */
contract Ezlab {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 1 * 1e18;

    address private immutable i_owner;

    mapping(address => uint256) private s_addressToAmountFunded;
    mapping(address => address) private s_clientToPartner;

    address[] private s_clients;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund(address partnerWalletAddress) public payable {
        if (partnerWalletAddress != address(0)) {
            s_clientToPartner[msg.sender] = address(partnerWalletAddress);
        }

        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "The minimum fund value is 1 USD");

        s_clients.push(msg.sender);

        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public payable {
        uint256 amountFunded = s_addressToAmountFunded[msg.sender];

        require(amountFunded > 0, "You ain't got money here");

        (bool callSuccess,) = payable(msg.sender).call{ value: amountFunded }("");

        require(callSuccess, "Call has failed");

        s_addressToAmountFunded[msg.sender] = 0;
    }
}