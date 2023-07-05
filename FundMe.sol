 


// SPDX-License-Identifier:MIT

pragma solidity ^0.8.8;

//  get funds from users
// wothdraw funds 
// set a minimn funding value in usd

import "./PriceConverter.sol";

// interface AggregatorV3Interface {
//         function decimals() external view returns (uint8);
    
//         function description() external view returns (string memory);
    
//         function version() external view returns (uint256);
    
//         function getRoundData(uint80 _roundId)
//           external
//           view
//           returns (
//             uint80 roundId,
//             int256 answer,
//             uint256 startedAt,
//             uint256 updatedAt,
//             uint80 answeredInRound
//           );
    
//         function latestRoundData()
//           external
//           view
//           returns (
//             uint80 roundId,
//             int256 answer,
//             uint256 startedAt,
//             uint256 updatedAt,
//             uint80 answeredInRound
//           );
// }



// transaction cost gas required to deploy this contract = 788164


// new keywrod constant , immutable

// trasaction cost after the use of constant variable

// 788164
// 768219

contract FundMe{

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders; 
    mapping(address => uint256) public addressToAmountFunded; 

    // we use contstructor function so that noone other than the sender 
    // can withdraw through the contract

    address public immutable i_owner;

    // 439 - immutable cost
    //  - non -immutable cost




    constructor(){

        // MINIMUM_USD = 2;

        i_owner = msg.sender;
    }

    function fund()  public payable{
        // want to able to set a minimum fund amount  in usd
        // how do we send ETh to this contract?

        // to get how much value somebody is sending we are using msg.value
        // and to send particular amount we use "require"
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); //


        // getConversionRate();
        funders.push(msg.sender);
        //  this is the address of whoever calls the send fucntion.
        addressToAmountFunded[msg.sender] += msg.value;
    }

    
    function withdraw() public onlyOwner{


        for(uint256 funderIndex = 0; funderIndex< funders.length; funderIndex++){

            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;

        }

        funders = new address[](0);
        
        //  semnding eth from a contract

        //  https://solidity-by-example.org/sending-ether/

        // tranfer 
        // payable(msg.sender).transfer(address(this).balance);

        // transfer (2300 gas, throws error)

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

    

        // send (2300 gas, returns bool)

        // call

        // call (forward all gas or set gas, returns bool)

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

    modifier onlyOwner{

        require(msg.sender == i_owner, "Sender isn't owner!");
        _;
    
    
    }


    // 

} 
