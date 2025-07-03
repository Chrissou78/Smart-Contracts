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

contract MultiToolCA is Ownable {

    string public _name = "Market Maker Contract";

    mapping(address => bool) public _authorized; //blacklist function
    bool public trading = false;
    uint256 public amountbnb;
    uint256 public amounttoken;
    uint256 public cycleLimit;
    uint256 public MinBNB;
    uint index = 0;
    IJoeRouter02 private JoeV2Router;
    address public Router;

    address [30] public RecipientContract;
    uint256 [30] public Tokens; 

    address private Treasury;
    uint256 private SubFee = 0;
    uint256 private TxFee = 0;  

    modifier onlySub() {
      require(_authorized[msg.sender], "Caller not authorized");
      _;
    }

    constructor () {

            Router = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4;
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
    function setSubOperator(address newSubOperator) public onlyOwner {
      require(!_authorized[newSubOperator], "Already set to this");
      _authorized[newSubOperator] = true;
    }

    function ResetSubOperator(address subOperator) public onlyOwner {_authorized[subOperator] = false;}
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
    function SetRecipientWallets(address wallet1, address wallet2, address wallet3, address wallet4, address wallet5) external onlySub{
        require (index <= 29," too much");
        if (wallet1 != 0x0000000000000000000000000000000000000000) {
            RecipientContract[index] = wallet1;
            index+=1;
        }
        if (wallet2 != 0x0000000000000000000000000000000000000000) {
            RecipientContract[index] = wallet2;
            index+=1;
        }
        if (wallet3 != 0x0000000000000000000000000000000000000000) {
            RecipientContract[index] = wallet3;
            index+=1;
        }
        if (wallet4 != 0x0000000000000000000000000000000000000000) {
            RecipientContract[index] = wallet4;
            index+=1;
        }
        if (wallet5 != 0x0000000000000000000000000000000000000000) {
            RecipientContract[index] = wallet5;
            index+=1;
        }
    }

    function ResetRecepientWallets() external onlySub{
        for (uint256 i = index; i <= 1; i--){
            RecipientContract[index - 1] = 0x0000000000000000000000000000000000000000;
            index-=1;
        }
    }
    
    function AutoTrade(address token, uint cycle, uint256 BNBtrade) public payable onlySub {
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
    
    function changeRouter(address newrouter) public payable onlySub {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }
        IJoeRouter02 _JoeV2Router = IJoeRouter02(newrouter);
        JoeV2Router = _JoeV2Router;
    }
    
    function BuyToken(uint256 amount, address token) public payable onlySub {
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

    function SellToken(uint256 amount, address token) public payable onlySub {
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

    function BulkBuy(address token, uint256 BNBtrade) public payable onlySub {
        require (trading, "not allowed to trade");
        amountbnb = address(this).balance;
        uint256 amountbnbtoswap;
        address Myaddress;
        uint i;
        uint256 GasBNB = (index) * MinBNB;

        
        for (i = 0; i <= (index -1); i++) {
            if(BNBtrade >= amountbnb - GasBNB){amountbnbtoswap = amountbnb - GasBNB;}
            else {amountbnbtoswap = BNBtrade;}
            Myaddress = RecipientContract[i];
            address[] memory path = new address[](2);
            path[0] = JoeV2Router.WAVAX();
            path[1] = token;
            JoeV2Router.swapExactAVAXForTokensSupportingFeeOnTransferTokens{value: amountbnbtoswap}(0, path, address(Myaddress), block.timestamp); 
            amountbnb = address(this).balance;
            Tokens[i] = IBEP20(token).balanceOf(address(Myaddress));      
        }
    } 
 
    function recoverBNB() public payable onlySub {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        _sendBnb(msg.sender, address(this).balance);
        amountbnb = address(this).balance;
    }

    function recoverMiscToken(address tokenAddress) public payable onlySub {
        require(trading,"Auto Trading not Allowed, Please contact Owner");
        IBEP20(tokenAddress).transfer(msg.sender,IBEP20(tokenAddress).balanceOf(address(this)));
    }

    function GetRecipient () public view onlySub returns (uint, address [30] memory, uint256 [30] memory) {
        return ((index), RecipientContract, Tokens);
    }
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}