/**
 *Submitted for verification at BscScan.com on 2021-12-18
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
 
interface IERC20 {
    function totalSupply() external view returns (uint256);
 
    function balanceOf(address account) external view returns (uint256);
 
    function transfer(address recipient, uint256 amount) external returns (bool);
 
    function allowance(address owner, address spender) external view returns (uint256);
 
    function approve(address spender, uint256 amount) external returns (bool);
 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
 
    event Transfer(address indexed from, address indexed to, uint256 value);
 
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDividendPayingToken {
  function dividendOf(address _owner) external view returns(uint256);
 
  function withdrawDividend() external;
 
  event DividendsDistributed(
    address indexed from,
    uint256 weiAmount
  );
 
  event DividendWithdrawn(
    address indexed to,
    uint256 weiAmount
  );
}
 
interface IDividendPayingTokenOptional {
  function withdrawableDividendOf(address _owner) external view returns(uint256);
 
  function withdrawnDividendOf(address _owner) external view returns(uint256);
 
  function accumulativeDividendOf(address _owner) external view returns(uint256);
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
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
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
 

library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }
 
    function get(Map storage map, address key) public view returns (uint) {
        return map.values[key];
    }
 
    function getIndexOfKey(Map storage map, address key) public view returns (int) {
        if(!map.inserted[key]) {
            return -1;
        }
        return int(map.indexOf[key]);
    }
 
    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        return map.keys[index];
    }
 
 
 
    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }
 
    function set(Map storage map, address key, uint val) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }
 
    function remove(Map storage map, address key) public {
        if (!map.inserted[key]) {
            return;
        }
 
        delete map.inserted[key];
        delete map.values[key];
 
        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];
 
        map.indexOf[lastKey] = index;
        delete map.indexOf[key];
 
        map.keys[index] = lastKey;
        map.keys.pop();
    }
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
 
library SafeMathInt {
  function mul(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when multiplying INT256_MIN with -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
 
    int256 c = a * b;
    require((b == 0) || (c / b == a));
    return c;
  }
 
  function div(int256 a, int256 b) internal pure returns (int256) {
    // Prevent overflow when dividing INT256_MIN by -1
    // https://github.com/RequestNetwork/requestNetwork/issues/43
    require(!(a == - 2**255 && b == -1) && (b > 0));
 
    return a / b;
  }
 
  function sub(int256 a, int256 b) internal pure returns (int256) {
    require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
 
    return a - b;
  }
 
  function add(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a + b;
    require((b >= 0 && c >= a) || (b < 0 && c < a));
    return c;
  }
 
  function toUint256Safe(int256 a) internal pure returns (uint256) {
    require(a >= 0);
    return uint256(a);
  }
}
 
library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
 
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
 
    function owner() public view virtual returns (address) {
        return _owner;
    }
 
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

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
 
    mapping (address => uint256) private _balances;
 
    mapping (address => mapping (address => uint256)) private _allowances;
 
    uint256 private _totalSupply;
 
    string private _name;
    string private _symbol;
    uint8 private _decimals;
 
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }
 
    function name() public view virtual returns (string memory) {
        return _name;
    }
 
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
 
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }
 
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
 
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
 
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
 
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
 
        _beforeTokenTransfer(sender, recipient, amount);
 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
 
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
 
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }
 
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
 
contract RC2 is ERC20, Ownable {
    using SafeMath for uint256;
 
    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;
 

    address public deadAddress = 0x000000000000000000000000000000000000dEaD;

    bool private swapping;


    bool public swapAndLiquifyEnabled = true;


 
    BUSDDividendTracker  public busdTokenDividendTracker;
    RC1DividendTracker public rc1DividendTracker;
 
    address public marketingWallet = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
    address public devWallet = 0x2Db96c4F203fBc13c98bBa428ba9E09B48543b0A;
    
  

    uint256 public swapTokensAtAmount = 1000000 * 10**18;
 
    uint256 public liquidityFee = 3;
    IERC20 public RC1 = IERC20(0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684); // USDT
    IERC20 public BUSD = IERC20(0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7);
    uint256 public busdDividendRewardsFee = 5;

    uint256 public rc1DividendRewardsFee = 3;

    uint256 public marketingFee = 4;
    uint256 public devFee = 1;

    uint256 public totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
    uint256 public gasForProcessing = 600000;
 
    address public presaleAddress;

    mapping (address => bool) private isExcludedFromFees;
 
    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping (address => bool) public automatedMarketMakerPairs;
 
    event UpdatebusdTokenDividendTracker(address indexed newAddress, address indexed oldAddress);
    event Updaterc1DividendTracker(address indexed newAddress, address indexed oldAddress);
 
    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
 
    event SwapAndLiquifyEnabledUpdated(bool enabled);


 
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
 
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
 
    event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
    event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
 
    event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 bnbReceived,
        uint256 tokensIntoLiqudity
    );
 
    event SendDividends(
    	uint256 amount
    );
 
    event ProcessedbusdTokenDividendTracker(
    	uint256 iterations,
    	uint256 claims,
        uint256 lastProcessedIndex,
    	bool indexed automatic,
    	uint256 gas,
    	address indexed processor
    );
 
    event Processedrc1DividendTracker(
    	uint256 iterations,
    	uint256 claims,
        uint256 lastProcessedIndex,
    	bool indexed automatic,
    	uint256 gas,
    	address indexed processor
    );
 
    constructor() ERC20("REWARD CYCLE 2", "RC2") {
    	busdTokenDividendTracker = new BUSDDividendTracker();
    	rc1DividendTracker = new RC1DividendTracker();
    	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3);
         // Create a uniswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
 
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
 
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
 
        excludeFromDividend(address(busdTokenDividendTracker));
        excludeFromDividend(address(rc1DividendTracker));
        excludeFromDividend(address(this));
        excludeFromDividend(address(_uniswapV2Router));
        excludeFromDividend(deadAddress);
 
        // exclude from paying fees or having max transaction amount
        excludeFromFees(marketingWallet, true);
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(owner(), true);

 
        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        _mint(owner(), 10000000000 * (10**18));
    }
 
    receive() external payable {
 
  	}
 
  	function whitelistPreSale(address _presaleAddress, address _routerAddress) external onlyOwner {
  	    presaleAddress = _presaleAddress;
        busdTokenDividendTracker.excludeFromDividends(_presaleAddress);
        rc1DividendTracker.excludeFromDividends(_presaleAddress);
        excludeFromFees(_presaleAddress, true);
 
        rc1DividendTracker.excludeFromDividends(_routerAddress);
        busdTokenDividendTracker.excludeFromDividends(_routerAddress);
        excludeFromFees(_routerAddress, true);
  	}
 
  	function prepareForPartherOrExchangeListing(address _partnerOrExchangeAddress) external onlyOwner {
  	    busdTokenDividendTracker.excludeFromDividends(_partnerOrExchangeAddress);
        rc1DividendTracker.excludeFromDividends(_partnerOrExchangeAddress);
        excludeFromFees(_partnerOrExchangeAddress, true);
  	}

 
 
  	function updateMarketingWallet(address _newWallet) external onlyOwner {
  	    require(_newWallet != marketingWallet, "RC2: The marketing wallet is already this address");
        excludeFromFees(_newWallet, true);
        emit MarketingWalletUpdated(marketingWallet, _newWallet);
  	    marketingWallet = _newWallet;
  	}

    function updateDevWallet(address _newWallet) external onlyOwner {
  	    require(_newWallet != devWallet, "RC2: The dev wallet is already this address");
  	    devWallet = _newWallet;
  	}
  
 
  	function setSwapTokensAtAmount(uint256 _swapAmount) external onlyOwner {
  	    swapTokensAtAmount = _swapAmount;
  	}
 

 
    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
      swapAndLiquifyEnabled = _enabled;
 
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function updatebusdTokenDividendTracker(address newAddress) external onlyOwner {
        require(newAddress != address(busdTokenDividendTracker), "RC2: The dividend tracker already has that address");
 
        BUSDDividendTracker newbusdTokenDividendTracker =  BUSDDividendTracker(payable(newAddress));
 
        require(newbusdTokenDividendTracker.owner() == address(this), "RC2: The new dividend tracker must be owned by the RC2 token contract");
 
        newbusdTokenDividendTracker.excludeFromDividends(address(newbusdTokenDividendTracker));
        newbusdTokenDividendTracker.excludeFromDividends(address(this));
        newbusdTokenDividendTracker.excludeFromDividends(address(uniswapV2Router));
        newbusdTokenDividendTracker.excludeFromDividends(address(deadAddress));
 
        emit UpdatebusdTokenDividendTracker(newAddress, address(busdTokenDividendTracker));
 
        busdTokenDividendTracker = newbusdTokenDividendTracker;
    }
 
    function updateRc1DividendTracker(address newAddress) external onlyOwner {
        require(newAddress != address(rc1DividendTracker), "RC2: The dividend tracker already has that address");
 
        RC1DividendTracker newrc1DividendTracker = RC1DividendTracker(payable(newAddress));
 
        require(newrc1DividendTracker.owner() == address(this), "RC2: The new dividend tracker must be owned by the RC2 token contract");
 
        newrc1DividendTracker.excludeFromDividends(address(newrc1DividendTracker));
        newrc1DividendTracker.excludeFromDividends(address(this));
        newrc1DividendTracker.excludeFromDividends(address(uniswapV2Router));
        newrc1DividendTracker.excludeFromDividends(address(deadAddress));
 
        emit Updaterc1DividendTracker(newAddress, address(rc1DividendTracker));
 
        rc1DividendTracker = newrc1DividendTracker;
    }
 
    function updateBusdDividendRewardFee(uint8 newFee) external onlyOwner {
        busdDividendRewardsFee = newFee;
        totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
        require(totalFees <= 20 , "max 20%");
    }
 
    function updateRc1DividendRewardFee(uint8 newFee) external onlyOwner {
        rc1DividendRewardsFee = newFee;
        totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
        require(totalFees <= 20 , "max 20%");
    }
 
    function updateMarketingFee(uint8 newFee) external onlyOwner {
        marketingFee = newFee;
        totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
        require(totalFees <= 20 , "max 20%");
    }
 
    function updateLiquidityFee(uint8 newFee) external onlyOwner {
        liquidityFee = newFee;
        totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
        require(totalFees <= 20 , "max 20%");
    }

     function updateDevFee(uint8 newFee) external onlyOwner {
        devFee = newFee;
        totalFees = busdDividendRewardsFee.add(marketingFee).add(rc1DividendRewardsFee).add(liquidityFee).add(devFee);
        require(totalFees <= 20 , "max 20%");
    }

    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(newAddress != address(uniswapV2Router), "RC2: The router already has that address");
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }
 
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        isExcludedFromFees[account] = excluded;
 
        emit ExcludeFromFees(account, excluded);
    }
 
    function excludeFromDividend(address account) public onlyOwner {
        busdTokenDividendTracker.excludeFromDividends(address(account));
        rc1DividendTracker.excludeFromDividends(address(account));
    }
 
    function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
        for(uint256 i = 0; i < accounts.length; i++) {
            isExcludedFromFees[accounts[i]] = excluded;
        }
 
        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }
 
    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV2Pair, "RC2: The PanadaSwap pair cannot be removed from automatedMarketMakerPairs");
 
        _setAutomatedMarketMakerPair(pair, value);
    }
 
    function _setAutomatedMarketMakerPair(address pair, bool value) private onlyOwner {
        require(automatedMarketMakerPairs[pair] != value, "RC2: Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;
 
        if(value) {
            busdTokenDividendTracker.excludeFromDividends(pair);
            rc1DividendTracker.excludeFromDividends(pair);
        }
 
        emit SetAutomatedMarketMakerPair(pair, value);
    }
 
    function updateGasForProcessing(uint256 newValue) external onlyOwner {
        require(newValue != gasForProcessing, "RC2: Cannot update gasForProcessing to same value");
        gasForProcessing = newValue;
        emit GasForProcessingUpdated(newValue, gasForProcessing);
    }
 
    function updateMinimumBalanceForDividends(uint256 newMinimumBalance) external onlyOwner {
        busdTokenDividendTracker.updateMinimumTokenBalanceForDividends(newMinimumBalance);
        rc1DividendTracker.updateMinimumTokenBalanceForDividends(newMinimumBalance);
    }
 
    function updateClaimWait(uint256 claimWait) external onlyOwner {
        busdTokenDividendTracker.updateClaimWait(claimWait);
        rc1DividendTracker.updateClaimWait(claimWait);
    }
 
    function getBUSDClaimWait() external view returns(uint256) {
        return busdTokenDividendTracker.claimWait();
    }
 
    function getRC1ClaimWait() external view returns(uint256) {
        return rc1DividendTracker.claimWait();
    }
 
    function getTotalBUSDDividendsDistributed() external view returns (uint256) {
        return busdTokenDividendTracker.totalDividendsDistributed();
    }
 
    function getTotalRC1DividendsDistributed() external view returns (uint256) {
        return rc1DividendTracker.totalDividendsDistributed();
    }
 
    function getIsExcludedFromFees(address account) public view returns(bool) {
        return isExcludedFromFees[account];
    }
 
    function withdrawableBUSDDividendOf(address account) external view returns(uint256) {
    	return busdTokenDividendTracker.withdrawableDividendOf(account);
  	}
 
  	function withdrawableRC1DividendOf(address account) external view returns(uint256) {
    	return rc1DividendTracker.withdrawableDividendOf(account);
  	}
 
	function busdDividendTokenBalanceOf(address account) external view returns (uint256) {
		return busdTokenDividendTracker.balanceOf(account);
	}
 
	function rc1DividendTokenBalanceOf(address account) external view returns (uint256) {
		return rc1DividendTracker.balanceOf(account);
	}
 
    function getAccountBusdDividendsInfo(address account)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
        return busdTokenDividendTracker.getAccount(account);
    }
 
    function getAccountRC1DividendsInfo(address account)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
        return rc1DividendTracker.getAccount(account);
    }
 
	function getAccountBUSDDividendsInfoAtIndex(uint256 index)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	return busdTokenDividendTracker.getAccountAtIndex(index);
    }
 
    function getAccountRC1DividendsInfoAtIndex(uint256 index)
        external view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	return rc1DividendTracker.getAccountAtIndex(index);
    }
 
	function processDividendTracker(uint256 gas) external onlyOwner {
		(uint256 busdIterations, uint256 busdClaims, uint256 busdLastProcessedIndex) = busdTokenDividendTracker.process(gas);
		emit ProcessedbusdTokenDividendTracker(busdIterations, busdClaims, busdLastProcessedIndex, false, gas, msg.sender);
 
		(uint256 rc1Iterations, uint256 rc1Claims, uint256 rc1LastProcessedIndex) = rc1DividendTracker.process(gas);
		emit Processedrc1DividendTracker(rc1Iterations, rc1Claims, rc1LastProcessedIndex, false, gas, msg.sender);
    }
 
    function claim() external {
		busdTokenDividendTracker.processAccount(payable(msg.sender), false);
		rc1DividendTracker.processAccount(payable(msg.sender), false);
    }
    
    function getLastbusdDividendProcessedIndex() external view returns(uint256) {
    	return busdTokenDividendTracker.getLastProcessedIndex();
    }
 
    function getLastRC1DividendProcessedIndex() external view returns(uint256) {
    	return rc1DividendTracker.getLastProcessedIndex();
    }
 
    function getNumberOfbusdDividendTokenHolders() external view returns(uint256) {
        return busdTokenDividendTracker.getNumberOfTokenHolders();
    }
 
    function getNumberOfRC1DividendTokenHolders() external view returns(uint256) {
        return rc1DividendTracker.getNumberOfTokenHolders();
    }
    
 
 
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
         require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if(amount == 0) {
            super._transfer(from, to, 0);
            return;
        }


 
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
 
        if (canSwap &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            from != owner() &&
            to != owner()) {
            swapping = true;
 
         
                uint256 initialBalance = address(this).balance;
                uint256 swapTokens = contractTokenBalance.div(totalFees).mul(marketingFee);
                swapTokensForBNB(swapTokens);
                uint256 marketingPortion = address(this).balance.sub(initialBalance);
                 address(marketingWallet).call{value: marketingPortion}("");
              
                uint256 swapTokensDev = contractTokenBalance.div(totalFees).mul(devFee);
                uint256 initialBalanceDev = address(this).balance;
                swapTokensForBNB(swapTokensDev);
                uint256 devPortion = address(this).balance.sub(initialBalanceDev);
                 address(devWallet).call{value: devPortion}("");
               
                uint256 liqTokens = contractTokenBalance.div(totalFees).mul(liquidityFee);
                swapAndLiquify(liqTokens);
            
 
        
                uint256 busdTokens = contractTokenBalance.div(totalFees).mul(busdDividendRewardsFee);
                swapAndSendBUSDDividends(busdTokens);

        
                uint256 rc1Tokens = contractTokenBalance.div(totalFees).mul(rc1DividendRewardsFee);
                swapAndSendRC1Dividends(rc1Tokens);
            
 
                swapping = false;
        }
 
        bool takeFee = !swapping;

        // if any account belongs to _isExcludedFromFee account then remove the fee
        if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
            takeFee = false;
        }

        if(takeFee) {
        	uint256 fees = amount.div(100).mul(totalFees);
 
        	amount = amount.sub(fees);
 
            super._transfer(from, address(this), fees);
        }
 
        super._transfer(from, to, amount);
 
       try busdTokenDividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
        try rc1DividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
       try busdTokenDividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
        try rc1DividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
 
        if(!swapping) {
	    	uint256 gas = gasForProcessing;
 
	    	try busdTokenDividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
	    		emit ProcessedbusdTokenDividendTracker(iterations, claims, lastProcessedIndex, true, gas, msg.sender);
	    	}
	    	catch {
 
	    	}
 
	    	try rc1DividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
	    		emit Processedrc1DividendTracker(iterations, claims, lastProcessedIndex, true, gas, msg.sender);
	    	}
	    	catch {
 
	    	}
        }
    }

    function swapAndLiquify(uint256 contractTokenBalance) private {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
 
        uint256 initialBalance = address(this).balance;
 
        swapTokensForBNB(half);
 
        uint256 newBalance = address(this).balance.sub(initialBalance);
 
        addLiquidity(otherHalf, newBalance);
 
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
 
    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
 
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            deadAddress,
            block.timestamp
        );
    }
 
    function swapTokensForBNB(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
 
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
 
    }
 
    function swapTokensForRC1(uint256 _tokenAmount) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = address(RC1);
 
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _tokenAmount,
            0, // accept any amount of dividend token
            path,
            address(this),
            block.timestamp
        );
    }

    function swapTokensForBUSD(uint256 _tokenAmount) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = address(BUSD);
 
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _tokenAmount,
            0, // accept any amount of dividend token
            path,
            address(this),
            block.timestamp
        );
    }

 
    function swapAndSendRC1Dividends(uint256 tokens) private {
        swapTokensForRC1(tokens);
        uint256 rc1Tokens = IERC20(RC1).balanceOf(address(this));
        transferDividends( address(rc1DividendTracker), rc1DividendTracker, rc1Tokens, RC1);
    }
 
  
    function swapAndSendBUSDDividends(uint256 tokens) private {
        swapTokensForBUSD(tokens);
        uint256 busdtokens = IERC20(BUSD).balanceOf(address(this));
        transferDividends( address(busdTokenDividendTracker), busdTokenDividendTracker, busdtokens, BUSD);
    }
 
 
    function transferDividends(address dividendTracker, DividendPayingToken dividendPayingTracker, uint256 amount, IERC20 token) private {
        bool success = IERC20(token).transfer(dividendTracker, amount);
 
        if (success) {
            dividendPayingTracker.distributeDividends(amount);
            emit SendDividends(amount);
        }
    }
}

contract DividendPayingToken is ERC20, Ownable, IDividendPayingToken, IDividendPayingTokenOptional {
  using SafeMath for uint256;
  using SafeMathUint for uint256;
  using SafeMathInt for int256;
 
  uint256 constant internal magnitude = 2**128;
 
  uint256 internal magnifiedDividendPerShare;
  uint256 internal lastAmount;
 
  address public dividendToken;
 
 
  mapping(address => int256) internal magnifiedDividendCorrections;
  mapping(address => uint256) internal withdrawnDividends;

 
  uint256 public totalDividendsDistributed;
 
 
 
  constructor(string memory _name, string memory _symbol, address _token) ERC20(_name, _symbol) {
    dividendToken = _token;
  }
 
 
 
  function distributeDividends(uint256 amount) public onlyOwner {
    require(totalSupply() > 0);
 
    if (amount > 0) {
      magnifiedDividendPerShare = magnifiedDividendPerShare.add(
        (amount).mul(magnitude) / totalSupply()
      );
      emit DividendsDistributed(msg.sender, amount);
 
      totalDividendsDistributed = totalDividendsDistributed.add(amount);
    }
  }
 
 
  function withdrawDividend() public virtual override {
    _withdrawDividendOfUser(payable(msg.sender));
  }
 

 
  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
    uint256 _withdrawableDividend = withdrawableDividendOf(user);
    if (_withdrawableDividend > 0) {
      withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
      emit DividendWithdrawn(user, _withdrawableDividend);
    
        bool success = IERC20(dividendToken).transfer(user, _withdrawableDividend);
      
 
      if(!success) {
        withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
        return 0;
      }
 
      return _withdrawableDividend;
    }
 
    return 0;
  }
 
 
  function dividendOf(address _owner) public view override returns(uint256) {
    return withdrawableDividendOf(_owner);
  }
 
  function withdrawableDividendOf(address _owner) public view override returns(uint256) {
    return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
  }
 
  function withdrawnDividendOf(address _owner) public view override returns(uint256) {
    return withdrawnDividends[_owner];
  }
 
 
  function accumulativeDividendOf(address _owner) public view override returns(uint256) {
    return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
      .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
  }
 
  function _transfer(address from, address to, uint256 value) internal virtual override {
    require(false);
 
    int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
    magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
    magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
  }
 
  function _mint(address account, uint256 value) internal override {
    super._mint(account, value);
 
    magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
      .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
  }
 
  function _burn(address account, uint256 value) internal override {
    super._burn(account, value);
 
    magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
      .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
  }
 
  function _setBalance(address account, uint256 newBalance) internal {
    uint256 currentBalance = balanceOf(account);
 
    if(newBalance > currentBalance) {
      uint256 mintAmount = newBalance.sub(currentBalance);
      _mint(account, mintAmount);
    } else if(newBalance < currentBalance) {
      uint256 burnAmount = currentBalance.sub(newBalance);
      _burn(account, burnAmount);
    }
  }
}

contract RC1DividendTracker is DividendPayingToken {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;
 
    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;
 
    mapping (address => bool) public excludedFromDividends;
 
    mapping (address => uint256) public lastClaimTimes;
 
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;
 
    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event Claim(address indexed account, uint256 amount, bool indexed automatic);
 
    constructor() DividendPayingToken("RC2_RC1_Dividend_Tracker", "RC2_RC1_Dividend_Tracker", 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684) {
    	claimWait = 3600;
        minimumTokenBalanceForDividends = 2000000 * (10**18); //must hold 2000000+ tokens
    }
 
    function _transfer(address, address, uint256) pure internal override {
        require(false, "RC2_RC1_Dividend_Tracker: No transfers allowed");
    }
 
    function withdrawDividend() pure public override {
        require(false, "RC2_RC1_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main RC2 contract.");
    }
 
 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
        require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * (10**18);
    }
 
    function excludeFromDividends(address account) external onlyOwner {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
 
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
 
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "RC2_RC1_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "RC2_RC1_Dividend_Tracker: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) {
    	return lastProcessedIndex;
    }
 
    function getNumberOfTokenHolders() external view returns(uint256) {
        return tokenHoldersMap.keys.length;
    }
 
 
    function getAccount(address _account)
        public view returns (
            address account,
            int256 index,
            int256 iterationsUntilProcessed,
            uint256 withdrawableDividends,
            uint256 totalDividends,
            uint256 lastClaimTime,
            uint256 nextClaimTime,
            uint256 secondsUntilAutoClaimAvailable) {
        account = _account;
 
        index = tokenHoldersMap.getIndexOfKey(account);
 
        iterationsUntilProcessed = -1;
 
        if(index >= 0) {
            if(uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            }
            else {
                uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
                                                        tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
                                                        0;
 
 
                iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
            }
        }
 
 
        withdrawableDividends = withdrawableDividendOf(account);
        totalDividends = accumulativeDividendOf(account);
 
        lastClaimTime = lastClaimTimes[account];
 
        nextClaimTime = lastClaimTime > 0 ?
                                    lastClaimTime.add(claimWait) :
                                    0;
 
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
                                                    nextClaimTime.sub(block.timestamp) :
                                                    0;
    }
 
    function getAccountAtIndex(uint256 index)
        public view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	if(index >= tokenHoldersMap.size()) {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
 
        address account = tokenHoldersMap.getKeyAtIndex(index);
 
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
    	if(lastClaimTime > block.timestamp)  {
    		return false;
    	}
 
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
    	if(excludedFromDividends[account]) {
    		return;
    	}
 
    	if(newBalance >= minimumTokenBalanceForDividends) {
            _setBalance(account, newBalance);
    		tokenHoldersMap.set(account, newBalance);
    	}
    	else {
            _setBalance(account, 0);
    		tokenHoldersMap.remove(account);
    	}
 
    	processAccount(account, true);
    }
 
    function process(uint256 gas) public returns (uint256, uint256, uint256) {
    	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
 
    	if(numberOfTokenHolders == 0) {
    		return (0, 0, lastProcessedIndex);
    	}
 
    	uint256 _lastProcessedIndex = lastProcessedIndex;
 
    	uint256 gasUsed = 0;
 
    	uint256 gasLeft = gasleft();
 
    	uint256 iterations = 0;
    	uint256 claims = 0;
 
    	while(gasUsed < gas && iterations < numberOfTokenHolders) {
    		_lastProcessedIndex++;
 
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
    			_lastProcessedIndex = 0;
    		}
 
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account])) {
    			if(processAccount(payable(account), true)) {
    				claims++;
    			}
    		}
 
    		iterations++;
 
    		uint256 newGasLeft = gasleft();
 
    		if(gasLeft > newGasLeft) {
    			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
    		}
 
    		gasLeft = newGasLeft;
    	}
 
    	lastProcessedIndex = _lastProcessedIndex;
 
    	return (iterations, claims, lastProcessedIndex);
    }
 
    function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
        uint256 amount = _withdrawDividendOfUser(account);
 
    	if(amount > 0) {
    		lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
    		return true;
    	}
 
    	return false;
    }
}
 
contract BUSDDividendTracker is DividendPayingToken {
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;
 
    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;
 
    mapping (address => bool) public excludedFromDividends;
 
    mapping (address => uint256) public lastClaimTimes;
 
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;
 
    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event Claim(address indexed account, uint256 amount, bool indexed automatic);
 
    constructor() DividendPayingToken("RC2_BUSD_Dividend_Tracker", "RC2_BUSD_Dividend_Tracker", 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7) {
    	claimWait = 3600;
        minimumTokenBalanceForDividends = 2000000 * (10**18); //must hold 2000000+ tokens
    }
 
    function _transfer(address, address, uint256) pure internal override {
        require(false, "RC2_BUSD_Dividend_Tracker: No transfers allowed");
    }
 
    function withdrawDividend() pure public override {
        require(false, "RC2_BUSD_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main RC2 contract.");
    }


 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
        require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * (10**18);
    }
 
    function excludeFromDividends(address account) external onlyOwner {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
 
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
 
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "RC2_BUSD_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "RC2_BUSD_Dividend_Tracker: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) {
    	return lastProcessedIndex;
    }
 
    function getNumberOfTokenHolders() external view returns(uint256) {
        return tokenHoldersMap.keys.length;
    }
 
 
    function getAccount(address _account)
        public view returns (
            address account,
            int256 index,
            int256 iterationsUntilProcessed,
            uint256 withdrawableDividends,
            uint256 totalDividends,
            uint256 lastClaimTime,
            uint256 nextClaimTime,
            uint256 secondsUntilAutoClaimAvailable) {
        account = _account;
 
        index = tokenHoldersMap.getIndexOfKey(account);
 
        iterationsUntilProcessed = -1;
 
        if(index >= 0) {
            if(uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            }
            else {
                uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
                                                        tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
                                                        0;
 
 
                iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
            }
        }
 
 
        withdrawableDividends = withdrawableDividendOf(account);
        totalDividends = accumulativeDividendOf(account);
 
        lastClaimTime = lastClaimTimes[account];
 
        nextClaimTime = lastClaimTime > 0 ?
                                    lastClaimTime.add(claimWait) :
                                    0;
 
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
                                                    nextClaimTime.sub(block.timestamp) :
                                                    0;
    }
 
    function getAccountAtIndex(uint256 index)
        public view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) {
    	if(index >= tokenHoldersMap.size()) {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
 
        address account = tokenHoldersMap.getKeyAtIndex(index);
 
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
    	if(lastClaimTime > block.timestamp)  {
    		return false;
    	}
 
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
    	if(excludedFromDividends[account]) {
    		return;
    	}
 
    	if(newBalance >= minimumTokenBalanceForDividends) {
            _setBalance(account, newBalance);
    		tokenHoldersMap.set(account, newBalance);
    	}
    	else {
            _setBalance(account, 0);
    		tokenHoldersMap.remove(account);
    	}
 
    	processAccount(account, true);
    }
 
    function process(uint256 gas) public returns (uint256, uint256, uint256) {
    	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
 
    	if(numberOfTokenHolders == 0) {
    		return (0, 0, lastProcessedIndex);
    	}
 
    	uint256 _lastProcessedIndex = lastProcessedIndex;
 
    	uint256 gasUsed = 0;
 
    	uint256 gasLeft = gasleft();
 
    	uint256 iterations = 0;
    	uint256 claims = 0;
 
    	while(gasUsed < gas && iterations < numberOfTokenHolders) {
    		_lastProcessedIndex++;
 
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
    			_lastProcessedIndex = 0;
    		}
 
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account])) {
    			if(processAccount(payable(account), true)) {
    				claims++;
    			}
    		}
 
    		iterations++;
 
    		uint256 newGasLeft = gasleft();
 
    		if(gasLeft > newGasLeft) {
    			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
    		}
 
    		gasLeft = newGasLeft;
    	}
 
    	lastProcessedIndex = _lastProcessedIndex;
 
    	return (iterations, claims, lastProcessedIndex);
    }
 
    function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
        uint256 amount = _withdrawDividendOfUser(account);
 
    	if(amount > 0) {
    		lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
    		return true;
    	}
 
    	return false;
    }
}