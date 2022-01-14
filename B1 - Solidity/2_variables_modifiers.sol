// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract variables_modifiers {
    
    // Integer values without signs (uint)
    uint a;
    uint b = 3;
    
    // Integer values with signs (int)
    int c;
    int d = -32;
    int e = 65;
        
    // String variables
    string str;
    string public str_public = "This is public";
    string private str_private = "This is private";

    // Boolean variables
    bool boolean;
    bool public boolean_true = true;
    bool public boolean_false = false;
    
    // Bytes variables
    bytes32 first_bytes;
    bytes4 second_bytes;
    bytes32 public hashing = keccak256(abi.encodePacked("Hi"));
    
    // Address variables
    address my_address;
    address public address1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public address2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    
}