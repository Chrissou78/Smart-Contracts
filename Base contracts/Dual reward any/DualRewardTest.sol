// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
 
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

interface IDividendPayingToken {
    function dividendOf(address _owner) external view returns(uint256);
    function withdrawDividend() external;
 
    event DividendsDistributed(address indexed from, uint256 weiAmount);
    event DividendWithdrawn(address indexed to, uint256 weiAmount);
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

library IterableMapping {
    // Iterable mapping from address to uint;
    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }
 
    function get(Map storage map, address key) public view returns (uint) {return map.values[key];}
 
    function getIndexOfKey(Map storage map, address key) public view returns (int) {
        if(!map.inserted[key]) {return -1;} return int(map.indexOf[key]);
    }
 
    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {return map.keys[index];}
    function size(Map storage map) public view returns (uint) {return map.keys.length;}
 
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
        if (!map.inserted[key]) {return;}
 
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

contract BEP20 is Context, IBEP20 {
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
        _decimals = 9;
    }
 
    function name() public view virtual returns (string memory) {return _name;}
    function symbol() public view virtual returns (string memory) {return _symbol;}
    function decimals() public view virtual returns (uint8) {return _decimals;}
    function totalSupply() public view virtual override returns (uint256) {return _totalSupply;}
    function balanceOf(address account) public view virtual override returns (uint256) {return _balances[account];}

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    function allowance(address owner, address spender) public view virtual override returns (uint256) {return _allowances[owner][spender];}
 
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "transfer amount exceeds allowance"));
        return true;
    }
 
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "decreased allowance below zero"));
        return true;
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
 
        _beforeTokenTransfer(sender, recipient, amount);
 
        _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
 
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
 
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "approve from the zero address");
        require(spender != address(0), "approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }
 
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
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

contract DualReward is BEP20, Ownable, SafeToken {
    using SafeMath for uint256;
 
    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;

    // BNB           P  0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
    // BNB           T  0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd
    // BUSD          P  0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56
    // BUSD          T  0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7
    // USDT          P  0x55d398326f99059fF775485246999027B3197955
    // USDT          T  0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684
    // MATIC            0xCC42724C6683B7E57334c4E856f4c9965ED682bD
    // ETH              0x2170Ed0880ac9A755fd29B2688956BD959F933F8
    // XRP           P  0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE
    // CAKE          P  0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82
    // CAKE          T  0xF9f93cF501BFaDB6494589Cb4b4C15dE49E85D0e
    // BTCB          P  0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c
    // ADA              0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47
    // SOL              0x570A5D26f7765Ecb712C0924E4De545B89fD43dF
    // AVAX             0x1CE0c2827e2eF14D5C4f29a091d735A204794041
    // MoonWalk      T  0xdf284410581f94a5D1b991D30b08dB72FCA94208
    // MoonWalk      P  0x9e566A4A22dCAfeF7De5d829Fd199d297Bb01487
    // EarthWalk
    // SunWalk
    // SatnWalk

    address payable public marketingWallet = payable(0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F); 
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;
    address private Token1Adress = 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7;
    address private Token2Adress = 0xdf284410581f94a5D1b991D30b08dB72FCA94208;
    address public PancakeRouter;
        
    bool private swapping;
    bool public swapAndLiquifyEnabled = true;
    bool public BurnReward1Option = false;
    bool public BurnReward2Option = false;
    
    DIVIDENDTracker1 public dividendTracker1;
    DIVIDENDTracker2 public dividendTracker2;
 
    uint256 private fees = 0;           // wallet to wallet 0 tax
    uint256 private burntaxamount = 0;  // wallet to wallet 0 tax
    uint256 private token1Tokens;
    uint256 private token2Tokens;

    uint256 public MaxSell = 1000000;
    uint256 public MaxWallet = 6000000;
    uint256 public SwapMin = 100000;
    uint256 public MaxTaxes = 25;
    uint256 private maxSellTransactionAmount = MaxSell * 10**9; // max sell 1% of supply
    uint256 private maxWalletAmount = MaxWallet * 10**9; // max wallet amount 6%
    uint256 private swapTokensAtAmount = SwapMin * 10**9;
    
    // Tax Fees
    uint256 public _LiquidityFee = 1;
    uint256 public _BurnFee = 1;
    uint256 public _buyMarketingFee = 2;
    uint256 public _buytoken1DividendRewardsFee = 6;
    uint256 public _buytoken2DividendRewardsFee = 3;
    uint256 public _sellMarketingFee = 4;
    uint256 public _selltoken1DividendRewardsFee = 9;
    uint256 public _selltoken2DividendRewardsFee = 4;
    uint256 public _totalTaxIfBuying = 0;
    uint256 public _totalTaxIfSelling = 0;
    uint256 public gasForProcessing = 600000;
    uint256 public minTokenBalanceForDividends = 10000;

    IBEP20 public TOKEN1 = IBEP20(Token1Adress);
    IBEP20 public TOKEN2 = IBEP20(Token2Adress);
  
    //address public presaleAddress;

    mapping (address => bool) private isExcludedFromFees;
    mapping(address => bool) private _isExcludedFromMaxTx;
    mapping(address => bool) public _isBlacklisted; //blacklist function
    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping (address => bool) public automatedMarketMakerPairs;
 
    event UpdatedividendTracker1(address indexed newAddress, address indexed oldAddress);
    event UpdatedividendTracker2(address indexed newAddress, address indexed oldAddress);
    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    //event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
    event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
    event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
    event SendDividends(uint256 amount);
    event ProcesseddividendTracker1(uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
    event ProcesseddividendTracker2( uint256 iterations, uint256 claims, uint256 lastProcessedIndex, bool indexed automatic, uint256 gas, address indexed processor);
    
    constructor() BEP20("DUAL REWARD", "DRT") {
    	dividendTracker1 = new DIVIDENDTracker1();
    	dividendTracker2 = new DIVIDENDTracker2();

	if (block.chainid == 56) {
      	PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    	} else if (block.chainid == 97) {
      	PancakeRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    	} else revert();
    	
	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(PancakeRouter);
        // Create a uniswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
 
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
 
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        _totalTaxIfBuying = _LiquidityFee.add(_buyMarketingFee).add(_buytoken1DividendRewardsFee).add(_buytoken2DividendRewardsFee).add(_BurnFee); //XX%
        _totalTaxIfSelling = _LiquidityFee.add(_sellMarketingFee).add(_selltoken1DividendRewardsFee).add(_selltoken2DividendRewardsFee).add(_BurnFee);//YY%
       
        excludeFromDividend(address(dividendTracker1));
        excludeFromDividend(address(dividendTracker2));
        excludeFromDividend(address(_uniswapV2Router));
         
        excludeFromDividend(address(this));
        excludeFromDividend(deadAddress);
        excludeFromDividend(marketingWallet);
        excludeFromDividend(owner());
 
        // exclude from paying fees or having max transaction amount
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(marketingWallet, true);
        excludeFromFees(owner(), true);
 
        // exclude from max tx
        _isExcludedFromMaxTx[address(this)] = true;
        _isExcludedFromMaxTx[deadAddress] = true;
        _isExcludedFromMaxTx[marketingWallet] = true;
        _isExcludedFromMaxTx[owner()] = true;
        
        //  _mint is an internal function in BEP20.sol that is only called here, and CANNOT be called ever again
        _mint(owner(), 100000000 * 10**9);
    }
 
    receive() external payable {}
 
  	function blacklistAddress(address account, bool value) external onlyOwner { //blacklist function
    _isBlacklisted[account] = value;
    }
    
  	function updateMarketingWallet(address payable _newWallet) external onlyOwner {
  	    require(_newWallet != marketingWallet, "The marketing wallet is already this address");
        excludeFromFees(_newWallet, true);
        _isExcludedFromMaxTx[_newWallet] = true;
        dividendTracker1.excludeFromDividends(address(_newWallet));
        dividendTracker2.excludeFromDividends(address(_newWallet));
        emit MarketingWalletUpdated(marketingWallet, _newWallet);
  	    marketingWallet = _newWallet;
  	}

    function setContractLimits(uint256 _maxWallet, uint256 _maxSell, uint256 _minswap, uint256 newMinimumBalance, uint256 claimWait, uint256 MaxTax, bool _swapAndLiquifyEnabled) public onlyOwner {
        uint256 supply = totalSupply ();
        require(_maxWallet >= supply / 100 && _maxWallet <= supply, "MawWallet must be between totalsupply and 1% of totalsupply");
        require(_maxSell >= supply / 1000 && _maxSell <= supply, "MawSell must be between totalsupply and 0.1% of totalsupply" );
        require(_minswap >= supply / 10000 && _minswap <= supply, "MinSwap must be between totalsupply and 0.01% of totalsupply" );
        require(newMinimumBalance <= supply / 100, "newMinimumBalance must be lower than 1% of totalsupply" );
        require(claimWait >= 3600 && claimWait <= 86400, "claimWait must be updated to between 1 and 24 hours");
        require(MaxTax >= 0 && MaxTax <= 100, "Max Tax must be updated to between 1 and 100 percent");

        MaxWallet = _maxWallet;
        maxWalletAmount = MaxWallet * 10**9;
        MaxSell = _maxSell;
        maxSellTransactionAmount = MaxSell * 10**9;
        SwapMin = _minswap;
        swapTokensAtAmount = SwapMin * 10**9;
        minTokenBalanceForDividends = newMinimumBalance;
        dividendTracker1.updateMinimumTokenBalanceForDividends(newMinimumBalance);
        dividendTracker2.updateMinimumTokenBalanceForDividends(newMinimumBalance);
        dividendTracker1.updateClaimWait(claimWait);
        dividendTracker2.updateClaimWait(claimWait);
        MaxTaxes = MaxTax;
       
        swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
        emit SwapAndLiquifyEnabledUpdated(_swapAndLiquifyEnabled);
    }
    // Reward Burn activation
    function RewardsOptions(bool Reward1Burn, bool Reward2Burn) external onlyOwner() {
        BurnReward1Option = Reward1Burn;
        BurnReward2Option = Reward2Burn;
    } 
    // Update all buy and sell taxes
    function UpdateTaxes(uint256 newLiquidityTax, uint256 newBurnTax, uint256 newMarketingBuyTax, uint256 newReward1BuyTax, uint256 newReward2BuyTax, uint256 newMarketingSellTax, uint256 newReward1SellTax, uint256 newReward2SellTax) external onlyOwner() {
        require(newMarketingBuyTax.add(newReward1BuyTax).add(newReward2BuyTax).add(newLiquidityTax).add(newBurnTax) <= MaxTaxes, "Total Tax can't exceed MaxTaxes.");
        require(newMarketingSellTax.add(newReward1SellTax).add(newReward2SellTax).add(newLiquidityTax).add(newBurnTax) <= MaxTaxes, "Total Tax can't exceed MaxTaxes.");
        require(newMarketingSellTax >= 0 && newMarketingBuyTax >= 0 && newReward1BuyTax >= 0 && newReward2BuyTax >= 0 && newReward1SellTax >= 0 && newReward2SellTax >= 0 && newLiquidityTax >= 0 && newBurnTax >= 0,"No tax can be negative");
        
        _LiquidityFee = newLiquidityTax;
        _BurnFee = newBurnTax;
        _buyMarketingFee = newMarketingBuyTax;
        _buytoken1DividendRewardsFee = newReward1BuyTax;
        _buytoken2DividendRewardsFee = newReward2BuyTax;
        _sellMarketingFee = newMarketingSellTax;
        _selltoken1DividendRewardsFee = newReward1SellTax;
        _selltoken2DividendRewardsFee = newReward2SellTax;
        
        _totalTaxIfBuying = _LiquidityFee.add(_buyMarketingFee).add(_buytoken1DividendRewardsFee).add(_buytoken2DividendRewardsFee).add(_BurnFee);
        _totalTaxIfSelling = _LiquidityFee.add(_sellMarketingFee).add(_selltoken1DividendRewardsFee).add(_selltoken2DividendRewardsFee).add(_BurnFee);
    } 
    
  	function updateDividendTracker1(address newAddress) external onlyOwner {
        require(newAddress != address(dividendTracker1), "The dividend tracker already has that address");
 
        DIVIDENDTracker1 newdividendTracker1 =  DIVIDENDTracker1(payable(newAddress));
 
        require(newdividendTracker1.owner() == address(this), "The new dividend tracker must be owned by the token contract");
 
        newdividendTracker1.excludeFromDividends(address(newdividendTracker1));
        newdividendTracker1.excludeFromDividends(address(this));
        newdividendTracker1.excludeFromDividends(address(uniswapV2Router));
        newdividendTracker1.excludeFromDividends(address(deadAddress));
 
        emit UpdatedividendTracker1(newAddress, address(dividendTracker1));
        dividendTracker1 = newdividendTracker1;
    }
 
    function updateDividendTracker2(address newAddress) external onlyOwner {
        require(newAddress != address(dividendTracker2), "The dividend tracker already has that address");
 
        DIVIDENDTracker2 newdividendTracker2 = DIVIDENDTracker2(payable(newAddress));
 
        require(newdividendTracker2.owner() == address(this), "The new dividend tracker must be owned by the token contract");
 
        newdividendTracker2.excludeFromDividends(address(newdividendTracker2));
        newdividendTracker2.excludeFromDividends(address(this));
        newdividendTracker2.excludeFromDividends(address(uniswapV2Router));
        newdividendTracker2.excludeFromDividends(address(deadAddress));
 
        emit UpdatedividendTracker2(newAddress, address(dividendTracker2));
 
        dividendTracker2 = newdividendTracker2;
    }
 
    function updateUniswapV2Router(address newAddress) external onlyOwner {
        require(newAddress != address(uniswapV2Router), "The router already has that address");
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }
 
    function setExcludeFromAll(address _address) external onlyOwner {
        _isExcludedFromMaxTx[_address] = true;
        excludeFromFees(_address, true);
        excludeFromDividend(_address);
    }

    function excludeFromFees(address account, bool excluded) private onlyOwner {
        isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }
 
    function excludeFromDividend(address account) private onlyOwner {
        dividendTracker1.excludeFromDividends(address(account));
        dividendTracker2.excludeFromDividends(address(account));
    }
    
    function setExcludeFromMaxTx(address _address, bool value) private onlyOwner { 
        _isExcludedFromMaxTx[_address] = value;
    }
    
    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV2Pair, "The Market pair cannot be removed from automatedMarketMakerPairs");
        _setAutomatedMarketMakerPair(pair, value);
    }
 
    function _setAutomatedMarketMakerPair(address pair, bool value) private onlyOwner {
        require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;
 
        if(value) {
            dividendTracker1.excludeFromDividends(pair);
            dividendTracker2.excludeFromDividends(pair);
        }
        emit SetAutomatedMarketMakerPair(pair, value);
    }
 
    function updateGasForProcessing(uint256 newValue) external onlyOwner {
        require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
        gasForProcessing = newValue;
        emit GasForProcessingUpdated(newValue, gasForProcessing);
    }
  
    function getClaimWait() external view returns(uint256) {
        return dividendTracker1.claimWait();
    }
  
    function getTotalTOKEN1DividendsDistributed() external view returns (uint256) {
        return dividendTracker1.totalDividendsDistributed();
    }
 
    function getTotalTOKEN2DividendsDistributed() external view returns (uint256) {
        return dividendTracker2.totalDividendsDistributed();
    }
 
    function getIsExcludedFromAll(address account) public view returns(bool) {
        return isExcludedFromFees[account];
    }
 
    function getAccountToken1DividendsInfo(address account) external view returns (address, int256, int256, uint256, uint256, uint256, uint256, uint256) {
        return dividendTracker1.getAccount(account);
    }
 
    function getAccountTOKEN2DividendsInfo(address account) external view returns (address, int256, int256, uint256, uint256, uint256, uint256, uint256) {
        return dividendTracker2.getAccount(account);
    }
 
	function processDividendTracker(uint256 gas) external onlyOwner {
		(uint256 token1Iterations, uint256 token1Claims, uint256 token1LastProcessedIndex) = dividendTracker1.process(gas);
		emit ProcesseddividendTracker1(token1Iterations, token1Claims, token1LastProcessedIndex, false, gas, msg.sender);
 
 		(uint256 token2Iterations, uint256 token2Claims, uint256 token2LastProcessedIndex) = dividendTracker2.process(gas);
		emit ProcesseddividendTracker2(token2Iterations, token2Claims, token2LastProcessedIndex, false, gas, msg.sender);
    }
 
    function claim() external {
		dividendTracker1.processAccount(payable(msg.sender), false);
		dividendTracker2.processAccount(payable(msg.sender), false);
    }
    
    function getNumberOftoken1DividendTokenHolders() external view returns(uint256) {
        return dividendTracker1.getNumberOfTokenHolders();
    }
    
    function getNumberOfTOKEN2DividendTokenHolders() external view returns(uint256) {
        return dividendTracker2.getNumberOfTokenHolders();
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "transfer from the zero address");
        require(to != address(0), "transfer to the zero address");
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted address"); //blacklist function
        
        // Max Wallet limitation
        if(to != owner() && to != address(this) && to != address(0x000000000000000000000000000000000000dEaD) && to != uniswapV2Pair && to != marketingWallet){
            uint256 heldTokens = balanceOf(to);
            require((heldTokens + amount) <= maxWalletAmount, "wallet amount exceed maxWalletAmount");
        }
        
        if(amount == 0) {
            super._transfer(from, to, 0);
            return;
        }
        
        // Max sell limitation
        if(to == uniswapV2Pair && (!_isExcludedFromMaxTx[from]) && (!_isExcludedFromMaxTx[to])){  // sell limitation
            require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
        }
        
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAtAmount;
         // Can Swap on sell only
        if (canSwap && !swapping && !automatedMarketMakerPairs[from] && from != owner() && to != owner() ) {
            swapping = true;
         
            uint256 initialBalance = address(this).balance;
            uint256 TotalFees = _totalTaxIfSelling.sub(_BurnFee);

            if(TotalFees != 0) {
                if(_sellMarketingFee != 0) {
                    uint256 swapTokens = contractTokenBalance.div(TotalFees).mul(_sellMarketingFee);
                    swapTokensForBNB(swapTokens);
                    uint256 marketingPortion = address(this).balance.sub(initialBalance);
                    marketingWallet.transfer(marketingPortion);
                    //address(marketingWallet).call{value: marketingPortion}("");
                }

                if(_LiquidityFee != 0) {
                    uint256 liqTokens = contractTokenBalance.div(TotalFees).mul(_LiquidityFee);
                    swapAndLiquify(liqTokens);
                }

                if(_selltoken1DividendRewardsFee != 0) {
                    if (!BurnReward1Option) {
                        token1Tokens = contractTokenBalance.div(TotalFees).mul(_selltoken1DividendRewardsFee);
                        swapAndSendDividends1(token1Tokens);
                    } else {
                        token1Tokens = contractTokenBalance.div(TotalFees).mul(_selltoken1DividendRewardsFee);
                        swapTokensForTOKEN1(token1Tokens);
                        token1Tokens = IBEP20(TOKEN1).balanceOf(address(this));
                        IBEP20(TOKEN1).transfer(deadAddress, token1Tokens);
                    }
                }

                if(_selltoken2DividendRewardsFee != 0) {
                    if (!BurnReward2Option) {
                        token2Tokens = contractTokenBalance.div(TotalFees).mul(_selltoken2DividendRewardsFee);
                        swapAndSendDividends2(token2Tokens);
                    } else {
                        token2Tokens = contractTokenBalance.div(TotalFees).mul(_selltoken2DividendRewardsFee);
                        swapTokensForTOKEN2(token2Tokens);
                        token2Tokens = IBEP20(TOKEN2).balanceOf(address(this));
                        IBEP20(TOKEN2).transfer(deadAddress, token2Tokens);
                    }
                }
            }
            swapping = false;
        }
        // Buy or Sell Tax
        fees = 0;           // wallet to wallet 0 tax
        burntaxamount = 0;  // wallet to wallet 0 tax
        
        if(automatedMarketMakerPairs[from]) {                   // buy tax applied if buy
            if(_totalTaxIfBuying != 0) {
                fees = amount.mul(_totalTaxIfBuying).div(100);  // total fee amount
                burntaxamount=amount.mul(_BurnFee).div(100);    // burn amount aside
                fees=fees.sub(burntaxamount);                   // fee is total amount minus burn
            }                   
        } else if(automatedMarketMakerPairs[to]) {          // sell tax applied if sell
            if(_totalTaxIfSelling != 0) {
                fees = amount.mul(_totalTaxIfSelling).div(100); // total fee amount
                burntaxamount=amount.mul(_BurnFee).div(100);    // burn amount aside
                fees=fees.sub(burntaxamount);                   // fee is total amount minus burn
            }
        }

        bool takeFee = !swapping;
        if(isExcludedFromFees[from] || isExcludedFromFees[to] || fees == 0) {takeFee = false;} // if any account belongs to _isExcludedFromFee account or fee = 0 then remove the fee
        
        if(takeFee) {
            if (burntaxamount != 0) {super._burn(from,burntaxamount);}    // burn amount 
            amount = amount.sub(fees).sub(burntaxamount);
            super._transfer(from, address(this), fees);
        }
        
        if(to == address(deadAddress)) {super._burn(from,amount);}    // if destination address is Deadwallet, burn amount 
        else if(to != address(deadAddress)) {super._transfer(from, to, amount);}
        
            try dividendTracker1.setBalance(payable(from), balanceOf(from)) {} catch {}
            try dividendTracker1.setBalance(payable(to), balanceOf(to)) {} catch {}
            try dividendTracker2.setBalance(payable(from), balanceOf(from)) {} catch {}
            try dividendTracker2.setBalance(payable(to), balanceOf(to)) {} catch {}

        if(!swapping) {
	    	uint256 gas = gasForProcessing;
 
                try dividendTracker1.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
                    emit ProcesseddividendTracker1(iterations, claims, lastProcessedIndex, true, gas, msg.sender);} catch {}
                try dividendTracker2.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
	    		    emit ProcesseddividendTracker2(iterations, claims, lastProcessedIndex, true, gas, msg.sender);} catch {}
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
        uniswapV2Router.addLiquidityETH{value: bnbAmount}(address(this), tokenAmount, 0, 0, deadAddress, block.timestamp);
    }
 
    function swapTokensForBNB(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
    }
 
    function swapTokensForTOKEN2(uint256 _tokenAmount) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = address(TOKEN2);
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(_tokenAmount, 0, path, address(this), block.timestamp);
    }

    function swapTokensForTOKEN1(uint256 _tokenAmount) private {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = address(TOKEN1);
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(_tokenAmount, 0, path, address(this), block.timestamp);
    }
 
    function swapAndSendDividends2(uint256 tokens) private {
        swapTokensForTOKEN2(tokens);
        token2Tokens = IBEP20(TOKEN2).balanceOf(address(this));
        transferDividends( address(dividendTracker2), dividendTracker2, token2Tokens, TOKEN2);
    }
  
    function swapAndSendDividends1(uint256 tokens) private {
        swapTokensForTOKEN1(tokens);
        token1Tokens = IBEP20(TOKEN1).balanceOf(address(this));
        transferDividends( address(dividendTracker1), dividendTracker1, token1Tokens, TOKEN1);
    }
 
    function transferDividends(address dividendTracker, DividendPayingToken dividendPayingTracker, uint256 amount, IBEP20 token) private {
        bool success = IBEP20(token).transfer(dividendTracker, amount);
 
        if (success) {
            dividendPayingTracker.distributeDividends(amount);
            emit SendDividends(amount);
        }
    }
}

