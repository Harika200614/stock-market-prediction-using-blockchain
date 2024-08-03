// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StockMarketPrediction {
    // Define a struct to hold user information
    struct User {
        string name;
        string email;
        bool isVerified;
        bool exists;
    }

    // Define a struct to hold stock predictions
    struct Prediction {
        string stockSymbol;
        uint256 predictedPrice;
        uint256 timestamp;
        bool verified;
    }

    // Mapping from address to User
    mapping(address => User) private users;

    // Mapping from address to array of Predictions
    mapping(address => Prediction[]) private predictions;

    // Event to log user registration
    event UserRegistered(address indexed user, string name, string email);

    // Event to log user verification
    event UserVerified(address indexed user);

    // Event to log stock prediction
    event StockPredicted(address indexed user, string stockSymbol, uint256 predictedPrice, uint256 timestamp);

    address owner;

    constructor(){
        owner=msg.sender;
    }

    // Modifier to ensure only verified users can perform certain actions
    modifier onlyVerifiedUser() {
        require(users[msg.sender].isVerified, "You are not a verified user.");
        _;
    }

    // Function to register a new user
    function registerUser(string memory _name, string memory _email) public {
        require(!users[msg.sender].exists, "User already registered.");
        users[msg.sender] = User({
            name: _name,
            email: _email,
            isVerified: false,
            exists: true
        });
        emit UserRegistered(msg.sender, _name, _email);
    }

    // Function to verify a user (can be called by an external verification system)
    function verifyUser(address _user) public {
        require(users[_user].exists, "User does not exist.");
        require(!users[_user].isVerified, "User already verified.");
        require(owner==msg.sender);
        users[_user].isVerified = true;
        emit UserVerified(_user);
    }

    // Function to submit a stock prediction
    function submitPrediction(string memory _stockSymbol, uint256 _predictedPrice) public onlyVerifiedUser {
        Prediction memory newPrediction = Prediction({
            stockSymbol: _stockSymbol,
            predictedPrice: _predictedPrice,
            timestamp: block.timestamp,
            verified: true
        });
        predictions[msg.sender].push(newPrediction);
        emit StockPredicted(msg.sender, _stockSymbol, _predictedPrice, block.timestamp);
    }

    // Function to get a user's predictions
    function getPredictions(address _user) public view returns (Prediction[] memory) {
        return predictions[_user];
    }
}
