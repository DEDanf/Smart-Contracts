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

// SPDX-License-Identifier: MIT
// Author: Daniel Fong

pragma solidity >=0.6.0 <0.8.0;

/*
A smart contract interface to handle 

*/


interface IGiftNFTs {
    
    function changeBuybackAdmin(address) external;
    function changeRedeemer(address) external;
    function changeNFTCosts(uint256, uint256) external;
    
    function giftNFT(bytes32, uint256, address, uint256) external payable returns(uint256, uint256);
    function redeemNFT(address payable, string memory, uint256) external;
    function recoverNFT(uint256) external;
    
    function viewTotalGiftedNFTs() external view returns(uint256);
    function viewGiftedNFT(uint256) external view returns(address, uint256, bool);
    function viewGiftedNFTIndexes(address) external view returns(uint256[] memory);
    function viewNFTGiftCosts() external view returns(uint256, uint256, uint256, uint256);
    
}