contract DividendPayingToken is BEP20, Ownable, IDividendPayingToken, IDividendPayingTokenOptional {
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
 
    constructor(string memory _name, string memory _symbol, address _token) BEP20(_name, _symbol) {dividendToken = _token;}
 
    function distributeDividends(uint256 amount) public onlyOwner {
        require(totalSupply() > 0);
 
        if (amount > 0) {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add((amount).mul(magnitude) / totalSupply());
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
    
            bool success = IBEP20(dividendToken).transfer(user, _withdrawableDividend);
      
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
        return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe().add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
    }
 
    function _transfer(address from, address to, uint256 value) internal virtual override {
        require(false);
        int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
        magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
        magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
    }
 
    function _mint(address account, uint256 value) internal override {
        super._mint(account, value);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
    }
 
    function _burn(address account, uint256 value) internal override {
        super._burn(account, value);
        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
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

contract DIVIDENDTracker2 is DividendPayingToken {
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
 
    // BNB           P  0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
    //               T  0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd
    // BUSD          P  0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56
    //               T  0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7
    // USDT          P  0x55d398326f99059fF775485246999027B3197955
    //               T  0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684
    // MATIC            0xCC42724C6683B7E57334c4E856f4c9965ED682bD
    // ETH              0x2170Ed0880ac9A755fd29B2688956BD959F933F8
    // XRP           P  0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE
    // CAKE          P  0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82
    //               T  0xF9f93cF501BFaDB6494589Cb4b4C15dE49E85D0e
    // BTCB          P  0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c
    // ADA              0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47
    // SOL              0x570A5D26f7765Ecb712C0924E4De545B89fD43dF
    // AVAX             0x1CE0c2827e2eF14D5C4f29a091d735A204794041
    // MoonWalk      T  0xdf284410581f94a5D1b991D30b08dB72FCA94208
    // MoonWalk      P  0x9e566A4A22dCAfeF7De5d829Fd199d297Bb01487
    // EarthWalk
    // SunWalk
    // SatnWalk
    
    constructor() DividendPayingToken("Dividend_Tracker_2", "Dividend_Tracker_2", 0xdf284410581f94a5D1b991D30b08dB72FCA94208) {
    	claimWait = 3600;
        minimumTokenBalanceForDividends = 10000 * 10**9; //must hold 10000+ tokens
    }
 
    function _transfer(address, address, uint256) pure internal override {
        require(false, "Dividend_Tracker_2: No transfers allowed");
    }
 
    function withdrawDividend() pure public override {
        require(false, "Dividend_Tracker_2: withdrawDividend disabled. Use the 'claim' function on the main contract.");
    }
 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
    //    require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * 10**9;
    }
 
    function excludeFromDividends(address account) external onlyOwner {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
 
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "Dividend_Tracker_2: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "Dividend_Tracker_2: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) {return lastProcessedIndex;}
    function getNumberOfTokenHolders() external view returns(uint256) {return tokenHoldersMap.keys.length;}
 
    function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed, uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime, uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
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
        public view returns (address, int256, int256, uint256, uint256, uint256, uint256, uint256) {
    	if(index >= tokenHoldersMap.size()) {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
        address account = tokenHoldersMap.getKeyAtIndex(index);
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
    	if(lastClaimTime > block.timestamp)  {return false;}
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
    	if(excludedFromDividends[account]) {return;}
 
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
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {_lastProcessedIndex = 0;}
 
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account])) {
    			if(processAccount(payable(account), true)) {claims++;}
    		}
 
    		iterations++;
    		uint256 newGasLeft = gasleft();
 
    		if(gasLeft > newGasLeft) {gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));}
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
 
