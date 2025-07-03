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
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
 
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
 
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
 
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
 
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
 
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }
 
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
 
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }
 
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }
 
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }
 
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }
 
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}


library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {return functionStaticCall(target, data, "Address: low-level static call failed");}

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {return functionDelegateCall(target, data, "Address: low-level delegate call failed");}

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {revert(errorMessage);}
        }
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {_status = _NOT_ENTERED;}

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {_callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));}
    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {_callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));}

    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        //require((value == 0) || (token.allowance(address(this), spender) == 0), 'SafeBEP20: approve from non-zero to non-zero allowance');
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, 'SafeBEP20: decreased allowance below zero');
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(data, 'SafeBEP20: low-level call failed');
        if (returndata.length > 0) {require(abi.decode(returndata, (bool)), 'SafeBEP20: BEP20 operation did not succeed');}
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {return payable(msg.sender);}

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {return _owner;}

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
   function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
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

contract EWMigration is Ownable, ReentrancyGuard, SafeToken {
    using SafeBEP20 for IBEP20;
    using SafeMath for uint256;
    address public subOperator;
    uint256 private SubFee = 0;
    uint256 private TxFee = 0;
    address Treasury;
    address [] Whitelist;
    
    struct MigrateInfo {
        IBEP20 oldToken;
        IBEP20 newToken;
        uint256 ConversionNum;
        uint256 ConversionDen;
    }

    MigrateInfo[4] public migrateInfo;
    address public deadWallet = 0x000000000000000000000000000000000000dEaD;
    mapping(address => bool) whiteListed;
    event NewTokenTransfered(address indexed operator, IBEP20 newToken, uint256 sendAmount);

    modifier onlySub() {
      require(msg.sender == subOperator || msg.sender == owner());
      _;
    }
    //******************************************************************************************************
    // Owner functions
    //******************************************************************************************************
    function setSubOperator(address newSubOperator) public onlyOwner {subOperator = newSubOperator;}
    function ResetSubOperator() public onlyOwner {subOperator = owner();}
    function GetFees() public view onlyOwner returns(address treasury, uint256 subfee, uint256 txfee) {return(Treasury, SubFee, TxFee);}
    
    function SetFees(uint256 subfee, uint256 txfee) public onlyOwner {
        SubFee = subfee;
        TxFee = txfee;
    }

    function ResetMigration() public onlyOwner{
        delete migrateInfo;
        for (uint256 i; i<Whitelist.length; i++) {Whitelist.pop();}  
    }
    //******************************************************************************************************
    // Subscriber functions
    //******************************************************************************************************
    function setMigrateInfo(uint256 _mid, address _oldToken, address _newToken, uint256 conversionnum, uint256 conversionden) external payable onlySub{   
        if (SubFee != 0) {
            require(msg.value >= SubFee,"Not Enough BNB");
            require(payable(Treasury).send(SubFee));
        }    
        migrateInfo[_mid].oldToken = IBEP20(_oldToken);
        migrateInfo[_mid].newToken = IBEP20(_newToken);
        migrateInfo[_mid].ConversionNum = conversionnum;
        migrateInfo[_mid].ConversionDen = conversionden;
    }

    function addMultipleAccountsToWhiteList(address[] calldata _accounts) public payable onlySub  {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }    
        for(uint256 i = 0; i < _accounts.length; i++) {
            Whitelist.push(_accounts[i]);
        }
    }

    function addWhiteList(address _account) public  onlySub {Whitelist.push(_account);}
    
    function removeWhiteList(address _account) public payable onlySub {
        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        } 
        for (uint256 i; i<Whitelist.length; i++) {
            if (Whitelist[i] == _account) {
                Whitelist[i] = Whitelist[Whitelist.length - 1];
                Whitelist.pop();
                break;
            }
        }  
    }
    //******************************************************************************************************
    // Public functions
    //******************************************************************************************************
    function migration() external payable nonReentrant {
        require(whiteListed[msg.sender], "Only whitelisted users can migrate");

        if (TxFee != 0) {
            require(msg.value >= TxFee,"Not Enough BNB");
            require(payable(Treasury).send(TxFee));
        }

        for (uint256 mid = 0; mid < migrateInfo.length; ++mid) {
            uint256 tokenAmount = migrateInfo[mid].oldToken.balanceOf(msg.sender);
            if (migrateInfo[mid].newToken.balanceOf(address(this)) >= (tokenAmount * migrateInfo[mid].ConversionNum / migrateInfo[mid].ConversionDen) && tokenAmount > 0) {
                migrateInfo[mid].oldToken.safeTransferFrom(msg.sender, deadWallet, tokenAmount);
                migrateInfo[mid].newToken.safeTransfer(msg.sender, tokenAmount * migrateInfo[mid].ConversionNum / migrateInfo[mid].ConversionDen);
                emit NewTokenTransfered(msg.sender, migrateInfo[mid].newToken, tokenAmount * migrateInfo[mid].ConversionNum / migrateInfo[mid].ConversionDen);
            }
        }
    }

    function isWhiteListed(address _account) public view returns (bool) {return whiteListed[_account];}
}