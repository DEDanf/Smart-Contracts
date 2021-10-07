/*


           ██████████   █████████   ████████  
           ██      ██   ██     ██   ██            
           ██      ██   ██     ██   ██            
           ██████████   █████████   ████████      
           ██      ██   ██     ██         ██      
           ██      ██   ██     ██         ██
           ██████████   ██     ██   ████████    
           
         █████████████████████████████████████
         
                   Block, Ape, Scissors
           
*/



// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.6;

import "./BAS - ERC1155/ERC1155.sol";
import "./Auxiliary/SafeMath.sol";
import "./Auxiliary/Address.sol";
import "./Auxiliary/AccessControl.sol";


//The challenge here is to create a market that allows for bidding in multiple currencies.


contract Market is ERC1155, AccessControl{
    using SafeMath for uint256;
    using Address for address;
    
    // Definition of user roles used for RBAC
    bytes32 public constant SERVER_ROLE = keccak256("SERVER");
    bytes32 public constant MARKETER_ROLE = keccak256("MARKETER");
    bytes32 public constant ASSET_ADMIN_ROLE = keccak256("ASSET_ADMINS");
    
    // Definition of types of tokens, used in RBAC
    enum TokenType { NFT, SFT, FT };
    
    struct auctionData{
      address owner;
      address lastBidder;
      uint256 expiry;
      uint256[] token;
      uint256[] bid;
      uint256 lastAuction;
    }
    // [Pure Auction] Timed auction minium bid: expiry = time, bid = minium
    // [Any Matching Offer] No timed auction but min bid: expiry = 0, bid = minium
    // [Limited Offer] Timed auction no minium bid: expiry = time, bid = 0
    // [Open Offer] No timed auction no min bid: expiry = 0, bid = 0
    
    mapping(uint256 => auctionData) public auctionList;
    
    constructor(address root) public {
        _setupRole(DEFAULT_ADMIN_ROLE, root);
        _setRoleAdmin(SERVER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(MARKETER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(ASSET_ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
    }
    
    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "Restricted to admins."); fs
        _;
    }
    modifier ownersOnly(uint256 _id, uint256 _amount) {
        require(balances[msg.sender][_id] >= _amount, "ERC1155Tradable#ownersOnly: ONLY_OWNERS_ALLOWED");
        _;
    }
    
    function addServer(address account) public virtual onlyAdmin {
        // Check that the account being added to the server is not a Marketer
        require(hasRole(MARKETER_ROLE, account) == false);
        require(hasRole(ASSET_ADMIN_ROLE, account) == false);
        grantRole(SERVER_ROLE, account);
    }
    
    function addMarketer(address account) public virtual onlyAdmin {
        require(hasRole(SERVER_ROLE, account) == false);
        require(hasRole(ASSET_ADMIN_ROLE, account) == false);
        grantRole(MARKETER_ROLE, account);
    }
    
    function addAssetAdmin(address account) public virtual onlyAdmin {
        require(hasRole(SERVER_ROLE, account) == false);
        require(hasRole(MARKETER_ROLE, account) == false);
        grantRole(ASSET_ADMIN_ROLE, account);
    }
    
    function createAuction(uint256 _price, uint256 _expiry, uint256 _token, uint256 _amount) public ownersOnly(_token, _amount){
      require(block.timestamp < _expiry, "Auction Date Passed");
      require(block.timestamp + (86400 * 14) > _expiry, "Auction Date Too Far");
      require(_price > 0, "Auction Price Cannot Be 0");
      for(uint x = 0; x < _amount; x++){
        safeTransferFrom(msg.sender, address(this), _token, 1, "");
        auctionList[auctionCount] = auctionData(msg.sender, address(0), _price, _expiry, _token);
        emit AuctionStart(msg.sender, _token, _price, auctionCount, _expiry);
        auctionCount++;
      }
    }

    function bid(uint256 _bid, uint256 _auctionID) 
    
}


/**
 * Understanding so far
 * ERC1155 allows for a 2D array of token ids x address = balence
 * A NFT in this would be a token id with a balence of 1 (globaly)
 * That type should change the functionality of minting/transfering
 * 
 * Possibly use ownership through https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/access
 * Docs: https://docs.openzeppelin.com/contracts/2.x/access-control#role-based-access-control
 * 
 * Other Data:
 * Tournaments, Auctions, Trades
 **/