contract DIVIDENDTracker1 is DividendPayingToken {
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

    // BNB           P  0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
    //               T  0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd
    // BUSD          P  0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56
    //               T  0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7
    // USDT          P  0x55d398326f99059fF775485246999027B3197955
    //               T  0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684
    // MATIC            0xCC42724C6683B7E57334c4E856f4c9965ED682bD
    // ETH              0x2170Ed0880ac9A755fd29B2688956BD959F933F8
    // XRP           P  0x1D2F0da169ceB9fC7B3144628dB156f3F6c60dBE
    // CAKE          P  0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82
    //               T  0xF9f93cF501BFaDB6494589Cb4b4C15dE49E85D0e
    // BTCB          P  0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c
    // ADA              0x3EE2200Efb3400fAbB9AacF31297cBdD1d435D47
    // SOL              0x570A5D26f7765Ecb712C0924E4De545B89fD43dF
    // AVAX             0x1CE0c2827e2eF14D5C4f29a091d735A204794041
    // MoonWalk      T  0xdf284410581f94a5D1b991D30b08dB72FCA94208
    // MoonWalk      P  0x9e566A4A22dCAfeF7De5d829Fd199d297Bb01487
    // EarthWalk
    // SunWalk
    // SatnWalk

    constructor() DividendPayingToken("Dividend_Tracker_1", "Dividend_Tracker_1", 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7) {
    	claimWait = 3600;
        minimumTokenBalanceForDividends = 10000 * 10**9; //must hold 10000+ tokens
    }
 
    function _transfer(address, address, uint256) pure internal override {
        require(false, "Dividend_Tracker_1: No transfers allowed");
    }
 
    function withdrawDividend() pure public override {
        require(false, "Dividend_Tracker_1: withdrawDividend disabled. Use the 'claim' function on the main contract.");
    }
 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner {
    //    require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * 10**9;
    }
 
    function excludeFromDividends(address account) external onlyOwner {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "Dividend_Tracker_1: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "Dividend_Tracker_1: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) {return lastProcessedIndex;}
    function getNumberOfTokenHolders() external view returns(uint256) {return tokenHoldersMap.keys.length;}
 
    function getAccount(address _account)
        public view returns ( address account, int256 index, int256 iterationsUntilProcessed, uint256 withdrawableDividends, uint256 totalDividends, uint256 lastClaimTime, uint256 nextClaimTime, uint256 secondsUntilAutoClaimAvailable) {
        account = _account;
        index = tokenHoldersMap.getIndexOfKey(account);
        iterationsUntilProcessed = -1;
 
        if(index >= 0) {
            if(uint256(index) > lastProcessedIndex) {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            } else {
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
        public view returns (address, int256, int256, uint256, uint256, uint256, uint256, uint256) {
    	if(index >= tokenHoldersMap.size()) {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
        address account = tokenHoldersMap.getKeyAtIndex(index);
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
    	if(lastClaimTime > block.timestamp)  {return false;}
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner {
    	if(excludedFromDividends[account]) {return;}
 
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
 
    	if(numberOfTokenHolders == 0) {return (0, 0, lastProcessedIndex);}
 
    	uint256 _lastProcessedIndex = lastProcessedIndex;
    	uint256 gasUsed = 0;
    	uint256 gasLeft = gasleft();
    	uint256 iterations = 0;
    	uint256 claims = 0;
 
    	while(gasUsed < gas && iterations < numberOfTokenHolders) {
    		_lastProcessedIndex++;
 
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {_lastProcessedIndex = 0;}
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account])) {
    			if(processAccount(payable(account), true)) {claims++;}
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