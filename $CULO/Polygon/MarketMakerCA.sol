// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

interface IBEP20 {
  function name() external view returns (string memory);
  function getOwner() external returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
}

interface IJoeFactory {function createPair(address tokenA, address tokenB) external returns (address pair);}

interface IJoeRouter02 {
    function swapExactAVAXForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
    function swapExactTokensForAVAXSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function factory() external pure returns (address);
    function WAVAX() external pure returns (address);
    function addLiquidityAVAX ( address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountAVAXMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountAVAX, uint256 liquidity);
}

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {return _owner;}
    modifier onlyOwner() {require(owner() == msg.sender, "Caller must be owner"); _;}
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "newOwner must not be zero");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract MarketMakerCA is Ownable {

    string public _name = "Market Maker Contract";

    mapping(address => bool) public _authorized; //blacklist function
    bool public trading = false;
    uint256 public amountbnb;
    uint256 public amounttoken;
    uint256 public cycleLimit;
    uint256 public MinBNB;
    IJoeRouter02 private JoeV2Router;
    address public Router;

    address private Treasury;
    uint256 private SubFee = 0;
    uint256 private TxFee = 0;  

    modifier authorized() {require(_authorized[msg.sender], "Caller not authorized"); _;}

    constructor () {

            Router = 0xd7f655E3376cE2D7A2b08fF01Eb3B1023191A901;
            cycleLimit = 50;
            MinBNB = 5 * 10**15; //0.005
       
        IJoeRouter02 _JoeV2Router = IJoeRouter02(Router);
         JoeV2Router = _JoeV2Router;
        _authorized[msg.sender] = true;
        Treasury = address(msg.sender);
    }

    receive() external payable {}
    //******************************************************************************************************
    // Owner functions
    //******************************************************************************************************
    function AuthorizeAddress(address account, bool value) external onlyOwner {_authorized[account] = value;}
    function AllowTrading () public onlyOwner {trading = !trading;}
    function GetFee() external view onlyOwner returns(address treasury, uint256 subfee, uint256 txfee) {return(Treasury, SubFee, TxFee);}

    function SetLimits(uint256 cyclelimit, uint256 BNBLimit) public onlyOwner {
        cycleLimit = cyclelimit;
        MinBNB = BNBLimit;
    }
    
     function SetFee (address treasury, uint256 subFee, uint256 txfee) external onlyOwner {
        Treasury = treasury;
        SubFee = subFee;
        TxFee = txfee;
    }
    //******************************************************************************************************
    // Authorized functions
    //******************************************************************************************************
    function AutoTrade(address token, uint cycle, uint256 BNBtrade) public payable authorized {
        if (SubFee != 0) {
            require(msg.value >= SubFee,"Not Enough BNB");
            require(payable(Treasury).send(SubFee));
        }
        amountbnb = address(this).balance;
        uint256 GasBNB = cycle * MinBNB;
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        require(cycle <= cycleLimit,"limit is cycleLimit cycle max");
        require(amountbnb >= BNBtrade + GasBNB,"Not Enough Dough to launch trading!");
        
        cycle = cycle - 1;
        uint256 amountbnbtoswap;
        
        for (uint i = 0; i <= cycle; i++) {
            if(BNBtrade >= amountbnb - GasBNB){amountbnbtoswap = amountbnb - MinBNB;}
            else {amountbnbtoswap = BNBtrade;}
            BuyToken(amountbnbtoswap, token);
            SellToken(amounttoken, token);
        }
    }
    
    function changeRouter(address newrouter) public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }
        IJoeRouter02 _JoeV2Router = IJoeRouter02(newrouter);
        JoeV2Router = _JoeV2Router;
    }
    
    function BuyToken(uint256 amount, address token) public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        address[] memory path = new address[](2);
        path[0] = JoeV2Router.WAVAX();
        path[1] = token;
        JoeV2Router.swapExactAVAXForTokensSupportingFeeOnTransferTokens{value: amount}(0, path, address(this), block.timestamp); 
        amountbnb = address(this).balance;
        amounttoken = IBEP20(token).balanceOf(address(this));
    }

    function SellToken(uint256 amount, address token) public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        IBEP20(token).approve(address(JoeV2Router), amount); 
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = JoeV2Router.WAVAX();
        JoeV2Router.swapExactTokensForAVAXSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp); 
        amountbnb = address(this).balance;
        amounttoken = IBEP20(token).balanceOf(address(this));
    }
 
    function recoverBNB() public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        _sendBnb(msg.sender, address(this).balance);
        amountbnb = address(this).balance;
    }

    function recoverMiscToken(address tokenAddress) public payable authorized {
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        IBEP20(tokenAddress).transfer(msg.sender,IBEP20(tokenAddress).balanceOf(address(this)));
    }
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}