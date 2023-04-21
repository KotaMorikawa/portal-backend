// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Portal {
    uint256 totalPosts;

    // create seed for making random numbers
    uint256 private seed;

    // Create New Event
    event NewWave(address indexed from, uint256 timestamp, string message);

    // make struct
    struct Post {
        address poster; //userAddress
        string message; // message which user send
        uint256 timestamp; // just time whem user send message
    }

    // Array struct
    Post[] posts;

    // relate address to number(last time posted)
    mapping(address => uint256) public lastPostedAt;

    constructor() payable {
        console.log("We have been constructed!");

        //making first seed
        seed = (block.timestamp + block.prevrandao) % 100;
    }

    function post(string memory _message) public {
        // check to see if it has been more than 15 minutes since user posted last time.
        require(
            lastPostedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15min"
        );

        totalPosts += 1;
        console.log("%s has posted!", msg.sender);

        // push post Array
        posts.push(Post(msg.sender, _message, block.timestamp));

        // making random numbers for user
        seed = (block.prevrandao + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        if (seed <= 50) {
            console.log("%s is winner!!!", msg.sender);

            // send 0.0001eth to user who post
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        } else {
            console.log("%s did not win", msg.sender);
        }
        // store posted time
        lastPostedAt[msg.sender] = block.timestamp;

        // notificate to frontend by emit
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllPosts() public view returns (Post[] memory) {
        return posts;
    }

    function getTotalPosts() public view returns (uint256) {
        console.log("We have %d total posts!", totalPosts);
        return totalPosts;
    }
}
