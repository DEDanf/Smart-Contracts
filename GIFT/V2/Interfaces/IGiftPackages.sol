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

pragma solidity >=0.6.0 <0.8.6;

/*
A smart contract interface to handle Gift Package. These packages allow the user to pay in the native chain token in order to
put a gift into escrow with a predefined purchase order for when the giftee redeems his gift.

The contract redeem function is only accessible through our server backend, this is due to how the redemption process
operates, neutralizing the threat of frontrunning for gift redemption.

Each gift has 4 Added costs:

- Gift Fee -> Forwarded to BuybackAdmin to buyback GIFT tokens
- Redeem Refund Fee -> Goes to our backend server to cover redemption costs
- Gas Top Up -> A small amount of native token balance is sent to the giftee in order to fund his initial transactions
- Referral Fee -> Forwarded to the referral contract for the product referrer

The GiftAmount indicates the amount of native token balance to be used to purchase the package on redemption.
Packages are stored as arrays of token addresses with matching weights set by the admin. These indicate to the tokens
that will be bought through DEX and their proportional weightings with regard to the giftAmount.

The Admin can add Gift Package options over time and modify some of the package features (except the redeem refund and gas topups).

*/


interface IGiftPackages {
    
    function changeBuybackAdmin(address) external;
    function changeRedeemer(address) external;
    
    function addGiftPackageOption(uint256, uint256, uint256, uint256, uint256, uint256, address[] memory, uint256[] memory) external;
    function changeGiftPackageOption(uint256, uint256, address[] memory, uint256[] memory, uint256) external;
    
    function giftPackage(uint256 , bytes32 , uint256 ) external payable returns(uint256, uint256);
    function redeemGiftedPackage(address payable, string memory, uint256) external;
    function recoverGiftedPackage(uint256) external;
    
    function viewTotalGiftedPackages() external view returns(uint256);
    function viewGiftedPackage(uint256) external view returns(address, uint256, bool);
    function viewGiftedPackageIndexes(address) external view returns(uint256[] memory);
    function viewGiftackageOption(uint256) external view returns(uint256, uint256, uint256, uint256, uint256, address[] memory, uint256[] memory);
    function viewGiftPackageOptionsLength() external view returns(uint256);
    
}