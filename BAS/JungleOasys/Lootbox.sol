
contract GIFTLottery is VRFConsumerBase{
    
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    struct lotteryEntry {
        address payable sender;
        address payable recipient;
    }
    
    lotteryEntry[] private entriesArr;
    address payable winner1;
    address payable winner2;
    
    address handler;
    address lotteryAdmin;
    address manager;
    
    address private giftTokenAddress;
    IERC20 private giftToken;
    
    //CHAINLINK 
    
    bytes32 keyHash;
    uint256 chainlinkFee;
    
    constructor(address _giftToken, address _handler, address _vrfCoordinator, address _link, bytes32 _keyHash, uint256 _fee) VRFConsumerBase(_vrfCoordinator, _link) {
        
        handler = _handler;
        manager = tx.origin;
        
        //Chainlink INITIALIZATION
        
        chainlinkFee = _fee;
        keyHash = _keyHash;
        
        giftTokenAddress = _giftToken;
        giftToken = IERC20(giftTokenAddress);
    }
    
    modifier onlyManager() {
        require(msg.sender == manager, "NOT MANAGER");
        _;
    }

    modifier onlyHandler() {
        require(msg.sender == handler, "NOT HANDLER");
        _;
    }
    
    modifier onlyLotteryAdmin() {
        require(msg.sender == lotteryAdmin, "NOT LOTTERY ADMIN");
        _;
    }
    
    function changeManager(address _manager) onlyManager external {
        manager = _manager;
    }
    
    function changeLotteryAdmin(address _lotteryAdmin) onlyManager external {
        lotteryAdmin = _lotteryAdmin;
    }
    
    function changeChainlinkFee(uint256 _fee) external onlyManager  {
        chainlinkFee = _fee * 10 ** 18;
    }
    
    function changeGiftToken(address _giftToken) external onlyManager {
        giftTokenAddress = _giftToken;
        giftToken = IERC20(giftTokenAddress);
    }

    function addToLottery(address payable _sender, address payable _redeemer) external onlyHandler{
        
        entriesArr.push(lotteryEntry(_sender, _redeemer));
    }
    
    //This function calls the VRF Chainlink Coordinator to get a random number for the draw
    function getLotteryNumber() external onlyLotteryAdmin  {
        require(LINK.balanceOf(address(this)) >= chainlinkFee, "Not enough LINK - fill contract with faucet");
        requestRandomness(keyHash, chainlinkFee);
    }
    
    //This function decides the lottery result, takes the random number, sets the winners, sends the rewards and resets the lottery entries array
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        
        
        uint256 winnersIndex = randomness.mod(entriesArr.length);
        uint256 lotteryFund = giftToken.balanceOf(address(this));
        uint256 winAmount = giftToken.balanceOf(address(this)).div(2);
        giftToken.safeTransfer(entriesArr[winnersIndex].sender, winAmount);
        giftToken.safeTransfer(entriesArr[winnersIndex].recipient, lotteryFund.sub(winAmount));
        winner1 = entriesArr[winnersIndex].sender;
        winner2 = entriesArr[winnersIndex].recipient;
        delete entriesArr;
        
    }
    
    function viewLotteryJackpot() external view returns(uint256) {

        return(giftToken.balanceOf(address(this)));
        
    }
    
    function viewLotteryWinners() external view returns(address payable _sender, address payable _recipient) {
        
        return(winner1, winner2);
    }
    
    
}
