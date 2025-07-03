// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != -1 || a != MIN_INT256);

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
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

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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

interface IPancakeSwapPair {
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

interface IPancakeSwapRouter{
		function factory() external pure returns (address);
		function WETH() external pure returns (address);

		function addLiquidity(
				address tokenA,
				address tokenB,
				uint amountADesired,
				uint amountBDesired,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB, uint liquidity);
		function addLiquidityETH(
				address token,
				uint amountTokenDesired,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
		function removeLiquidity(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETH(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external returns (uint amountToken, uint amountETH);
		function removeLiquidityWithPermit(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETHWithPermit(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountToken, uint amountETH);
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);
		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);

		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function removeLiquidityETHSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline
		) external returns (uint amountETH);
		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline,
			bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountETH);
	
		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
		function swapExactETHForTokensSupportingFeeOnTransferTokens(
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external payable;
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IPancakeSwapFactory {
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

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract REBASE is BEP20, Ownable {

    using SafeMath for uint256;
    using SafeMathInt for int256;

    event LogRebase(uint256 indexed epoch, uint256 totalSupply);

    //string public _name = "Rebase Token";
    //string public _symbol = "RT";
    //uint8 public _decimals = 9;

    IPancakeSwapPair public pairContract;
    mapping(address => bool) _isFeeExempt;

    modifier validRecipient(address to) {
        require(to != address(0x0));
        _;
    }

    uint256 public constant DECIMALS = 9;
    uint256 public constant MAX_UINT256 = ~uint256(0);
    uint256 public constant RATE_DECIMALS = DECIMALS + 2;

    uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 1000 * 10**DECIMALS;

    uint256 public liquidityFee = 4;
    uint256 public treasuryFee = 2;
    uint256 public InsuranceFundFee = 5;
    uint256 public fieryfurnaceFee = 2;
    uint256 public buyFee = liquidityFee.add(treasuryFee).add(InsuranceFundFee).add(fieryfurnaceFee);
    uint256 public AddedsellFee = 2;
    uint256 public _Wallet2WalletFee = 0; // no wallet to wallet fee
    uint256 public feeDenominator = 100;

    uint256 public MaxSell; //0.2%
    uint256 public MaxWallet; //1%
    
    uint256 public MaxTaxes = 25;

    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;

    address public autoLiquidityReceiver;
    address public treasuryReceiver;
    address public InsuranceFundReceiver;
    address public fieryfurnace;
    address public pairAddress;
    address public PancakeRouter;

    IPancakeSwapRouter public router;
    address public pair;
    bool inSwap = false;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
    uint256 private constant MAX_SUPPLY = 10000000000 * 10**DECIMALS;

    bool public _autoRebase;
    bool public _autoAddLiquidity;
    uint256 public _initRebaseStartTime;
    uint256 public _lastRebasedTime;
    uint256 public _lastAddLiquidityTime;
    uint256 public _totalSupply;
    uint256 private _gonsPerFragment;

    mapping(address => uint256) private _gonBalances;
    mapping(address => bool) public _isBlacklisted; //blacklist function
    mapping(address => bool) private _isExcludedFromMaxTx;

    constructor() BEP20("Rebase Token","RT") Ownable() {

        autoLiquidityReceiver = 0x2Db96c4F203fBc13c98bBa428ba9E09B48543b0A;
        treasuryReceiver = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F; 
        InsuranceFundReceiver = 0x2Db96c4F203fBc13c98bBa428ba9E09B48543b0A;
        fieryfurnace = DEAD;
        
        if (block.chainid == 56) {
          PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        } else if (block.chainid == 97) {
          PancakeRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
        } else revert();
        
        router = IPancakeSwapRouter(PancakeRouter); 
        pair = IPancakeSwapFactory(router.factory()).createPair(router.WETH(), address(this));
        pairAddress = pair;
        pairContract = IPancakeSwapPair(pair);

        _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
        _gonBalances[treasuryReceiver] = TOTAL_GONS;
        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _initRebaseStartTime = block.timestamp;
        _lastRebasedTime = block.timestamp;
        _autoRebase = false; // don't start rebase at TGE
        _autoAddLiquidity = true;
        
        _isFeeExempt[treasuryReceiver] = true;
        _isFeeExempt[address(this)] = true;
        _isFeeExempt[autoLiquidityReceiver] = true;
        _isFeeExempt[InsuranceFundReceiver] = true;
        _isFeeExempt[fieryfurnace] = true;
        
        MaxSell = _totalSupply.mul(1).div(100); //1%
        MaxWallet = _totalSupply.mul(5).div(100); //5%

        // exclude from max tx
        _isExcludedFromMaxTx[address(this)] = true;
        _isExcludedFromMaxTx[DEAD] = true;
        _isExcludedFromMaxTx[InsuranceFundReceiver] = true;
        _isExcludedFromMaxTx[autoLiquidityReceiver] = true;
        _isExcludedFromMaxTx[treasuryReceiver] = true;
        _isExcludedFromMaxTx[fieryfurnace] = true;
        
        _transferOwnership(treasuryReceiver);
        emit Transfer(address(0x0), treasuryReceiver, _totalSupply);
    }

    function setExcludeFromMaxTx(address _address, bool value) private onlyOwner { 
        _isExcludedFromMaxTx[_address] = value;
    }
    
    function UpdateTaxes(uint256 liquidityfee, uint256 treasuryfee, uint256 insurancefundfee, uint256 fieryfurnacefee, uint256 addedsellfee, uint256 wallet2walletfee) external onlyOwner() {
        require(liquidityfee.add(treasuryfee).add(insurancefundfee).add(fieryfurnacefee).add(addedsellfee) <= MaxTaxes, "Total Tax can't exceed MaxTaxes.");
        require(liquidityfee >= 0 && treasuryfee >= 0 && insurancefundfee >= 0 && fieryfurnacefee >= 0 && addedsellfee >= 0,"No tax can be negative");
        require(wallet2walletfee >= 0 && wallet2walletfee <= MaxTaxes, "Wallet 2 Wallet Tax must be updated to between burn tax and 25 percent");
        
        liquidityFee = liquidityfee;
        treasuryFee = treasuryfee;
        InsuranceFundFee = insurancefundfee;
        fieryfurnaceFee = fieryfurnacefee;
        AddedsellFee = addedsellfee;
        buyFee = liquidityFee.add(treasuryFee).add(InsuranceFundFee).add(fieryfurnaceFee);
        _Wallet2WalletFee = wallet2walletfee;
    } 


    function setContractLimits(uint256 _maxWallet, uint256 _maxSell, uint256 MaxTax) public onlyOwner {
        uint256 supply = totalSupply ();
        require(_maxWallet >= supply / 100 && _maxWallet <= supply, "MawWallet must be between totalsupply and 1% of totalsupply");
        require(_maxSell >= supply / 1000 && _maxSell <= supply, "MawSell must be between totalsupply and 0.1% of totalsupply" );
        require(MaxTax >= 1 && MaxTax <= 25, "Max Tax must be updated to between 1 and 25 percent");
        
        MaxWallet = _maxWallet;
        MaxSell = _maxSell;
        MaxTaxes = MaxTax;
    }
    
    function rebase() internal {
        
        if ( inSwap ) return;
        uint256 rebaseRate;
        uint256 deltaTimeFromInit = block.timestamp - _initRebaseStartTime;
        uint256 deltaTime = block.timestamp - _lastRebasedTime;
        uint256 times = deltaTime.div(15 minutes);
        uint256 epoch = times.mul(15);

        if (deltaTimeFromInit < (365 days)) {
            rebaseRate = 2355;
        } else if (deltaTimeFromInit >= (365 days)) {
            rebaseRate = 211;
        } else if (deltaTimeFromInit >= ((15 * 365 days) / 10)) {
            rebaseRate = 14;
        } else if (deltaTimeFromInit >= (7 * 365 days)) {
            rebaseRate = 2;
        }

        for (uint256 i = 0; i < times; i++) {_totalSupply = _totalSupply.mul((10**RATE_DECIMALS).add(rebaseRate)).div(10**RATE_DECIMALS);}

        _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
        _lastRebasedTime = _lastRebasedTime.add(times.mul(15 minutes));

        pairContract.sync();

        emit LogRebase(epoch, _totalSupply);
    }

    function _basicTransfer(address from, address to, uint256 amount) internal {
        uint256 gonAmount = amount.mul(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].sub(gonAmount);
        _gonBalances[to] = _gonBalances[to].add(gonAmount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != ZERO, "transfer to the zero address");
        require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address"); //blacklist function

        // Max Wallet limitation
        if(recipient != InsuranceFundReceiver && recipient != address(this) && recipient != DEAD && recipient != autoLiquidityReceiver && recipient != pair && recipient != treasuryReceiver && recipient != fieryfurnace){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + amount) <= MaxWallet, "wallet amount exceed maxWalletAmount");
        }
        
        if(amount == 0) {
            super._transfer(sender, recipient, 0);
            return;
        }
        
        // Max sell limitation
        if(recipient == pair && (!_isExcludedFromMaxTx[sender]) && (!_isExcludedFromMaxTx[recipient])){  // sell limitation
            require(amount <= MaxSell, "Sell transfer amount exceeds the maxSellTransactionAmount.");
        }


        if (inSwap) {_basicTransfer(sender, recipient, amount);}
        if (shouldRebase()) {rebase();}
        if (shouldAddLiquidity()) {addLiquidity();}
        if (shouldSwapBack()) {swapBack();}

        uint256 gonAmount = amount.mul(_gonsPerFragment);
        _gonBalances[sender] = _gonBalances[sender].sub(gonAmount);
        uint256 gonAmountReceived = shouldTakeFee(sender, recipient)
            ? takeFee(sender, recipient, gonAmount)
            : gonAmount;
        _gonBalances[recipient] = _gonBalances[recipient].add(gonAmountReceived);
        emit Transfer(sender, recipient, gonAmountReceived.div(_gonsPerFragment));
    }

    function takeFee( address sender, address recipient, uint256 gonAmount) internal  returns (uint256) {
        uint256 _totalFee = 0;
        uint256 _treasuryFee = treasuryFee;

        if (recipient == pair) {
            _totalFee = buyFee.add(AddedsellFee);
            _treasuryFee = treasuryFee.add(AddedsellFee);
        } else if (sender == pair) {
            _totalFee = buyFee;
        } else if(sender != pair && recipient != pair && _Wallet2WalletFee != 0) {
            _totalFee = _Wallet2WalletFee;
        }

        uint256 feeAmount = gonAmount.div(feeDenominator).mul(_totalFee);

        if (_totalFee != 0) {
            _gonBalances[fieryfurnace] = _gonBalances[fieryfurnace].add(gonAmount.div(feeDenominator).mul(fieryfurnaceFee));
            _gonBalances[address(this)] = _gonBalances[address(this)].add(gonAmount.div(feeDenominator).mul(_treasuryFee.add(InsuranceFundFee)));
            _gonBalances[autoLiquidityReceiver] = _gonBalances[autoLiquidityReceiver].add(gonAmount.div(feeDenominator).mul(liquidityFee));
            emit Transfer(sender, address(this), feeAmount.div(_gonsPerFragment));
        }
        return gonAmount.sub(feeAmount);
    }

    function addLiquidity() internal swapping {
        uint256 autoLiquidityAmount = _gonBalances[autoLiquidityReceiver].div(_gonsPerFragment);
        _gonBalances[address(this)] = _gonBalances[address(this)].add(_gonBalances[autoLiquidityReceiver]);
        _gonBalances[autoLiquidityReceiver] = 0;
        uint256 amountToLiquify = autoLiquidityAmount.div(2);
        uint256 amountToSwap = autoLiquidityAmount.sub(amountToLiquify);

        if( amountToSwap == 0 ) {return;}
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToSwap, 0, path, address(this), block.timestamp);

        uint256 amountETHLiquidity = address(this).balance.sub(balanceBefore);

        if (amountToLiquify > 0&&amountETHLiquidity > 0) {router.addLiquidityETH{value: amountETHLiquidity}(address(this), amountToLiquify, 0, 0, autoLiquidityReceiver, block.timestamp);}
        _lastAddLiquidityTime = block.timestamp;
    }

