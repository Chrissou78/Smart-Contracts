// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

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

contract SafeToken is Ownable {
    address payable safeManager;

    constructor() {
        safeManager = payable(msg.sender);
    }

    function setSafeManager(address payable _safeManager) public onlyOwner {
        safeManager = _safeManager;
    }

    function withdraw(address _token, uint256 _amount) external {
        require(msg.sender == safeManager);
        IBEP20(_token).transfer(safeManager, _amount);
    }

    function withdrawBNB(uint256 _amount) external {
        require(msg.sender == safeManager);
        safeManager.transfer(_amount);
    }
}

contract AutoReflectionEnhanced is Context, IBEP20, Ownable, SafeToken {
  using SafeMath for uint256;
  using Address for address;

  mapping(address => uint256) private _rOwned;
  mapping(address => uint256) private _tOwned;
  mapping(address => mapping(address => uint256)) private _allowances;

  mapping(address => bool) private _isExcludedFromFee;
  mapping(address => bool) private _isExcludedFromTxLimit; //Adding this for the dxsale/unicrypt presale, the router needs to be exempt from max tx amount limit.
  mapping(address => bool) _isExcludedFromMaxWalletLimit;
  mapping(address => bool) private _isExcluded; //from reflections
  mapping(address => bool) public _isBlacklisted; //blacklist function
  address[] private _excluded;

  uint256 private constant MAX = ~uint256(0);
  uint256 private _tTotal = 10**8 * 10**9; //100 Million
  uint256 private _rTotal = (MAX - (MAX % _tTotal));
  uint256 private _tFeeTotal;
  uint256 public maxWalletAmount = 6000000 * 10**9;
  string private _name = 'AutoReflectionEnhanced';
  string private _symbol = 'ARET';
  uint8 private _decimals = 9;

  uint256 private _taxFee;
  uint256 private _liquidityFee;
  uint256 private _marketingFee;
  uint256 private _burnFee;
   
  uint256 private _previousTaxFee = _taxFee;
  uint256 private _previousLiquidityFee = _liquidityFee;
  uint256 private _previousMarketingFee = _marketingFee;
  uint256 private _previousBurnFee = _burnFee;

  uint256 public burnFeeBuy = 2;
  uint256 public marketingFeeBuy = 2;
  uint256 public liquidityFeeBuy = 2;
  uint256 public reflectFeeBuy = 4;

  uint256 public burnFeeSell = 3;
  uint256 public marketingFeeSell = 3;
  uint256 public liquidityFeeSell = 3;
  uint256 public reflectFeeSell = 6;
  
  address payable public marketingWallet = payable(0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F); 
  address public _burnWallet = 0x000000000000000000000000000000000000dEaD;

  IUniswapV2Router02 public immutable uniswapV2Router;
  address public immutable UniswapV2Pair;
  address public PancakeRouter;

  bool inSwapAndLiquify;
  bool public swapAndLiquifyEnabled = true;
  bool public walletTowalletFee = false;

  uint256 public _maxTxAmount = 1000000 * 10**9; //1% (0.005x) of Total circulating supply
  uint256 private numTokensSellToAddToLiquidity = 50000 * 10**9; //0.05% min to liquify

  event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
  event SwapAndLiquifyEnabledUpdated(bool enabled);
  event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
  event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
 
  modifier lockTheSwap() {
    inSwapAndLiquify = true;
    _;
    inSwapAndLiquify = false;
  }

  constructor() {
    address _newOwner = 0x2Db96c4F203fBc13c98bBa428ba9E09B48543b0A;
    _rOwned[_newOwner] = _rTotal;

    if (block.chainid == 56) {
      PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    } else if (block.chainid == 97) {
      PancakeRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    } else revert();

    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(PancakeRouter);
    UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
    uniswapV2Router = _uniswapV2Router;

    //Exclude owner, marketing and contract from fee and limits
    _isExcludedFromFee[address(this)] = true;
    _isExcludedFromMaxWalletLimit[address(this)] = true;
    _isExcludedFromTxLimit[address(this)] = true;
    _isExcluded[address(this)] = true;
    _excluded.push(address(this));

    _isExcludedFromFee[_newOwner] = true;
    _isExcludedFromMaxWalletLimit[_newOwner] = true;
    _isExcludedFromTxLimit[_newOwner] = true;

    _isExcludedFromFee[marketingWallet] = true;
    _isExcludedFromMaxWalletLimit[marketingWallet] = true;
    _isExcludedFromTxLimit[marketingWallet] = true;

    emit Transfer(address(0), _newOwner, _tTotal);
  }

  function name() public view returns (string memory) {return _name;}
  function symbol() public view returns (string memory) {return _symbol;}
  function decimals() public view returns (uint8) {return _decimals;}
  function totalSupply() public view override returns (uint256) {return _tTotal;}

  function setMaxWalletAmount(uint val) public onlyOwner {
      require(val > 1000000 * 10**9, "Min wallet reached");
      maxWalletAmount = val;
  }

  function balanceOf(address account) public view override returns (uint256) {
    if (_isExcluded[account]) return _tOwned[account];
    return tokenFromReflection(_rOwned[account]);
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address owner, address spender) public view override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 amount) public override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, 'transfer amount exceeds allowance')); 
    _transfer(sender, recipient, amount);
    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue)); return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'decreased allowance below zero')); return true;
  }

  function isExcludedFromReward(address account) public view returns (bool) {return _isExcluded[account];}
  function totalFees() public view returns (uint256) {return _tFeeTotal;}

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

  function excludeFromReward(address account) public onlyOwner {
    require(!_isExcluded[account], 'Account already excluded');
    if (_rOwned[account] > 0) {
      _tOwned[account] = tokenFromReflection(_rOwned[account]);
    }
    _isExcluded[account] = true;
    _excluded.push(account);
  }

  function includeInReward(address account) external onlyOwner {
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

  function SetExclusion(address account, bool _txLimit, bool _maxWallet, bool _fee) public onlyOwner {
    _isExcludedFromTxLimit[account] = _txLimit;
    _isExcludedFromMaxWalletLimit[account] = _maxWallet;
    _isExcludedFromFee[account] = _fee;
  }

  function AskExclusion(address account) public view returns (bool _txLimit, bool _maxWallet , bool _fee) {
    return (_isExcludedFromMaxWalletLimit[account], _isExcludedFromTxLimit[account], _isExcludedFromFee[account]);
  }
 
  function setBuyFees() private {

    _previousBurnFee = _burnFee;
    _previousLiquidityFee = _liquidityFee;
    _previousMarketingFee = _marketingFee;
    _previousTaxFee = _taxFee;
    
    _burnFee = burnFeeBuy;
    _liquidityFee = liquidityFeeBuy;
    _marketingFee = marketingFeeBuy;
    _taxFee = reflectFeeBuy;
  }

  function setSellFees() private {

    _previousBurnFee = _burnFee;
    _previousLiquidityFee = _liquidityFee;
    _previousMarketingFee = _marketingFee;
    _previousTaxFee = _taxFee;
    
    _burnFee = burnFeeSell;
    _liquidityFee = liquidityFeeSell;
    _marketingFee = marketingFeeSell;
    _taxFee = reflectFeeSell;
  }

  function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner {
      require(maxTxPercent > 50, "min 0.5% of total supply");
    _maxTxAmount = _tTotal.mul(maxTxPercent).div(100 * 10**2);
  }

  function WalletFeeSwitch() public onlyOwner {walletTowalletFee = !walletTowalletFee;}

  function setSwapAndLiquifyEnabled(bool toggle) public onlyOwner {
    swapAndLiquifyEnabled = toggle;
    emit SwapAndLiquifyEnabledUpdated(toggle);
  }

  receive() external payable {}

  function blacklistAddress(address account, bool value) external onlyOwner { //blacklist function
    _isBlacklisted[account] = value;
  }

  function _reflectFee(uint256 rFee, uint256 tFee) private {
    _rTotal = _rTotal.sub(rFee);
    _tFeeTotal = _tFeeTotal.add(tFee);
  }

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

  function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {return _amount.mul(_liquidityFee.add(_marketingFee).add(_burnFee)).div(100);}

  function updateMarketingWallet(address payable _newWallet) external onlyOwner {
    require(_newWallet != marketingWallet, "The marketing wallet is already this address");
    emit MarketingWalletUpdated(marketingWallet, _newWallet);
    marketingWallet = _newWallet;
  }
  
  function removeAllFee() private {
    if (_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;

    _previousTaxFee = _taxFee;
    _previousMarketingFee = _marketingFee;
    _previousLiquidityFee = _liquidityFee;
    _previousBurnFee = _burnFee;
    
    _taxFee = 0;
    _burnFee = 0;
    _marketingFee = 0;
    _liquidityFee = 0;
  }

  function restoreAllFee() private {
    _taxFee = _previousTaxFee;
    _marketingFee = _previousMarketingFee;
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
    require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted address"); //blacklist function

    if(amount == 0) {return;}   

    if(to == UniswapV2Pair && (!(_isExcludedFromTxLimit[from])) && (!(_isExcludedFromTxLimit[to]))){  // sell limitation
      require(amount <= _maxTxAmount, 'Transfer amount exceeds the maxTxAmount.');
    }
    
    if(!_isExcludedFromMaxWalletLimit[from] && !_isExcludedFromMaxWalletLimit[to] && to != UniswapV2Pair) {
      uint balance = balanceOf(to);
      require(balance + amount <= maxWalletAmount," max wallet reached");
    }

    uint256 contractTokenBalance = balanceOf(address(this));
    if (contractTokenBalance >= _maxTxAmount) {contractTokenBalance = _maxTxAmount;}

    bool overMinTokenBalance = (contractTokenBalance > numTokensSellToAddToLiquidity);
    if (overMinTokenBalance && !inSwapAndLiquify && from != UniswapV2Pair && swapAndLiquifyEnabled) {
      setSellFees();
      inSwapAndLiquify = true;
      //contractTokenBalance = numTokensSellToAddToLiquidity;
      swapAndLiquify(contractTokenBalance);
      restoreAllFee();
      inSwapAndLiquify = false;
    }

    bool takeFee = true;
    bool purchaseOrSale = false;
    if ((to == UniswapV2Pair) || (from == UniswapV2Pair)) {purchaseOrSale = true;}
    if ((purchaseOrSale == false) && (walletTowalletFee == false)) {takeFee = false;}
    if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {takeFee = false;}

    _tokenTransfer(from, to, amount, takeFee);
  }

  function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
    uint256 marketingBalance = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee).add(_burnFee));
    uint burnBal = contractTokenBalance.mul(_burnFee).div(_marketingFee.add(_liquidityFee).add(_burnFee));
    uint256 liquidityBalance = contractTokenBalance.sub(marketingBalance).sub(burnBal);

    uint256 half = liquidityBalance.div(2);
    uint256 otherHalf = liquidityBalance.sub(half);
    uint256 tokensToSwapForETH = half.add(marketingBalance);
    uint256 initialBalance = address(this).balance;
    
    _transfer(address(this), _burnWallet, burnBal);
    swapTokensForEth(tokensToSwapForETH); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered

    uint256 newBalance = address(this).balance.sub(initialBalance);
    uint256 marketingETHBalance = newBalance.mul(marketingBalance).div(tokensToSwapForETH);
    uint256 liquidityETHBalance = newBalance.sub(marketingETHBalance);

    addLiquidity(otherHalf, liquidityETHBalance);
    sendETHToMarketing(marketingETHBalance);

    emit SwapAndLiquify(half, newBalance, otherHalf);
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
    uniswapV2Router.addLiquidityETH{ value: ethAmount } (address(this), tokenAmount, 0, 0, address(0), block.timestamp);
  }

  function sendETHToMarketing(uint256 amount) private {payable(marketingWallet).transfer(amount);}

  function setSellFee(uint burn, uint marketing, uint liquidity, uint reflect) public onlyOwner {
    burnFeeSell = burn;
    marketingFeeSell = marketing;
    liquidityFeeSell = liquidity;
    reflectFeeSell = reflect;
    require(burn + marketing + liquidity + reflect <= 25, "max 25%");
  }

  function setBuyFees(uint burn, uint marketing, uint liquidity, uint reflect) public onlyOwner {
    burnFeeBuy = burn;
    marketingFeeBuy = marketing;
    liquidityFeeBuy = liquidity;
    reflectFeeBuy = reflect;
    require(burn + marketing + liquidity + reflect <= 25, "max 25%");
  }

  function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
    if (!takeFee) removeAllFee();
    if(takeFee && sender == UniswapV2Pair) {
        setBuyFees();
    } else if(takeFee && recipient == UniswapV2Pair) {
        setSellFees();
    }

    if (_isExcluded[sender] && !_isExcluded[recipient]) {
      _transferFromExcluded(sender, recipient, amount);
    } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
      _transferToExcluded(sender, recipient, amount);
    } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
      _transferStandard(sender, recipient, amount);
    } else if (_isExcluded[sender] && _isExcluded[recipient]) {
      _transferBothExcluded(sender, recipient, amount);
    } else {
      _transferStandard(sender, recipient, amount);
    }

    if(takeFee && (sender == UniswapV2Pair || recipient == UniswapV2Pair)) {restoreAllFee();}
    if (!takeFee) restoreAllFee();
  }

  function setNumTokensell(uint value ) public onlyOwner {numTokensSellToAddToLiquidity = value;}

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
}
 