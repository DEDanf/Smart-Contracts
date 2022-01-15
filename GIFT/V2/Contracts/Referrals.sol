
// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "GIFT/V2/Interfaces/IReferrals.sol";
import "GIFT/Dependencies/Abstracts/ReentrancyGuard.sol";
import "GIFT/Dependencies/Libraries/SafeMath.sol";

contract Referrals is IReferrals, ReentrancyGuard {

    using SafeMath for uint256;
    
    struct referrer {

        uint256 balance;
        uint256 totalEarned;
        uint256 referrals;
        uint256 referralSales;
    }    
    
    mapping(address => uint256) private refaddyToUID;
    mapping(address => uint256) private customerToReferrerUID;
    mapping(uint256 => referrer) private UIDToReferrer;
    
    uint256 private currentID;
    
    constructor(address _marketing) {
        currentID = 2;
        refaddyToUID[_marketing] = 1;
        UIDToReferrer[1] = referrer(0, 0, 0, 0);
    }
    
    function payReferrerAndRegister(uint256 _UID) external payable override returns(uint256){

        if(customerToReferrerUID[msg.sender]==0) {

            if(_UID == 0 || _UID >= currentID) {
                customerToReferrerUID[msg.sender] = 1;
            } else {
                customerToReferrerUID[msg.sender] = _UID;
            }
            UIDToReferrer[customerToReferrerUID[msg.sender]].referrals++;
        }
        
        UIDToReferrer[customerToReferrerUID[msg.sender]].referralSales++;
        UIDToReferrer[customerToReferrerUID[msg.sender]].balance = UIDToReferrer[customerToReferrerUID[msg.sender]].balance + msg.value;

        if (refaddyToUID[msg.sender] == 0) {

            return(registerReferrer());
            
        } else {

            return(refaddyToUID[msg.sender]);
        }
    }

    function payReferrer(uint256 _UID) external payable override {

        if(customerToReferrerUID[msg.sender]==0) {

            if(_UID == 0 || _UID >= currentID) {
                customerToReferrerUID[msg.sender] = 1;
            } else {
                customerToReferrerUID[msg.sender] = _UID;
            }
            UIDToReferrer[customerToReferrerUID[msg.sender]].referrals++;
        }
        
        UIDToReferrer[customerToReferrerUID[msg.sender]].referralSales++;
        UIDToReferrer[customerToReferrerUID[msg.sender]].balance = UIDToReferrer[customerToReferrerUID[msg.sender]].balance + msg.value;
    }    


    
    function registerReferrer() public returns (uint256) {
        
        require(refaddyToUID[msg.sender]==0, "ALREADY REGISTERED");
        refaddyToUID[msg.sender]=currentID;
        UIDToReferrer[currentID] = referrer(0,0,0,0);
        currentID++;
        return refaddyToUID[msg.sender];
        
    }
    
    function changeReferrerAddress(address payable _newAddress) external  {
        require(refaddyToUID[msg.sender] != 0, "WRONG ADDRESS");
        require(refaddyToUID[_newAddress] == 0, "NEW ADDRESS TAKEN");

        refaddyToUID[_newAddress] = refaddyToUID[msg.sender];
        refaddyToUID[msg.sender] = 0;
    }
    
    function withdrawReferralFunds() external nonReentrant override {
        
        require(refaddyToUID[msg.sender] != 0, "INVALID ADDRESS");
        require(UIDToReferrer[refaddyToUID[msg.sender]].balance > 0, "BALANCE IS ZERO");
        msg.sender.transfer(UIDToReferrer[refaddyToUID[msg.sender]].balance);
        UIDToReferrer[refaddyToUID[msg.sender]].totalEarned = UIDToReferrer[refaddyToUID[msg.sender]].totalEarned + UIDToReferrer[refaddyToUID[msg.sender]].balance;
        UIDToReferrer[refaddyToUID[msg.sender]].balance = 0;
         
    }
    
    //Returns data for referrer by address, if address in unregistered returns false
    function queryReferrerByAddress(address _referrer) external view override returns(uint256, uint256, uint256, uint256, uint256, bool) {
        if(refaddyToUID[_referrer] == 0) {
            return(0,0,0,0,0, false);
        } else {
            return(refaddyToUID[_referrer], UIDToReferrer[refaddyToUID[_referrer]].balance, UIDToReferrer[refaddyToUID[_referrer]].totalEarned, UIDToReferrer[refaddyToUID[_referrer]].referrals, UIDToReferrer[refaddyToUID[_referrer]].referralSales, true);

        }
        
    }    
    
}