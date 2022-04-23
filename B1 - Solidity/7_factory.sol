// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract father {

    // Factory information storage
    mapping (address => address) public personal_contract;

    // Issuance of new smart contracts 
    function Factory() public {
        address addr_personal_contract = address(new children(msg.sender));
        personal_contract[msg.sender] = addr_personal_contract;
    }
}

// Smart Contracts (children) generated by the father
contract children {

    // Data received to the new Smart Contract
    constructor (address _account){
        data_owner._owner = _account;
        data_owner._smartcontractFather = address(this);
    }

    // Owner data structures
    Data public data_owner;
    struct Data {
        address _owner;
        address _smartcontractFather;
    }
}