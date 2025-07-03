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
pragma solidity ^0.8.15;

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

contract BulkBuyBot is Ownable {

    string public _name = "BuyBot";
    mapping(address => bool) public _authorized;
    bool public _trading = false;
    uint256 public amountbnb;
    uint256 MinBNB;
    uint index = 0;
    IRouter private  _Router;
    address public Router;
    address [30] public RecipientContract;
    uint256 [30] public Tokens; 

    modifier onlySub() {
      require(_authorized[msg.sender], "Caller not authorized");
      _;
    }

    constructor () {
        if (block.chainid == 56) {
            Router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
            MinBNB = 3 * 10**15; //0.003
        } else if (block.chainid == 97) {
            Router = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
            MinBNB = 5 * 10**15; //0.005
        } else 
            revert();        
        _Router = IRouter(Router);
        _authorized[msg.sender] = true;
        
        RecipientContract[0] = 0x0E670BbfFc7ead71e4eb05DFe77016729B6b7C0E;
        RecipientContract[1] = 0x6603BC2e829B7a6C5cE251F664c14901de4C570D;
        RecipientContract[2] = 0xb4C5993F26Af9a18b612cc47415BcBc5bC34116f;
        RecipientContract[3] = 0x31fb68A2F3Cd809c730dc37bDbC5Da2618E46e89;
        RecipientContract[4] = 0x84293B793C3baca544B3E167a32d84763e69Bc0F;
        index = 5;

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
        require (index <= 30," too much");
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
        Router = newrouter;
        _Router = IRouter(Router);
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
        path[0] = _Router.WETH();
        path[1] = token;
        _Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(0, path, address(recipient), block.timestamp); 
        amountbnb = address(this).balance;
    }

    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}