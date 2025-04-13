// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage {
    uint256 myFavoriteNumber; // 0 is uint256's default value.

    // uint256[] listOfFavoriteNumbers;

    struct Person{
        uint256 favoriteNumber;
        string name;
    }

    // Person public akshat = Person({ favoriteNumber: 5, name: "Akshat"});
    // Person public soham = Person({ favoriteNumber: 4, name: "soham"});
    // Person public nishchal = Person({ favoriteNumber: 3, name: "nishchal"});

    Person[] public listOfPeople; // dynamic array

    // Person[3] public listOfPeople; //static array

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
        // NOTICE that the storage variable can be changed after it is initialized
    }

    function retrieve() public view returns(uint256) {
        return myFavoriteNumber;
    }

    // memory(variable can be modified), calldata(variable cannot be modified), storage
    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}