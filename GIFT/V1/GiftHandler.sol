pragma solidity >=0.6.0 <0.8.0;
// SPDX-License-Identifier: MIT
interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract GiftingHandler {
   
    using SafeMath for uint256;

    uint256 public redeemRefundFee;
    IERC20 public token;
    
    uint256 giftCounter;
    uint256 redeemCounter;
    
    address redeemer;
    address manager;
   
    constructor(IERC20 _token, uint256 _redeemRefundFee, address _redeemer) {
       
        token = _token;
        giftCounter = 0;
        redeemCounter = 0;
        redeemRefundFee = _redeemRefundFee;
        redeemer = _redeemer;
        manager = msg.sender;

    }
    
    event giftSent (string a, bytes32 hash, string b, string c, string d, uint256 amount, uint256 date, address escrowContract);
   
   
    function gift(uint256 giftAmount, uint256 topUpAmount, string memory a, bytes32 hash, string memory b, string memory c, string memory d, uint256 date) public payable returns(address) {
       
        require(giftAmount > 0, "You need to gift some tokens!");
        require(token.allowance(msg.sender, address(this)) >= giftAmount, "Check the token allowance");
        require(msg.value == SafeMath.add(topUpAmount,redeemRefundFee));
       
        GIFTEscrow created = (new GIFTEscrow){value: msg.value}(hash, msg.sender, token, topUpAmount);
       
        token.transferFrom(msg.sender, address(this), giftAmount);
        token.transfer(address(created), giftAmount);
        
        emit giftSent(a, hash, b, c, d, giftAmount, date, address(created));
       
        giftCounter++;
        return(address(created));
       
    }
    
    function viewGiftsSent() external view returns(uint256) {
        
        return(giftCounter);
    }
    
    function redeem(address payable recipient, uint256 redeemAmount) public {

        require(tx.origin == redeemer, "Not Redeemer");        
        token.transferFrom(msg.sender, address(this), redeemAmount);
        token.transfer(recipient, redeemAmount);
        redeemCounter++;
        
    }
    
    function viewGiftsRedeemed() external view returns(uint256) {
        
        return(redeemCounter);
    }
    
    function recover(address payable recipient, uint256 recoverAmount) public {
        
        token.transferFrom(msg.sender, address(this), recoverAmount);
        token.transfer(recipient, recoverAmount);
    }

    function changeRedeemer(address newRedeemer) public {
	
    	require(msg.sender == manager, "Not Manager");
    	redeemer = newRedeemer;
	
    }
    
    function changeRefundFee(uint256 newRefundFee) public {
        
        require(msg.sender == manager, "Not Manager");
        redeemRefundFee = newRefundFee;
    }

}


contract GIFTEscrow {
   
    bytes32 hash;
    address payable sender;
    uint256 public topUpAmount;
    IERC20 public token;
    GiftingHandler handler;
   
    constructor(bytes32 _hash, address payable _sender, IERC20 _token, uint256 _topUpAmount) payable {
       
        hash = _hash;
        sender = _sender;
        token = _token;
        topUpAmount = _topUpAmount;
        handler = GiftingHandler(msg.sender);

    }
    
    function viewSender() external view returns(address payable) {
        
        return(sender);

    }
   
    function viewGiftedAmount() external view returns(uint256) {
       
        return(token.balanceOf(address(this)));

    }
   
    function withdraw(string memory redemptionString, address payable recipient ) public {
       
        require(keccak256(abi.encodePacked(redemptionString)) == hash, "Wrong Redemption Code");
        token.approve(address(handler),token.balanceOf(address(this)));
        handler.redeem(recipient, token.balanceOf(address(this)));
        recipient.transfer(topUpAmount);
        selfdestruct(msg.sender);
       
    }
   
    function recover() public {

        require(msg.sender == sender, "Not Original Gift Sender");
        token.approve(address(handler),token.balanceOf(address(this)));
        handler.recover(msg.sender, token.balanceOf(address(this)));
        selfdestruct(msg.sender);

    }
   
   
}