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


pragma solidity >=0.6.0 <0.8.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

contract testFarm is Ownable {
    
    mapping(address => uint256) walletToDeposit;
    IERC721Metadata collection;
    
    constructor(address _collection) {
        
        collection = IERC721Metadata(_collection);
        
    }
    
    function deposit(uint256 _tokenID) external {
        
        require(collection.ownerOf(_tokenID) == msg.sender, "NOT TOKEN OWNER");
        
        collection.transferFrom(msg.sender, address(this), _tokenID);
        walletToDeposit[msg.sender] = _tokenID;
        
    }
    
    function withdraw(uint256 _tokenID) external {
        
        require(walletToDeposit[msg.sender] == _tokenID, "NOT TOKEN OWNER");
        
        collection.transferFrom(address(this), msg.sender, _tokenID);
        walletToDeposit[msg.sender] = 0;
        
    }
    
    function checkDeposit(address _wallet) external view returns(string memory) {
        
        if (walletToDeposit[_wallet] != 0) {
            return(collection.tokenURI(walletToDeposit[_wallet]));
        } else {
            return("");
        }
        
    }
    
}