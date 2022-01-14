// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cinema is ERC20, Ownable{
    
    // ============================================
    // Initial Statements
    // ============================================
    
    // Constructor 
    constructor() ERC20("Movies", "MC") {
        _mint(address(this), 1000);
    }
    
    // Data structure to store customer data
    struct customer {
        uint tokens_purchased;
        string [] enjoyed_movies;
    }
    
    // Mapping for customer registration
    mapping (address => customer) public Customers;
    
    // ============================================
    // Token Management
    // ============================================

    // Function to set the price of a Token 
    function priceTokens(uint _numTokens) internal pure returns (uint) {
        return _numTokens*(1 ether);
    }

    // Function to view the account token balance
    function balanceTokens(address _account) public view returns (uint) {
        return balanceOf(_account);
    }
    
    // Function to mint more tokens
    function mint(uint256 _amount) public onlyOwner{
        _mint(address(this), _amount);
    }

    // Function to buy tokens 
    function purchaseTokens(uint _numTokens) public payable {
        // Set the price of the tokens
        uint cost = priceTokens(_numTokens);
        // The money that the customer pays for the tokens is evaluated
        require (msg.value >= cost, "Buy less tokens or pay with more ethers.");
        // The returnValue is defined as what the customer pays minus what the product is worth.
        uint returnValue = msg.value - cost;
        // The company returns the amount of ethers to the customer
        payable(msg.sender).transfer(returnValue);
        // Obtaining the number of tokens available from the Smart contract
        uint balance = balanceTokens(address(this));
        require(_numTokens <= balance, 
                "Buy a smaller number of tokens.");
        // The number of tokens purchased is transferred to the customer
        _transfer(address(this), msg.sender, _numTokens);
        // Registration of purchased tokens
        Customers[msg.sender].tokens_purchased += _numTokens;
    }

    // Function for a customer to exchange tokens for ethers
    function tokensEthers (uint _numTokens) public payable {
        // Verify that the number of tokens to be returned is positive
        require (_numTokens > 0, 
                "You need to return a positive amount of tokens.");
        // The user must have the number of tokens to be returned
        require (_numTokens <= balanceTokens(msg.sender), 
                "You do not have the tokens you wish to return");
        // Step-1: Sending tokens to the Smart contract
        _transfer(msg.sender, address(this), _numTokens);
        // Step-2: Sending ethers to the customer
        payable(msg.sender).transfer(priceTokens(_numTokens));
    }

    // ============================================
    // Company management
    // ============================================

    // Events 
    event enjoy_movie(string, uint, address);
    event new_movie(string, uint);
    event delete_movie(string);
    
    // Data structure for movies
    struct movie {
        string movie_name;
        uint movie_price;
        bool movie_status;
    }
    
    // Mapping to relate a movie name to a movie data structure
    mapping (string => movie) public MappingMovies;
    
    // Array for storing the name of the movies 
    string [] Movies;

    // Incorporate new films into the cinema
    function newMovie(string memory _movie_name, uint _movie_price) public onlyOwner {
        // Creation of a new movie for the cinema 
        MappingMovies[_movie_name] = movie(_movie_name,_movie_price, true);
        // Storing the movie name in an array 
        Movies.push(_movie_name);
        // Broadcast event for new movie created 
        emit new_movie(_movie_name, _movie_price);
    }
    
    // Function to remove a movie from the cinema
    function deleteMovie (string memory _movie_name) public onlyOwner{
        // Movie status is set to FALSE => Not available in the cinema
        MappingMovies[_movie_name].movie_status = false;
        // Emission of the event for the elimination of the movie 
        emit delete_movie(_movie_name);
     }
    
    // Function to watch a movie and pay tokens for it
    function watchMovie (string memory _movie_name) public {
        // Price of the movie (in tokens)
        uint movie_tokens = MappingMovies[_movie_name].movie_price;
        // Verify the status of the movie (if it is available for watching)
        require (MappingMovies[_movie_name].movie_status == true, 
                "This movie is not available in this cinema.");
        // Verify the number of tokens the client has to watch the movie
        require(movie_tokens <= balanceTokens(address(this)), 
                "You need more tokens to watch this movie.");
        _transfer(msg.sender, address(this), movie_tokens);
        // Storage in the client's history of watched movies
        Customers[msg.sender].enjoyed_movies.push(_movie_name);
        // Broadcasting of the event to enjoy the movie 
        emit enjoy_movie(_movie_name, movie_tokens, msg.sender);
    }

    // ============================================
    // Information storage
    // ============================================

    // Function to visualize the movie history
    function movieHistory() public view returns (string [] memory){
        return Customers[msg.sender].enjoyed_movies;
    }

    // Function for displaying movies available in the cinema
    function cinema_schedule() public view returns (string [] memory) {
        return Movies;
    }
    
    
}