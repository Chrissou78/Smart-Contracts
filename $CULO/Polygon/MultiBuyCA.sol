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

contract MultiBuyCA is Ownable {

    string public _name = "Multi Buy Contract";
    mapping(address => bool) public _authorized;
    bool public _trading = false;
    uint256 public amountbnb;
    uint256 MinBNB;
    uint index = 0;
    IJoeRouter02 public JoeV2Router;
    address public Router;
    address [30] public RecipientContract;
    uint256 [30] public Tokens; 

    modifier onlySub() {
      require(_authorized[msg.sender], "Caller not authorized");
      _;
    }

    constructor () {    
        MinBNB = 5 * 10**15; //0.005
        Router = 0xd7f655E3376cE2D7A2b08fF01Eb3B1023191A901;
        IJoeRouter02 _JoeV2Router = IJoeRouter02(Router);
        JoeV2Router = _JoeV2Router;
        _authorized[msg.sender] = true;
        index = 0;
    }

    receive() external payable {}
    
    function setSubOperator(address newSubOperator) public onlyOwner {
      require(!_authorized[newSubOperator], "Already set to this");
      _authorized[newSubOperator] = true;
    }

    function ResetSubOperator(address subOperator) public onlyOwner {_authorized[subOperator] = false;}
    //******************************************************************************************************
    // Subscriber functions
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

    function AuthorizeAddress(address account, bool value) external onlyOwner {_authorized[account] = value;}
    function SetLimits(uint256 BNBLimit) public onlyOwner {MinBNB = BNBLimit;}
    function AllowTrading () public onlyOwner{_trading = !_trading;}
    
    function changeRouter(address newrouter) public onlySub {
        IJoeRouter02 _JoeV2Router = IJoeRouter02(newrouter);
        JoeV2Router = _JoeV2Router;
    }

    function BulkBuy(address token, uint256 BNBtrade) public payable onlySub {
        require (_trading, "not allowed to trade");
        amountbnb = address(this).balance;
        uint256 amountbnbtoswap;
        address Myaddress;
        uint i;
        uint256 GasBNB = (index) * MinBNB;

        
        for (i = 0; i <= (index -1); i++) {
            if(BNBtrade >= amountbnb - GasBNB){amountbnbtoswap = amountbnb - GasBNB;}
            else {amountbnbtoswap = BNBtrade;}
            Myaddress = RecipientContract[i];
            BuyToken(amountbnbtoswap, address(Myaddress), token);
            Tokens[i] = IBEP20(token).balanceOf(address(Myaddress));      
        }
    } 

    function recoverBNB() public onlySub {
        _sendBnb(msg.sender, address(this).balance);
    } 
    
    function recoverMiscToken(address tokenAddress) public onlySub {
        IBEP20(tokenAddress).transfer(msg.sender,IBEP20(tokenAddress).balanceOf(address(this)));
    }

    function GetRecipient () public view onlySub returns (uint, address [30] memory, uint256 [30] memory) {
        return ((index), RecipientContract, Tokens);
    }
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function BuyToken(uint256 amount, address recipient, address token) private {       
        address[] memory path = new address[](2);
        path[0] = JoeV2Router.WAVAX();
        path[1] = token;
        JoeV2Router.swapExactAVAXForTokensSupportingFeeOnTransferTokens{value: amount}(0, path, address(recipient), block.timestamp); 
        amountbnb = address(this).balance;
    }

    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}