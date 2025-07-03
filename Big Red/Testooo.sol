// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

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

interface IJoeFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

interface IJoeRouter02 {
    function swapExactTokensForAVAXSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function factory() external pure returns (address);
    function WAVAX() external pure returns (address);
    function addLiquidityAVAX ( address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountAVAXMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountAVAX, uint256 liquidity);
}

contract Testooo is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    address payable private _taxWallet;
    address private Router = 0x60aE616a2155Ee3d9A68541Ba4544862310933d4; //0x60aE616a2155Ee3d9A68541Ba4544862310933d4 P //0xd7f655E3376cE2D7A2b08fF01Eb3B1023191A901 T

    address private DeadWallet = 0x000000000000000000000000000000000000dEaD; 
    address private ZeroWallet = 0x0000000000000000000000000000000000000000; 
    uint256 private _initialBuyTax=25;
    uint256 private _initialSellTax=25;
    uint256 private _finalBuyTax=3;
    uint256 private _finalSellTax=3;
    uint256 private _initialmaxTXAmount = 10_000_000_000;
    uint256 private _finalmaxTXAmount = 1_000_000_000_000;
    uint256 private _initialmaxWalletSize = 10_000_000_000;
    uint256 private _finalmaxWalletSize = 1_000_000_000_000;
    
    uint256 private _reduceBuyTaxAt=100;
    uint256 private _reduceSellTaxAt=100;
    uint256 private _preventSwapBefore=120;
    uint256 private _buyCount=0;

    uint8 private _decimals = 9;
    uint256 private _tTotal = 1_000_000_000_000 * 10**_decimals;
    string private _name = unicode"Testooo";
    string private _symbol = unicode"$Tooo";
    uint256 public _maxTxAmount = _initialmaxTXAmount * 10**_decimals;
    uint256 public _maxWalletSize = _initialmaxWalletSize * 10**_decimals;
    uint256 public _taxSwapThreshold= 100_000_000 * 10**_decimals;
    uint256 public _maxTaxSwap= 10_000_000_000 * 10**_decimals;

    IJoeRouter02 public JoeV2Router;
    address public JoeV2Pair;
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
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;
	    _isExcludedFromFee[DeadWallet] = true;
	    _isExcludedFromFee[ZeroWallet] = true;
        
        IJoeRouter02 _JoeV2Router = IJoeRouter02(Router);
        JoeV2Router = _JoeV2Router;
        address _JoeV2Pair = IJoeFactory(_JoeV2Router.factory()).createPair(address(this), _JoeV2Router.WAVAX());
        JoeV2Pair = _JoeV2Pair;
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    receive() external payable {}
    
    function name() public view returns (string memory) {return _name;}
    function symbol() public view returns (string memory) {return _symbol;}
    function decimals() public view returns (uint8) {return _decimals;}
    function totalSupply() public view override returns (uint256) {return _tTotal;}
    function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
    function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
    function min(uint256 a, uint256 b) private pure returns (uint256){return (a>b)?b:a;}
    function sendAVAXToFee(uint256 amount) private {_taxWallet.transfer(amount);}

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

            if(_buyCount == _reduceBuyTaxAt) {
                _maxTxAmount = _finalmaxTXAmount * 10**_decimals;
                _maxWalletSize = _finalmaxWalletSize * 10**_decimals;
            }

            if (from == JoeV2Pair && to != address(JoeV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
                _buyCount++;
            }
            
            if(to == JoeV2Pair && ! _isExcludedFromFee[from]) {taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);}

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == JoeV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
                swapTokensForAvax(min(amount,min(contractTokenBalance,_maxTaxSwap)));
                uint256 contractAVAXBalance = address(this).balance;
                if(contractAVAXBalance > 0) {sendAVAXToFee(address(this).balance);}
            }
        }

        if(taxAmount>0){
          _balances[address(this)]=_balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from]=_balances[from].sub(amount);
        _balances[to]=_balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function swapTokensForAvax(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = JoeV2Router.WAVAX();
        _approve(address(this), address(JoeV2Router), tokenAmount);
        JoeV2Router.swapExactTokensForAVAXSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
    }
    
    function openTrading() external onlyOwner() {
        _approve(address(this), address(JoeV2Router), _tTotal);
        JoeV2Router.addLiquidityAVAX{value: address(this).balance}(address(this), balanceOf(address(this)) *(100 - _initialBuyTax) / 100, 0, 0, owner(), block.timestamp);
        IERC20(JoeV2Pair).approve(address(JoeV2Router), type(uint).max);
        IERC20(JoeV2Pair).approve(address(JoeV2Router), type(uint).max);
        swapEnabled = true;
    }
    
    function ChangeRouter (address router) external onlyOwner {
        IJoeRouter02 _JoeV2Router = IJoeRouter02(router);
        JoeV2Router = _JoeV2Router;
    }

    function manualSwap() external onlyOwner {
        uint256 tokenBalance=balanceOf(address(this));
        if(tokenBalance>0){swapTokensForAvax(tokenBalance);}
        uint256 avaxBalance=address(this).balance;
        if(avaxBalance>0){sendAVAXToFee(avaxBalance);}
    }
}