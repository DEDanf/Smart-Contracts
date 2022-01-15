 /*


           ██████████   ██   ████████   ██████████
           ██           ██   ██             ██
           ██           ██   ██             ██
           ██    ████   ██   ████████       ██
           ██      ██   ██   ██             ██
           ██████████   ██   ██             ██
           
         ███████████████████████████████████████████
         
                The gift that keeps on giving
           
*/

//SPDX-License-Identifier: MIT
//Author: Daniel Fong

pragma solidity >=0.6.0 <0.8.6;

import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/IPancakeRouter02.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC20.sol"; 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

/*
A smart contract that receives BnB and turns it into gift tokens through the pancakeswap router.
The buybacks can only be executed by a specific buybackAdmin wallet and are forwarded to a specified
address.
*/
    
contract GiftBuyBackHandler is Ownable {
    
    using SafeMath for uint256;
    
    address buybackAdmin;
    uint256 bnbGiftFeesAccrued;
    address buybackPool;

    address private constant PancakeRouter=0x10ED43C718714eb63d5aA57B78B54704E256024E;
    IPancakeRouter02 private  _pancakeRouter;
        
    address giftTokenAddress;
    IERC20 giftToken;
    
    constructor(address _buybackAdmin, address _giftToken, address _buybackpool) {
        
        //TOKEN INITIALIZATION
        giftTokenAddress = _giftToken;
        giftToken = IERC20(giftTokenAddress);    
        
        //PANCAKESWAP INITIALIZATION
        _pancakeRouter = IPancakeRouter02(PancakeRouter);
        
        //ADMIN INITIALIZATION
        buybackAdmin = _buybackAdmin;
        buybackPool = _buybackpool;
    }
    
    function changeBuybackAdmin(address _buybackAdmin) external onlyOwner {
        
        buybackAdmin = _buybackAdmin;
    }
    
    function changeBuybackPool(address _buybackpool) external onlyOwner {
        
        buybackPool = _buybackpool;
    }

    function giftBuyBack() external {
        
        require(msg.sender == buybackAdmin);
        address[] memory path = new address[](2);
        path[0] = _pancakeRouter.WETH();
        path[1] = giftTokenAddress;
        
        bnbGiftFeesAccrued = bnbGiftFeesAccrued + address(this).balance;
        
        _pancakeRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: address(this).balance} (
            0,
            path,
            buybackPool,
            block.timestamp+10
            );
    }


}  
    
    