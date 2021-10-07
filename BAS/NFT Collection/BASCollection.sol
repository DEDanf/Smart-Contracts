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

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/IPancakeRouter02.sol";
import "https://github.com/smartcontractkit/chainlink/blob/master/contracts/src/v0.8/VRFConsumerBase.sol";

contract PegSwap {
    function swap(uint256 amount, address source, address target) internal {}
}

/**
 * @title BAS Collectables contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */
contract BASCollection is ERC721Enumerable, Ownable, VRFConsumerBase {
    using SafeMath for uint256;

    /**
     * Variables/Constants for BASC 
     */
    uint256 public constant BASC_FEE = 330000000000000000;
    uint public constant maxBASCPurchase = 20;
    string private _customBaseURI = "";
    uint256 public MAX_BASC;
    bool public saleIsActive = false;
    uint256 public REVEAL_TIMESTAMP;
    
    /**
     * Variables used for Chainlink VRF RNG
     */
    bytes32 internal keyHash;
    uint256 internal fee;
    // Mapping of requestId to a particular address: requestId => address
    mapping(bytes32 => address) public requestIdToAddress;
    mapping(bytes32 => uint) public requestIdToIndex;
    
    /**
     * Constants and interfaces for BNB => Link and swapping of Pegged Link to Link
     */
    address private constant _PANCAKEROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private constant _LINKPOOL = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD;
    address private constant _LINKSWAP = 0x1FCc3B22955e76Ca48bF025f1A6993685975Bb9e;
    // Router used for exchanging BNB to Pegged Link
    IPancakeRouter02 private _pancakeRouter;
    // Swap Pegged Link for Link
    PegSwap private _linkSwap;
    
    // TODO: Model the bas collectable (Features)
    
    constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart, address _vrfCoordinator, address _link) 
        ERC721(name, symbol) 
        VRFConsumerBase(_vrfCoordinator, _link) {
            
            MAX_BASC = maxNftSupply;
            REVEAL_TIMESTAMP = saleStart + (86400 * 9); // REVEAL_TIMESTAMP = saleStart + 9 days
            
            keyHash = 0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c; //From chain link docs https://docs.chain.link/docs/vrf-contracts/ 
            fee = 0.2 * 10 ** 18; // 0.2 LINK (BSC)
            
            _pancakeRouter = IPancakeRouter02(_PANCAKEROUTER);
            _linkSwap = PegSwap(_LINKSWAP);
    }


    /**
     * Function used to withdraw funds from contract 
     */
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
    
    
    /**
     * Overrides virtual _baseURI() used in ERC721 _tokenURI() to use custom value
     */
    function _baseURI() internal view override returns (string memory) {
        return _customBaseURI;
    }

    /**
     * Sets the baseURI to a string value
     */
    function setBaseURI(string memory baseURI) public onlyOwner {
        _customBaseURI = baseURI;
    }

    /*
    * Pause sale if active, make active if paused
    */
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }
    
    /** 
     * Requests randomness 
     */
    function getRandomNumber() internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        requestId = requestRandomness(keyHash, fee);
        requestIdToAddress[requestId] = msg.sender;
    }
    
    /**
     * callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        // Use randomness here to create NFT
        _safeMint(requestIdToAddress[requestId], requestIdToIndex[requestId]);
    }

    /**
    * Mints BAS Collectable
    */
    function mintBASC(uint numberOfTokens) public payable {
        require(saleIsActive, "Sale must be active to mint Ape");
        require(numberOfTokens <= maxBASCPurchase, "Can only mint 20 tokens at a time");
        require(totalSupply().add(numberOfTokens) <= MAX_BASC, "Purchase would exceed max supply of the BAS collection");
        require(BASC_FEE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        
        //TODO: Need to do currency swaps
        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_BASC) {
                bytes32 requestId = getRandomNumber();
                requestIdToIndex[requestId] = mintIndex;
            }
        }
        
    }
}
