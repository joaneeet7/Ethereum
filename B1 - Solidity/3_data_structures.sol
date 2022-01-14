// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract data_structures {
    // Data structure for a customer
    struct Customer {
        uint256 id;
        string name;
        string email;
    }

    // Customer type variable
    Customer customer_1 = Customer(1, "Joan", "joan@gmail.com");

    // Array of fixed-length uints 5
    uint256[5] public fixed_list_uints = [1, 2, 3, 4, 5];

    // Dynamic array of uints
    uint256[] dynamic_list_uints;

    // Dynamic array of client type
    Customer[] public dynamic_list_customers;

    // New data in an array
    function array_modification(
        uint256 _id,
        string memory _name,
        string memory _email
    ) public {
        dynamic_list_customers.push(Customer(_id, _name, _email));
    }

    // Mappings
    mapping(address => uint256) public address_uint;
    mapping(string => uint256[]) public string_listUints;
    mapping(address => Customer) public address_dataStructure;

    // Assigning a number to an address
    function assignNumber(uint256 _number) public {
        address_uint[msg.sender] = _number;
    }

    // Assign a number set to a name
    function assignList(string memory _name, uint256 _number) public {
        string_listUints[_name].push(_number);
    }

    // Assign a data structure to an address
    function assignDataStructure(
        uint256 _id,
        string memory _name,
        string memory _email
    ) public {
        address_dataStructure[msg.sender] = Customer(_id, _name, _email);
    }
}
