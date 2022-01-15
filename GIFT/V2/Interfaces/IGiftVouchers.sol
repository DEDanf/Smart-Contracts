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
A smart contract interface to handle Gift Vouchers. These vouchers allow the user to pay in a token in order to
put a gift into escrow with various options passed on redemption to control the purchased gift tokens.

The contract redeem function is only accessible through our server backend, this is due to how the redemption process
operates, neutralizing the threat of frontrunning for gift redemption.

Each gift has 4 Added costs:

- Gift Fee -> Forwarded to BuybackAdmin to buyback GIFT tokens
- Redeem Refund Fee -> Goes to our backend server to cover redemption costs
- Gas Top Up -> A small amount of native token balance is sent to the giftee in order to fund his initial transactions
- Referral Fee -> Forwarded to the referral contract for the product referrer

The GiftAmount indicates the amount of token balance to be used to purchase the selected tokens on redemption.
Redemption options are stored as arrays of token addresses with matching weights set by the admin. These indicate the tokens
that will be bought through DEX and their proportional weightings with regard to the giftAmount.

The Admin can add Gift Redeem options over time and modify some of the redeem features (except the redeem refund and gas topups).

*/


interface IGiftVouchers {
    
    function changeBuybackAdmin(address) external;
    function changeRedeemer(address) external;
    
    function addGiftVoucherOption(uint256, uint256, uint256, uint256, uint256, uint256) external;
    function addGiftVoucherRedemptionOption(address[] memory, uint256[] memory) external;
    function changeGiftVoucherRedemptionOption(uint256, address[] memory, uint256[] memory) external;
    
    function giftVoucher(uint256 , bytes32 , uint256 ) external payable returns(uint256, uint256);
    function redeemGiftedVoucher(address payable, string memory, uint256) external;
    function recoverGiftedVoucher(uint256) external;
    
    function viewTotalGiftedPackages() external view returns(uint256);
    function viewGiftedPackage(uint256) external view returns(address, uint256, bool);
    function viewGiftedPackageIndexes(address) external view returns(uint256[] memory);
    function viewGiftackageOption(uint256) external view returns(uint256, uint256, uint256, uint256, uint256, address[] memory, uint256[] memory);
    function viewGiftPackageOptionsLength() external view returns(uint256);
    
}