// SPDX-License-Identifier: MIT

//*************************************************************************************************//

// Provided by EarthWalkers Dev Team
// TG : https://t.me/officialearthwalktoken

// Part of the MoonWalkers Eco-system
// Website : https://moonwalkerstoken.com/
// TG : https://t.me/officialmoonwalkerstoken
// Contact us if you need to build a contract
// Contact TG : @chrissou78, Mail : adminmoon@moonwalkerstoken.com
// Full Crypto services : smart-contracts, website, launch and deploy, KYC, Audit, Vault, BuyBot
// Marketing : AMA , Calls, TG Management (bots, security, links)

// and our on demand personnalised Gear shop
// TG : https://t.me/cryptojunkieteeofficial

//*************************************************************************************************//

pragma solidity ^0.8.16;

interface IBEP20 {
  function name() external view returns (string memory);
  function getOwner() external returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
}

interface IRouter {
    function WETH() external pure returns (address);
    function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
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

contract SafeToken is Ownable {
    address payable safeManager;
    constructor() {safeManager = payable(msg.sender);}
    function setSafeManager(address payable _safeManager) public onlyOwner {safeManager = _safeManager;}
    function withdraw(address _token, uint256 _amount) external { require(msg.sender == safeManager); IBEP20(_token).transfer(safeManager, _amount);}
    function withdrawBNB(uint256 _amount) external {require(msg.sender == safeManager); safeManager.transfer(_amount);}
}

contract AutoTradeBot is Ownable, SafeToken {

    string public _name = "EW Auto Trade Bot";

    mapping(address => bool) public _authorized; //blacklist function
    bool public trading = false;
    uint256 public amountbnb;
    uint256 public amounttoken;
    uint256 public cycleLimit;
    uint256 public MinBNB;
    IRouter private  _Router;
    address public Router;

    address private Treasury = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
    uint256 private SubFee = 0;
    uint256 private TxFee = 0;  

    modifier authorized() {require(_authorized[msg.sender], "Caller not authorized"); _;}

    constructor () {
        if (block.chainid == 56) {
            Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
            cycleLimit = 100;
            MinBNB = 3 * 10**15; //0.003
        } else if (block.chainid == 97) {
            Router = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
            cycleLimit = 50;
            MinBNB = 5 * 10**15; //0.005
        } else 
            revert();        
        _Router = IRouter(Router);
        _authorized[msg.sender] = true;
    }

    receive() external payable {}
    //******************************************************************************************************
    // Owner functions
    //******************************************************************************************************
    function AuthorizeAddress(address account, bool value) external onlyOwner {_authorized[account] = value;}
    function AllowTrading () public onlyOwner {trading = !trading;}
    function recoverMiscToken(address tokenAddress) public onlyOwner {IBEP20(tokenAddress).transfer(msg.sender,IBEP20(tokenAddress).balanceOf(address(this)));} 
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
        Router = newrouter;
        _Router = IRouter(Router);
    }
    
    function BuyToken(uint256 amount, address token) public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }
        address[] memory path = new address[](2);
        path[0] = _Router.WETH();
        path[1] = token;
        _Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(0, path, address(this), block.timestamp); 
        amountbnb = address(this).balance;
        amounttoken = IBEP20(token).balanceOf(address(this));
    }

    function SellToken(uint256 amount, address token) public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        IBEP20(token).approve(address(_Router), amount); 
        address[] memory path = new address[](2);
        path[0] = token;
        path[1] = _Router.WETH();
        _Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp); 
        amountbnb = address(this).balance;
        amounttoken = IBEP20(token).balanceOf(address(this));
    }
 
    function recoverBNB() public payable authorized {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        _sendBnb(msg.sender, address(this).balance);
        amountbnb = address(this).balance;
    } 
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}