    function swapBack() internal swapping {

        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);

        if( amountToSwap == 0) {return;}

        uint256 balanceBefore = address(this).balance;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToSwap, 0, path, address(this), block.timestamp);

        uint256 amountETHToTreasuryAndFIF = address(this).balance.sub(balanceBefore);

        (bool success, ) = payable(treasuryReceiver).call{value: amountETHToTreasuryAndFIF.mul(treasuryFee).div(treasuryFee.add(InsuranceFundFee)), gas: 30000}("");
        (success, ) = payable(InsuranceFundReceiver).call{value: amountETHToTreasuryAndFIF.mul(InsuranceFundFee).div(treasuryFee.add(InsuranceFundFee)), gas: 30000}("");
    }

    function withdrawAllToTreasury() external swapping onlyOwner {

        uint256 amountToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
        require( amountToSwap > 0,"There is no token deposited in token contract");
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(amountToSwap, 0, path, treasuryReceiver, block.timestamp);
    }

    function shouldTakeFee(address from, address to) internal view returns (bool) {return (pair == from || pair == to) && !_isFeeExempt[from];}
    function shouldRebase() internal view returns (bool) {return _autoRebase && (_totalSupply < MAX_SUPPLY) && msg.sender != pair  && !inSwap && block.timestamp >= (_lastRebasedTime + 15 minutes);}
    function shouldAddLiquidity() internal view returns (bool) {return _autoAddLiquidity && !inSwap && msg.sender != pair && block.timestamp >= (_lastAddLiquidityTime + 2 days);}
    function shouldSwapBack() internal view returns (bool) {return !inSwap && msg.sender != pair;}

    function setAutoRebase(bool _flag) external onlyOwner {
        if (_flag) {
            _autoRebase = _flag;
            _lastRebasedTime = block.timestamp;
        } else {
            _autoRebase = _flag;
        }
    }

    function setAutoAddLiquidity(bool _flag) external onlyOwner {
        if(_flag) {
            _autoAddLiquidity = _flag;
            _lastAddLiquidityTime = block.timestamp;
        } else {
            _autoAddLiquidity = _flag;
        }
    }

    function checkFeeExempt(address _addr) external view returns (bool) {return _isFeeExempt[_addr];}
    function getCirculatingSupply() public view returns (uint256) {return (TOTAL_GONS.sub(_gonBalances[DEAD]).sub(_gonBalances[ZERO])).div(_gonsPerFragment);}
    function isNotInSwap() external view returns (bool) {return !inSwap;}
    function manualSync() external {IPancakeSwapPair(pair).sync();}

    function setFeeReceivers(address _autoLiquidityReceiver, address _treasuryReceiver, address _InsuranceFundReceiver, address _fieryfurnace) external onlyOwner {
        
        autoLiquidityReceiver = _autoLiquidityReceiver;
        treasuryReceiver = _treasuryReceiver;
        InsuranceFundReceiver = _InsuranceFundReceiver;
        fieryfurnace = _fieryfurnace;
    }

    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        uint256 liquidityBalance = _gonBalances[pair].div(_gonsPerFragment);
        return accuracy.mul(liquidityBalance.mul(2)).div(getCirculatingSupply());
    }

    function setWhitelist(address _addr) external onlyOwner {_isFeeExempt[_addr] = true;}

    function blacklistAddress(address account, bool value) external onlyOwner { //blacklist function
        _isBlacklisted[account] = value;
    }
    
    function setPairAddress(address _pairAddress) public onlyOwner {pairAddress = _pairAddress;}
    function setLP(address _address) external onlyOwner {pairContract = IPancakeSwapPair(_address);}
    
    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    receive() external payable {}
}