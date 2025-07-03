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

library Address {
 
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    assembly {size := extcodesize(account)} return size > 0;
  }

  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, 'Address: insufficient balance');
    (bool success, ) = recipient.call{ value: amount }('');
    require(success, 'Address: unable to send value, recipient may have reverted');
  }

  function functionCall(address target, bytes memory data) internal returns (bytes memory)
  {
    return functionCall(target, data, 'Address: low-level call failed');
  }

  function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
    return functionCallWithValue(target, data, 0, errorMessage);
  }

  function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
    return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
  }

  function functionCallWithValue(
    address target,
    bytes memory data,
    uint256 value,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(
      address(this).balance >= value,
      'Address: insufficient balance for call'
    );
    require(isContract(target), 'Address: call to non-contract');

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.call{ value: value }(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function functionStaticCall(address target, bytes memory data)
    internal
    view
    returns (bytes memory)
  {
    return
      functionStaticCall(target, data, 'Address: low-level static call failed');
  }

  function functionStaticCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal view returns (bytes memory) {
    require(isContract(target), 'Address: static call to non-contract');

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.staticcall(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function functionDelegateCall(address target, bytes memory data)
    internal
    returns (bytes memory)
  {
    return
      functionDelegateCall(
        target,
        data,
        'Address: low-level delegate call failed'
      );
  }

  function functionDelegateCall(
    address target,
    bytes memory data,
    string memory errorMessage
  ) internal returns (bytes memory) {
    require(isContract(target), 'Address: delegate call to non-contract');

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.delegatecall(data);
    return _verifyCallResult(success, returndata, errorMessage);
  }

  function _verifyCallResult(
    bool success,
    bytes memory returndata,
    string memory errorMessage
  ) private pure returns (bytes memory) {
    if (success) {
      return returndata;
    } else {
      // Look for revert reason and bubble it up if present
      if (returndata.length > 0) {assembly {let returndata_size := mload(returndata) revert(add(32, returndata), returndata_size)}
      } else {
        revert(errorMessage);
      }
    }
  }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {return payable(msg.sender);}
 
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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

abstract contract SharedOwnable is Ownable {
    address private _creator;
    mapping(address => bool) private _sharedOwners;
    event SharedOwnershipAdded(address indexed sharedOwner);

    constructor() Ownable() {
        _creator = msg.sender;
        _setSharedOwner(msg.sender);
        renounceOwnership();
    }
    modifier onlySharedOwners() {require(_sharedOwners[msg.sender], "SharedOwnable: caller is not a shared owner"); _;}
    function getCreator() external view returns (address) {return _creator;}
    function isSharedOwner(address account) external view returns (bool) {return _sharedOwners[account];}
    function setSharedOwner(address account) internal onlySharedOwners {_setSharedOwner(account);}
    function _setSharedOwner(address account) private {_sharedOwners[account] = true; emit SharedOwnershipAdded(account);}
    function EraseSharedOwner(address account) internal onlySharedOwners {_eraseSharedOwner(account);}
    function _eraseSharedOwner(address account) private {_sharedOwners[account] = false;}
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
 
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
 
interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
 
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
 
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
 
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
 
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
 
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
    event Sync(uint112 reserve0, uint112 reserve1);
 
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
 
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}
 
interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline ) external returns (uint amountA, uint amountB, uint liquidity); 
    function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external payable returns (uint amountToken, uint amountETH, uint liquidity); 
    function removeLiquidity( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline ) external returns (uint amountA, uint amountB); 
    function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external returns (uint amountToken, uint amountETH); 
    function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountA, uint amountB); 
    function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountToken, uint amountETH); 
    function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts); 
    function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts); 
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts); 
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts); 
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts); 
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts); 
 
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
 
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external returns (uint amountETH); 
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountETH); 
    function swapExactTokensForTokensSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external; 
    function swapExactETHForTokensSupportingFeeOnTransferTokens( uint amountOutMin, address[] calldata path, address to, uint deadline ) external payable; 
    function swapExactTokensForETHSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external; 
}

contract SafeToken is SharedOwnable {
    address payable safeManager;
    constructor() {safeManager = payable(msg.sender);}
    function setSafeManager(address payable _safeManager) public onlySharedOwners {safeManager = _safeManager;}
    function withdraw(address _token, uint256 _amount) external { require(msg.sender == safeManager); IBEP20(_token).transfer(safeManager, _amount);}
    function withdrawBNB(uint256 _amount) external {require(msg.sender == safeManager); safeManager.transfer(_amount);}
}

