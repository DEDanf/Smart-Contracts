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
A smart contract interface to handle referrals for affiliate marketing in a decentralised manner, 
utilising a userID to match a user to a specific wallet address.

The smart contract ties wallets to their referrer for life giving the referrer a share of the 
users fees towards the protocol utilizing this system. If a user who has already utilized a referral ID previously
utilises the protocol it is overriden and his previous referrer earns his referrer fee.

*/


interface IReferrals {
    
    //Pays Referrer passed as initial uint user ID, value passed as msg.value. Returns the userID of the payee, if he is unregistered it registers him and pays it.
    function payReferrerAndRegister(uint256) external payable returns(uint256);
    
    //Pays Referrer passed as initial uint user ID, value passed as msg.value.
    function payReferrer(uint256) external payable;
    
    //Allows a user to change the referrer address to 
    function changeReferrerAddress(address) external;
    
    //Allows Referrer to withdraw his accrued funds
    function withdrawReferralFunds() external;
    
    //Allows a user to query his referrer information with his address
    function queryReferrerByAddress(address) external view returns(uint256, uint256, uint256, uint256, uint256, bool);
    
}