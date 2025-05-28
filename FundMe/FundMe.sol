// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    } 

    function fund () public payable {
        // Allow users to send USD.
        // Have a minimum USD sent.
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH"); // 1e18 = 1 ETH = 1 * 10^18 Wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw () public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex > funders.length; funderIndex++){
            addressToAmountFunded[funders[funderIndex]] = 0;
        }
        funders = new address[](0);

        // transfer // 2300 gas and if given less then it throws an error & txn reverted.
        // payable(msg.sender).transfer(address(this).balance); 
        // send // 2300 gas and if given less returns a bool. 
        // bool success = payable(msg.sender).send(address(this).balance); 
        // require(success, "send failed");
        // call // forward all gas or set gas and returns a bool.
        (bool result,) = payable(msg.sender).call{value: address(this).balance}("");
        require(result, "call failed");
    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, NotOwner()); // require is less gas efficient
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}