contract Main is Context, IBEP20, SharedOwnable, SafeToken {
  using SafeMath for uint256;
  using Address for address;

  mapping(address => uint256) private _rOwned;
  mapping(address => uint256) private _tOwned;
  mapping(address => mapping(address => uint256)) private _allowances;

  mapping(address => bool) private _isExcludedFromFees;
  mapping(address => bool) private _isExcludedFromMaxTx; //Adding this for the dxsale/unicrypt presale, the router needs to be exempt from max tx amount limit.
  mapping(address => bool) private _isExcluded; //from reflections
  mapping(address => bool) private _isBlacklisted; //blacklist function
  mapping(address => bool) private _isWhitelisted;
  mapping (address => uint256) private LastTimeSell; 
  address[] private _excluded;
  address [] List; 

  uint256 private constant MAX = ~uint256(0);
  uint256 private _tTotal;
  uint256 private _rTotal;
  uint256 private _tFeeTotal;
  string private _name ;
  string private _symbol;
  uint8 private decimal;
  uint256 private _liquidityUnlockTime = 0;
  uint256 private counter;
  uint256 private MinTime = 0;

  uint256 private MaxSell;
  uint256 private MaxWallet;
  uint256 private SwapMin;
  uint256 private MaxSwap;
  uint256 private MaxTaxes;
  uint256 private maxSellTransactionAmount; // max sell 1% of supply
  uint256 private maxWalletAmount; // max wallet amount 2%
  uint256 private swapTokensAtAmount;
  uint256 private MaxTokenToSwap;

  uint256 private _taxFee;
  uint256 private _liquidityFee;
  uint256 private _marketingFee;
  uint256 private _teamFee;
  uint256 private _multiuseFee;
  uint256 private _stakingFee;
  uint256 private _burnFee;
   
  uint256 private _previousTaxFee = _taxFee;
  uint256 private _previousLiquidityFee = _liquidityFee;
  uint256 private _previousMarketingFee = _marketingFee;
  uint256 private _previousTeamFee = _teamFee;
  uint256 private _previousMultiUseFee = _multiuseFee;
  uint256 private _previousStakingFee = _stakingFee;
  uint256 private _previousBurnFee = _burnFee;

  uint256 private burnFeeBuy = 1;
  uint256 private marketingFeeBuy = 2;
  uint256 private teamFeeBuy = 0;
  uint256 private multiuseFeeBuy = 0;
  uint256 private stakingFeeBuy = 0;
  uint256 private liquidityFeeBuy = 2;
  uint256 private reflectFeeBuy = 1;

  uint256 private burnFeeSell = 1;
  uint256 private marketingFeeSell = 3;
  uint256 private teamFeeSell = 0;
  uint256 private multiuseFeeSell = 0;
  uint256 private stakingFeeSell = 0;
  uint256 private liquidityFeeSell = 3;
  uint256 private reflectFeeSell = 1;
  
  address payable private MarketingWallet; 
  address payable private TeamWallet; 
  address payable private MultiUseWallet; 
  address payable private StakingWallet;
  address private DeadWallet;

  IUniswapV2Router02 public immutable uniswapV2Router;
  address public immutable uniswapV2Pair;
  address private PancakeRouter;

  bool inSwapAndLiquify;
  bool public swapAndLiquifyEnabled = true;
  bool public walletTowalletFee = false;
  bool public tradingEnabled = false;
  bool private DelayOption = false;

  event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
  event SwapAndLiquifyEnabledUpdated(bool enabled);
  event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
  event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
  event ExtendLiquidityLock(uint256 extendedLockTime);
 
  modifier lockTheSwap() {
    inSwapAndLiquify = true;
    _;
    inSwapAndLiquify = false;
  }

    constructor(string memory name_, string memory symbol_, uint8 decimal_, address marketing_, address team_, address multiuse_, uint256 supply_, uint8 maxtaxes_) {
    decimal = decimal_;
    _tTotal = supply_ * 10**decimal; //100 Million
    _rTotal = (MAX - (MAX % _tTotal));
    _rOwned[msg.sender] = _rTotal;

    _name = name_;
    _symbol = symbol_;

    MarketingWallet = payable(marketing_);
    TeamWallet = payable(team_); 
    MultiUseWallet = payable(multiuse_);
    StakingWallet = payable(marketing_);
    DeadWallet = 0x000000000000000000000000000000000000dEaD;
    
    MaxSell = supply_;
    MaxWallet = supply_;
    SwapMin = supply_ * 1 / 1000;
    MaxSwap = supply_ * 1 / 100;
    maxSellTransactionAmount = MaxSell * 10**decimal; // max sell 
    maxWalletAmount = MaxWallet * 10**decimal; // max wallet amount 
    swapTokensAtAmount = SwapMin * 10**decimal;
    MaxTokenToSwap = MaxSwap*10**decimal;
    maxSellTransactionAmount = MaxSell * 10**decimal; // max sell 1% of supply
    maxWalletAmount = MaxWallet * 10**decimal; // max wallet amount 2%
    swapTokensAtAmount = SwapMin * 10**decimal;
    MaxTaxes = maxtaxes_;

    if (block.chainid == 56) {
      PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; //BSC PANCAKE PROD
    } else if (block.chainid == 97) {
      PancakeRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3; // BSC PANCAKE TEST
    } else revert();

    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(PancakeRouter);
    uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
    uniswapV2Router = _uniswapV2Router;

    //Exclude owner, marketing and contract from fee and limits
    _isExcludedFromFees[address(this)] = true;
    _isExcludedFromMaxTx[address(this)] = true;
    _isExcluded[address(this)] = true;
    _excluded.push(address(this));
    _isWhitelisted[address(this)] = true;

    _isExcludedFromFees[msg.sender] = true;
    _isExcludedFromMaxTx[msg.sender] = true;
    _isWhitelisted[msg.sender] = true;

    _isExcludedFromFees[MarketingWallet] = true;
    _isExcludedFromMaxTx[MarketingWallet] = true;
    _isWhitelisted[MarketingWallet] = true;

    _isExcludedFromFees[TeamWallet] = true;
    _isExcludedFromMaxTx[TeamWallet] = true;
    _isWhitelisted[TeamWallet] = true;

    _isExcludedFromMaxTx[MultiUseWallet] = true;
    _isExcludedFromFees[MultiUseWallet] = true;
    _isWhitelisted[MultiUseWallet] = true;

    _isExcludedFromMaxTx[StakingWallet] = true;
    _isExcludedFromFees[StakingWallet] = true;
    _isWhitelisted[StakingWallet] = true;

    emit Transfer(address(0), msg.sender, _tTotal);
  }

  receive() external payable {}

  struct tVector {
    uint256 tTransferAmount;
    uint256 tFee;
    uint256 tLiquidity;
    uint256 tMarketing;
  }

  struct rVector {
    uint256 rAmount;
    uint256 rTransferAmount;
    uint256 rFee;
  }
  //******************************************************************************************************
  // Public functions
  //******************************************************************************************************
  function name() public view returns (string memory) {return _name;}
  function symbol() public view returns (string memory) {return _symbol;}
  function decimals() public view returns (uint8) {return decimal;}
  function totalSupply() public view override returns (uint256) {return _tTotal;}
  function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
  function approve(address spender, uint256 amount) public override returns (bool) {_approve(_msgSender(), spender, amount); return true;}
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {_approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue)); return true;}
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {_approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'decreased allowance below zero')); return true;}
  function totalFees() public view returns (uint256) {return _tFeeTotal;}
  function balanceOf(address account) public view override returns (uint256) {if (_isExcluded[account]) return _tOwned[account]; return tokenFromReflection(_rOwned[account]);}
  function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(_msgSender(), recipient, amount); return true;}
  
  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, 'transfer amount exceeds allowance')); 
    _transfer(sender, recipient, amount);
    return true;
  }

  function deliver(uint256 tAmount) public {
    address sender = _msgSender();
    require(!_isExcluded[sender], 'Excluded addresses cannot call this function');
    (uint256 rAmount, , , , , ) = _getValues(tAmount); //WORKSPACE ZZ
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _rTotal = _rTotal.sub(rAmount);
    _tFeeTotal = _tFeeTotal.add(tAmount);
  }

  function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
    require(tAmount <= _tTotal, 'Amount must be less than supply');
    if (!deductTransferFee) {
      (uint256 rAmount, , , , , ) = _getValues(tAmount); //WORKPLACE ZX
      return rAmount;
    } else {
      (, uint256 rTransferAmount, , , , ) = _getValues(tAmount); //WORKSPACE YY
      return rTransferAmount;
    }
  }

  function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
    require(rAmount <= _rTotal, 'Amount must be less than total reflections');
    uint256 currentRate = _getRate();
    return rAmount.div(currentRate);
  }

  function GetExclusion(address account) public view returns (bool _txLimit, bool _fee, bool _refl, bool BlackList, bool WhiteList) {return (_isExcludedFromMaxTx[account], _isExcludedFromFees[account], _isExcluded [account], _isBlacklisted[account], _isWhitelisted[account]);}
  function GetLimits() public view returns(uint256 SellMax, uint256 WalletMax, uint256 TaxMax, uint256 MinSwap, bool SwapLiq, bool ENtrading){return (MaxSell, MaxWallet, MaxTaxes, SwapMin, swapAndLiquifyEnabled, tradingEnabled);}
  function GetDelay() public view returns (bool delayoption, uint256 mintime) {return (DelayOption, MinTime);}
  function GetBuyFees() public view returns(uint bburn, uint bmarketing, uint bteam, uint bmultiuse, uint bstaking, uint bliquidity, uint breflect, bool wallet2wallet){return (burnFeeBuy, marketingFeeBuy, teamFeeBuy, multiuseFeeBuy, stakingFeeBuy, liquidityFeeBuy, reflectFeeBuy, walletTowalletFee);} 
  function GetSellFees() public view returns(uint sburn, uint smarketing, uint steam, uint smultiuse, uint sstaking, uint sliquidity, uint sreflect, bool wallet2wallet){return (burnFeeSell, marketingFeeSell, teamFeeSell, multiuseFeeSell, stakingFeeSell, liquidityFeeSell, reflectFeeSell, walletTowalletFee);} 
  function GetContractAddresses() public view returns(address marketing, address team, address multiuse, address staking, address Dead, address LP){return (address(MarketingWallet), address(TeamWallet), address(MultiUseWallet), address(StakingWallet), address(DeadWallet), address(uniswapV2Pair));}


  function getLiquidityUnlockTime() public view returns (uint256 Days, uint256 Hours, uint256 Minutes, uint256 Seconds) {
        if (block.timestamp < _liquidityUnlockTime){
            Days = (_liquidityUnlockTime - block.timestamp) / 86400;
            Hours = (_liquidityUnlockTime - block.timestamp - Days*86400) / 3600;
            Minutes = (_liquidityUnlockTime - block.timestamp - Days*86400 - Hours*3600 ) / 60;
            Seconds = _liquidityUnlockTime - block.timestamp - Days*86400 - Hours*3600 - Minutes*60;

            return (Days, Hours, Minutes, Seconds);}
        return (0, 0, 0, 0);
  }
  //******************************************************************************************************
  // Write OnlyOwners functions
  //******************************************************************************************************
  function AddSharedOwner(address account) public onlySharedOwners {
    setSharedOwner(account);
    _isExcludedFromFees[address(account)] = true;
    _isExcludedFromMaxTx[address(account)] = true;
    _isWhitelisted[address(account)] = true;
  }

  function RemoveharedOwner(address account) public onlySharedOwners {
    EraseSharedOwner(account);
    _isExcludedFromFees[address(account)] = false;
    _isExcludedFromMaxTx[address(account)] = false;
    _isWhitelisted[address(account)] = false;
  }
  
  function excludeFromReward(address account) public onlySharedOwners {
    require(!_isExcluded[account], 'Account already excluded');
    if (_rOwned[account] > 0) {_tOwned[account] = tokenFromReflection(_rOwned[account]);}
    _isExcluded[account] = true;
    _excluded.push(account);
  }

  function includeInReward(address account) external onlySharedOwners {
    require(_isExcluded[account], 'Account is already included');
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_excluded[i] == account) {
        _excluded[i] = _excluded[_excluded.length - 1];
        _tOwned[account] = 0;
        _isExcluded[account] = false;
        _excluded.pop();
        break;
      }
    }
  }

  function SetExclusion(address account, bool _txLimit, bool _fee, bool BlackList, bool WhiteList) public onlySharedOwners {
    _isExcludedFromMaxTx[account] = _txLimit;
    _isExcludedFromFees[account] = _fee;
    _isBlacklisted [account] = BlackList;
    _isWhitelisted [account] = WhiteList;
  }

  function SetDelay (bool delayoption, uint256 mintime) external onlySharedOwners {
    require(mintime <= 28800, "MinTime Can't be more than a Day" );
    MinTime = mintime;
    DelayOption = delayoption;
  }

  function SetLimits(uint256 _maxWallet, uint256 _maxSell, uint256 _minswap, uint256 _swapmax, uint256 MaxTax, bool _swapAndLiquifyEnabled) public onlySharedOwners {
    uint256 supply = _tTotal;
    require(_maxWallet * 10**decimal >= supply / 100 && _maxWallet * 10**decimal <= supply, "MawWallet must be between totalsupply and 1% of totalsupply");
    require(_maxSell * 10**decimal >= supply / 1000 && _maxSell * 10**decimal <= supply, "MawSell must be between totalsupply and 0.1% of totalsupply" );
    require(_minswap * 10**decimal >= supply / 10000 && _minswap * 10**decimal <= _swapmax / 2, "MinSwap must be between maxswap/2 and 0.01% of totalsupply" );
    require(MaxTax >= 1 && MaxTax <= 25, "Max Tax must be updated to between 1 and 25 percent");
    require(_swapmax >= _minswap.mul(2) && _swapmax * 10**decimal <= supply, "MaxSwap must be between totalsupply and SwapMin x 2" );
        
    MaxSwap = _swapmax;
    MaxTokenToSwap = MaxSwap * 10**decimal;
    MaxWallet = _maxWallet;
    maxWalletAmount = MaxWallet * 10**decimal;
    MaxSell = _maxSell;
    maxSellTransactionAmount = MaxSell * 10**decimal;
    SwapMin = _minswap;
    swapTokensAtAmount = SwapMin * 10**decimal;
    MaxTaxes = MaxTax;
       
    swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
    emit SwapAndLiquifyEnabledUpdated(_swapAndLiquifyEnabled);
  }

  function setProjectWallet (address payable _newMarketingWallet, address payable _newTeamWallet, address payable _newMultiUseWallet, address payable _newStakingWallet) external onlySharedOwners {
    if (_newMarketingWallet != MarketingWallet) {
      _isExcludedFromFees[MarketingWallet] = false;
      _isExcludedFromMaxTx[MarketingWallet] = false;
      _isWhitelisted[MarketingWallet] = false;
               
      _isExcludedFromFees[_newMarketingWallet] = true;
      _isExcludedFromMaxTx[_newMarketingWallet] = true;
      _isWhitelisted[_newMarketingWallet] = true;
      MarketingWallet = _newMarketingWallet;
    }
    if (_newTeamWallet != TeamWallet) {
      _isExcludedFromFees[TeamWallet] = false;
      _isExcludedFromMaxTx[TeamWallet] = false;
      _isWhitelisted[TeamWallet] = false;
                     
      _isExcludedFromFees[_newTeamWallet] = true;
      _isExcludedFromMaxTx[_newTeamWallet] = true;
      _isWhitelisted[_newTeamWallet] = true;
      TeamWallet = _newTeamWallet;
    }
    if (_newMultiUseWallet != MultiUseWallet) {
      _isExcludedFromFees[MultiUseWallet] = false;
      _isExcludedFromMaxTx[MultiUseWallet] = false;
      _isWhitelisted[MultiUseWallet] = false;
                       
      _isExcludedFromFees[_newMultiUseWallet] = true;
      _isExcludedFromMaxTx[_newMultiUseWallet] = true;
      _isWhitelisted[_newMultiUseWallet] = true;
      MultiUseWallet = _newMultiUseWallet;
    }
    if (_newStakingWallet != StakingWallet) {
      _isExcludedFromFees[StakingWallet] = false;
      _isExcludedFromMaxTx[StakingWallet] = false;
      _isWhitelisted[StakingWallet] = false;
                       
      _isExcludedFromFees[_newStakingWallet] = true;
      _isExcludedFromMaxTx[_newStakingWallet] = true;
      _isWhitelisted[_newStakingWallet] = true;
      StakingWallet = _newStakingWallet;
    }
  }

  function setBuyFees (uint bburn, uint bmarketing, uint bteam, uint bmultiuse, uint bstaking, uint bliquidity, uint breflect, bool wallet2wallet) public onlySharedOwners {
    require(bburn + bmarketing + bteam + bmultiuse + bliquidity + breflect <= MaxTaxes, "max 25%");
    burnFeeBuy = bburn;
    marketingFeeBuy = bmarketing;
    teamFeeBuy = bteam;
    multiuseFeeBuy = bmultiuse;
    stakingFeeBuy = bstaking;
    liquidityFeeBuy = bliquidity;
    reflectFeeBuy = breflect;
    walletTowalletFee = wallet2wallet;
  }

  function setSellFees (uint sburn, uint smarketing, uint steam, uint smultiuse, uint sstaking, uint sliquidity, uint sreflect, bool wallet2wallet) public onlySharedOwners {
    require(sburn + smarketing + steam + smultiuse + sliquidity + sreflect <= MaxTaxes, "max 25%");
    burnFeeSell = sburn;
    marketingFeeSell = smarketing;
    teamFeeSell = steam;
    multiuseFeeSell = smultiuse;
    stakingFeeSell = sstaking;
    liquidityFeeSell = sliquidity;
    reflectFeeSell = sreflect;
    walletTowalletFee = wallet2wallet;
  }
  
  function ExtendLockTime(uint256 newdays, uint256 newhours) public onlySharedOwners {
    uint256 lockTimeInSeconds = newdays*86400 + newhours*3600;
    setUnlockTime(lockTimeInSeconds + _liquidityUnlockTime);
    emit ExtendLiquidityLock(lockTimeInSeconds);
  }

  function CreateLP(uint256 tokenAmount, uint256 bnbAmount, uint256 lockTimeInDays, uint256 lockTimeInHours) public onlySharedOwners {
    uint256 lockTimeInSeconds = lockTimeInDays*86400 + lockTimeInHours*3600;
    _liquidityUnlockTime = block.timestamp + lockTimeInSeconds;
    uint256 token = tokenAmount*10**decimal;
    uint256 bnb = bnbAmount*10**18;
    addLiquidity(token, bnb);
  }

  function ReleaseLP() public onlySharedOwners {
    require(block.timestamp >= _liquidityUnlockTime, "Not yet unlocked");
    IBEP20 liquidityToken = IBEP20(uniswapV2Pair);
    uint256 amount = liquidityToken.balanceOf(address(this));
    liquidityToken.transfer(msg.sender, amount);
  }

  function GetList() external view onlySharedOwners returns (uint number, address [] memory) {
    number = List.length;
    return (number, List);
  }
  
  function enableTrading(uint256 Blocks) external onlySharedOwners {
    require(!tradingEnabled, "Trading is already enabled");
    require(Blocks <= 40, "Not more than 2mn");
    tradingEnabled = true;
    counter = block.number + Blocks;
  }
  //******************************************************************************************************
  // Internal functions
  //******************************************************************************************************
  function setBuyFees() private {
    _previousBurnFee = _burnFee;
    _previousLiquidityFee = _liquidityFee;
    _previousMarketingFee = _marketingFee;
    _previousTeamFee = _teamFee;
    _previousMultiUseFee = _multiuseFee;
    _previousStakingFee = _stakingFee;
    _previousTaxFee = _taxFee;
    
    _burnFee = burnFeeBuy;
    _liquidityFee = liquidityFeeBuy;
    _marketingFee = marketingFeeBuy;
    _teamFee = teamFeeBuy;
    _multiuseFee = multiuseFeeBuy;
    _stakingFee = stakingFeeBuy;
    _taxFee = reflectFeeBuy;
  }

  function setSellFees() private {
    _previousBurnFee = _burnFee;
    _previousLiquidityFee = _liquidityFee;
    _previousMarketingFee = _marketingFee;
    _previousTeamFee = _teamFee;
    _previousMultiUseFee = _multiuseFee;
    _previousStakingFee = _stakingFee;
    _previousTaxFee = _taxFee;
    
    _burnFee = burnFeeSell;
    _liquidityFee = liquidityFeeSell;
    _marketingFee = marketingFeeSell;
    _teamFee = teamFeeSell;
    _multiuseFee = multiuseFeeSell;
    _stakingFee = stakingFeeSell;
    _taxFee = reflectFeeSell;
  }
  	
  function _reflectFee(uint256 rFee, uint256 tFee) private {
    _rTotal = _rTotal.sub(rFee);
    _tFeeTotal = _tFeeTotal.add(tFee);
  }

  function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
    tVector memory my_tVector;
    rVector memory my_rVector;
    {
      (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
      my_tVector.tTransferAmount = tTransferAmount;
      my_tVector.tFee = tFee;
      my_tVector.tLiquidity = tLiquidity;
    }
    {
      (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, my_tVector.tFee, my_tVector.tLiquidity, _getRate());
      my_rVector.rAmount = rAmount;
      my_rVector.rTransferAmount = rTransferAmount;
      my_rVector.rFee = rFee;
    }
    return (my_rVector.rAmount, my_rVector.rTransferAmount, my_rVector.rFee, my_tVector.tTransferAmount, my_tVector.tFee, my_tVector.tLiquidity);
  }

  function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
    uint256 tFee = calculateTaxFee(tAmount);
    uint256 tLiquidity = calculateLiquidityFee(tAmount);
    uint256 tTransferAmount = tAmount.sub(tFee);
    tTransferAmount = tTransferAmount.sub(tLiquidity);
    return (tTransferAmount, tFee, tLiquidity);
  }

  function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
    uint256 rAmount = tAmount.mul(currentRate);
    uint256 rTransferAmount;
    uint256 rFee;
    {
      rFee = tFee.mul(currentRate);
      uint256 rLiquidity = tLiquidity.mul(currentRate);
      rTransferAmount = rAmount.sub(rFee);
      rTransferAmount = rTransferAmount.sub(rLiquidity);
    }
    return (rAmount, rTransferAmount, rFee);
  }

  function _getRate() private view returns (uint256) {
    (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
    return rSupply.div(tSupply);
  }

  function _getCurrentSupply() private view returns (uint256, uint256) {
    uint256 rSupply = _rTotal;
    uint256 tSupply = _tTotal;
    for (uint256 i = 0; i < _excluded.length; i++) {
      if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
      rSupply = rSupply.sub(_rOwned[_excluded[i]]);
      tSupply = tSupply.sub(_tOwned[_excluded[i]]);
    }
    if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
    return (rSupply, tSupply);
  }

  function _takeLiquidity(uint256 tLiquidity) private {
    uint256 currentRate = _getRate();
    uint256 rLiquidity = tLiquidity.mul(currentRate);
    _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
    if (_isExcluded[address(this)])
      _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
  }

  function calculateTaxFee(uint256 _amount) private view returns (uint256) {
    uint256 this_taxFee = _taxFee;
    return _amount.mul(this_taxFee).div(100);
  }

  function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {return _amount.mul(_liquidityFee.add(_marketingFee).add(_teamFee).add(_multiuseFee).add(_stakingFee).add(_burnFee)).div(100);}
  
  function removeAllFee() private {
    if (_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;

    _previousTaxFee = _taxFee;
    _previousMarketingFee = _marketingFee;
    _previousTeamFee = _teamFee;
    _previousMultiUseFee = _multiuseFee;
    _previousStakingFee = _stakingFee;
    _previousLiquidityFee = _liquidityFee;
    _previousBurnFee = _burnFee;
    
    _taxFee = 0;
    _burnFee = 0;
    _marketingFee = 0;
    _teamFee = 0;
    _multiuseFee = 0;
    _stakingFee = 0;
    _liquidityFee = 0;
  }

  function restoreAllFee() private {
    _taxFee = _previousTaxFee;
    _marketingFee = _previousMarketingFee;
    _teamFee  = _previousTeamFee;
    _multiuseFee = _previousMultiUseFee;
    _stakingFee = _previousStakingFee;
    _liquidityFee = _previousLiquidityFee;
    _burnFee = _previousBurnFee;
  }

  function _approve(address owner, address spender, uint256 amount) private {
    require(owner != address(0), 'approve from the zero address');
    require(spender != address(0), 'approve to the zero address');
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _transfer(address from, address to, uint256 amount) private {
    require(from != address(0), 'transfer from the zero address');
    require(to != address(0), 'transfer to the zero address');
    if(to != address(this) && to != DeadWallet) require(!_isBlacklisted[from] && !_isBlacklisted[to] , "Blacklisted address"); //blacklist function
    // preparation of launch LP and token dispatch allowed even if trading not allowed
    if(!tradingEnabled) {require(_isWhitelisted[from], "Trading not allowed yet");}
    if(tradingEnabled && block.number < counter && !_isWhitelisted[to]) {
      _isBlacklisted[to] = true;
      List.push(to);  
      excludeFromReward(address(to));
    }
    if(!_isWhitelisted[to] && from == uniswapV2Pair){
      if(to != address(this) && to != DeadWallet){
        uint256 heldTokens = balanceOf(to);
        require((heldTokens + amount) <= maxWalletAmount, "wallet amount exceed maxWalletAmount");
      }
    }
    if(amount == 0) {return;}
    // Max sell limitation
    if(to == uniswapV2Pair && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");}

    if (DelayOption && !_isWhitelisted[from] && to == uniswapV2Pair) {
      require( LastTimeSell[from] + MinTime <= block.number, "Trying to sell too often!");
      LastTimeSell[from] = block.number;
    }
    
    uint256 contractTokenBalance = balanceOf(address(this));
    bool canSwap = contractTokenBalance >= swapTokensAtAmount;
    if(contractTokenBalance >= MaxTokenToSwap){contractTokenBalance = MaxTokenToSwap;}
    if (swapAndLiquifyEnabled && canSwap && !inSwapAndLiquify && from != uniswapV2Pair && !_isWhitelisted[from] && !_isWhitelisted[to]) {
      setSellFees();
      inSwapAndLiquify = true;
      swapAndLiquify(contractTokenBalance);
      restoreAllFee();
      inSwapAndLiquify = false;
    }
    bool takeFee = true;
    bool purchaseOrSale = false;
    if ((to == uniswapV2Pair) || (from == uniswapV2Pair)) {purchaseOrSale = true;}
    if (!purchaseOrSale && !walletTowalletFee) {takeFee = false;}
    if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {takeFee = false;}
    _tokenTransfer(from, to, amount, takeFee);
  }

  function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
    uint256 TotalFees = _marketingFee.add(_teamFee).add(_multiuseFee).add(_stakingFee).add(_liquidityFee).add(_burnFee);
    uint256 marketingBalance = contractTokenBalance.mul(_marketingFee).div(TotalFees);
    uint256 teamBalance = contractTokenBalance.mul(_teamFee).div(TotalFees);
    uint256 multiuseBalance = contractTokenBalance.mul(_multiuseFee).div(TotalFees);
    uint256 stakingBalance = contractTokenBalance.mul(_stakingFee).div(TotalFees);
    uint burnBal = contractTokenBalance.mul(_burnFee).div(TotalFees);
    uint256 liquidityBalance = contractTokenBalance.sub(marketingBalance).sub(teamBalance).sub(multiuseBalance).sub(burnBal);

    uint256 half = liquidityBalance.div(2);
    uint256 otherHalf = liquidityBalance.sub(half);
    uint256 tokensToSwapForETH = half.add(marketingBalance).add(teamBalance).add(multiuseBalance);
    
    uint256 initialBalance = address(this).balance;
    swapTokensForEth(tokensToSwapForETH); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
    uint256 newBalance = address(this).balance.sub(initialBalance);
    if(_burnFee != 0) {_transfer(address(this), DeadWallet, burnBal);}
    if(_stakingFee != 0) {_transfer(address(this), StakingWallet, stakingBalance);}
    if(_marketingFee != 0) {
      uint256 marketingETHBalance = newBalance.mul(marketingBalance).div(tokensToSwapForETH);
      payable(MarketingWallet).transfer(marketingETHBalance);}
    if(_teamFee != 0) {
      uint256 teamETHBalance = newBalance.mul(teamBalance).div(tokensToSwapForETH);
      payable(TeamWallet).transfer(teamETHBalance);}
    if(_multiuseFee != 0) {
      uint256 multiuseETHBalance = newBalance.mul(multiuseBalance).div(tokensToSwapForETH);
      payable(MultiUseWallet).transfer(multiuseETHBalance);}
    if(_liquidityFee != 0) {      
      uint256 liquidityETHBalance = newBalance.mul(half).div(tokensToSwapForETH);
      addLiquidity(otherHalf, liquidityETHBalance);
      emit SwapAndLiquify(half, newBalance, otherHalf);
    }
  }

  function swapTokensForEth(uint256 tokenAmount) private {

    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();

    _approve(address(this), address(uniswapV2Router), tokenAmount);
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
  }

  function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
    _approve(address(this), address(uniswapV2Router), tokenAmount);
    uniswapV2Router.addLiquidityETH{ value: ethAmount } (address(this), tokenAmount, 0, 0, address(this), block.timestamp);
  }

  function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
    if (!takeFee) removeAllFee();
    if(takeFee && sender == uniswapV2Pair) {setBuyFees();} 
    else if(takeFee && recipient == uniswapV2Pair) {setSellFees();}

    if (_isExcluded[sender] && !_isExcluded[recipient]) {_transferFromExcluded(sender, recipient, amount);} 
    else if (!_isExcluded[sender] && _isExcluded[recipient]) {_transferToExcluded(sender, recipient, amount);} 
    else if (!_isExcluded[sender] && !_isExcluded[recipient]) {_transferStandard(sender, recipient, amount);} 
    else if (_isExcluded[sender] && _isExcluded[recipient]) {_transferBothExcluded(sender, recipient, amount);} 
    else {_transferStandard(sender, recipient, amount);}

    if(takeFee && (sender == uniswapV2Pair || recipient == uniswapV2Pair)) {restoreAllFee();}
    if (!takeFee) restoreAllFee();
  }

  function _transferStandard(address sender, address recipient, uint256 tAmount) private {
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount); //WORKPLACE Z
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    _takeLiquidity(tLiquidity);
    _reflectFee(rFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount); //WORKSPACE Y
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
    _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    _takeLiquidity(tLiquidity);
    _reflectFee(rFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount); //WORKSPACE X
    _tOwned[sender] = _tOwned[sender].sub(tAmount);
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    _takeLiquidity(tLiquidity);
    _reflectFee(rFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
    (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount); //WORKSPACE XX
    _tOwned[sender] = _tOwned[sender].sub(tAmount);
    _rOwned[sender] = _rOwned[sender].sub(rAmount);
    _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
    _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
    _takeLiquidity(tLiquidity);
    _reflectFee(rFee, tFee);
    emit Transfer(sender, recipient, tTransferAmount);
  }

  function setUnlockTime(uint256 newUnlockTime) private {
        // require new unlock time to be longer than old one
        require(newUnlockTime > _liquidityUnlockTime);
        _liquidityUnlockTime = newUnlockTime;
  }
}

contract CryptoJunkie is Main {

    constructor() Main(
        "Crypto Junkie Tee",       // Name
        "CJT",        // Symbol
        9,                  // Decimal
        0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F,     // Marketing address
        0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F,     // Team address
        0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F,     // Multi Use address
        100000000,      // Initial Supply
        25     // Max Tax
        ) {} 
}
 