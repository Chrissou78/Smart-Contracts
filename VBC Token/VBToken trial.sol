/**
 *Submitted for verification at Etherscan.io on 2022-12-16
*/

/**
 *Submitted for verification at Etherscan.io on 2022-12-16
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The defaut value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    /** This function will be used to generate the total supply
    * while deploying the contract
    *
    * This function can never be called again after deploying contract
    */
    function _tokengeneration(address account, uint256 amount) internal virtual {
        _totalSupply = amount;
        _balances[account] = amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

library Address {
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface referralLogic {
    function referralBuy(address _buyer, uint256 _amount) external;
}

contract VBToken is ERC20, Ownable {
    using Address for address payable;

    IRouter public router;
    address public pair;
    address public referralContract;

    bool private _interlock = false;
    bool public providingLiquidity = false;
    bool public tradingEnabled = false;

    uint256 private supply;
    uint256 public tokenLiquidityThreshold = 21_000 * 10**18;
    uint256 public maxBuyLimit = 210_000 * 10**18;
    uint256 public maxSellLimit = 210_000 * 10**18;
    uint256 public maxWalletLimit = 210_000 * 10**18;

    uint256 public genesis_block;

    address public marketingWallet = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
    address public charityWallet = 0xe7c533355a7Fa04baf083C726a442db7Dc0971b1;
	address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;

    struct Taxes {
        uint256 marketing;
        uint256 liquidity;
        uint256 charity;
        uint256 burn;
    }

    Taxes public taxes = Taxes(1, 1, 1, 1);
    Taxes public sellTaxes = Taxes(2, 2, 2, 2);
    Taxes public transferTaxes = Taxes(0, 0, 0, 0);

    mapping(address => bool) public exemptFee;

    bool public referralActive = false;

    modifier lockTheSwap() {
        if (!_interlock) {
            _interlock = true;
            _;
            _interlock = false;
        }
    }

    constructor() ERC20("VB Charity", "VBC") {
        supply = 3_333_333_333_333 * 10**decimals();
        _tokengeneration(msg.sender, supply);
        
        tokenLiquidityThreshold = supply * 1 / 1000;
        maxBuyLimit = supply * 1 / 100;
        maxSellLimit = supply * 1 / 100;
        maxWalletLimit = supply * 2 / 100;


        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());

        router = _router;
        pair = _pair;

        exemptFee[msg.sender] = true;
        exemptFee[address(this)] = true;
        exemptFee[marketingWallet] = true;
        exemptFee[charityWallet] = true;
        exemptFee[deadWallet] = true;

    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        return true;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(amount > 0, "Transfer amount must be greater than zero");

        if (!exemptFee[sender] && !exemptFee[recipient]) {require(tradingEnabled, "Trading not enabled");}

        if (sender == pair && !exemptFee[recipient] && !_interlock) {
            require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
            require(balanceOf(recipient) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");
        }

        if (sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock) {
            require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
            if (recipient != pair) {require(balanceOf(recipient) + amount <= maxWalletLimit, "You are exceeding maxWalletLimit");}
        }
        //Referral logic
        if(sender == pair && referralActive) {referralLogic(referralContract).referralBuy(recipient, amount);}

        uint256 feeswap;
        uint256 feesum;
        uint256 fee;
        Taxes memory currentTaxes;

        //set fee to zero if fees in contract are handled or exempted
        if (_interlock || exemptFee[sender] || exemptFee[recipient])
            fee = 0;
            //calculate fee
        else if (recipient == pair) {
            feeswap = sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.charity + sellTaxes.burn;
            feesum = feeswap;
            currentTaxes = sellTaxes;
        } else if (sender == pair) {
            feeswap = taxes.liquidity + taxes.marketing + taxes.charity + taxes.burn ;
            feesum = feeswap;
            currentTaxes = taxes;
        } else {
            feeswap = transferTaxes.liquidity + transferTaxes.marketing + transferTaxes.charity + transferTaxes.burn ;
            feesum = feeswap;
            currentTaxes = transferTaxes;
        }
        fee = (amount * feesum) / 100;
        //send fees if threshold has been reached
        //don't do this on buys, breaks swap
        if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);

        //rest to recipient
        super._transfer(sender, recipient, amount - fee);
        if (fee > 0) {
            //send the fee to the contract
            if (feeswap > 0) {
                uint256 burnAmount = (amount * currentTaxes.burn) / 100;
                uint256 feeAmount = (amount * feeswap) / 100 - burnAmount;
                super._transfer(sender, address(this), feeAmount);
                super._transfer(sender, deadWallet, burnAmount);
            }

        }
    }

    function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {

        if(feeswap == 0){
            return;
        }

        uint256 contractBalance = balanceOf(address(this));
        if (contractBalance >= tokenLiquidityThreshold) {
            if (tokenLiquidityThreshold > 1) {contractBalance = tokenLiquidityThreshold;}
            // Split the contract balance into halves
            uint256 denominator = feeswap * 2;
            uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) / denominator;
            uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
            uint256 initialBalance = address(this).balance;
            swapTokensForETH(toSwap);
            uint256 deltaBalance = address(this).balance - initialBalance;
            uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
            uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
            if (ethToAddLiquidityWith > 0) {addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);}
            
            uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
            if (marketingAmt > 0) {payable(marketingWallet).sendValue(marketingAmt);}
            uint256 charityAmt = unitBalance * 2 * swapTaxes.charity;
            if (charityAmt > 0) {payable(charityWallet).sendValue(charityAmt);}
        }    
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        // generate the pancake pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        _approve(address(this), address(router), tokenAmount);
        // make the swap
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(router), tokenAmount);

        // add the liquidity
        router.addLiquidityETH{ value: ethAmount }(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            deadWallet,
            block.timestamp
        );
    }

    function updateLiquidityProvide(bool state) external onlyOwner {
        //update liquidity providing state
        providingLiquidity = state;
    }

    function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
        //update the treshhold
        require(new_amount <= 420_000 && new_amount > 0, "Swap threshold amount should be lower or euqal to 1% of tokens");
        tokenLiquidityThreshold = new_amount * 10**decimals();
    }

    function SetBuyTaxes(uint256 _marketing, uint256 _liquidity, uint256 _charity, uint256 _burn) external onlyOwner {
        taxes = Taxes(_marketing, _liquidity, _charity, _burn);
        require((_marketing + _liquidity + _charity + _burn) <= 12, "Must keep fees at 12% or less");
    }

    function SetSellTaxes(uint256 _marketing, uint256 _liquidity, uint256 _charity, uint256 _burn) external onlyOwner {
        sellTaxes = Taxes(_marketing, _liquidity, _charity, _burn);
        require((_marketing + _liquidity + _charity + _burn) <= 12, "Must keep fees at 12% or less");
    }

    function SetTransferTaxes(uint256 _marketing, uint256 _liquidity, uint256 _charity, uint256 _burn) external onlyOwner {
        transferTaxes = Taxes(_marketing, _liquidity, _charity, _burn);
        require((_marketing + _liquidity + _charity + _burn) <= 12, "Must keep fees at 12% or less");
    }

    function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
        router = IRouter(newRouter);
        pair = newPair;
    }

    function updateReferralContract(address _newReferralContract) external onlyOwner {
        require(_newReferralContract != address(0),"Fee Address cannot be zero address");
        referralContract = _newReferralContract;
    }

    function toggleReferral(bool status) external onlyOwner{
        referralActive = status;
    }

    function _openTrading() external onlyOwner {
        require(!tradingEnabled, "Cannot re-enable trading");
        tradingEnabled = true;
        providingLiquidity = true;
        genesis_block = block.number;
    }

    function _toggleTrading(bool status) external onlyOwner {
        tradingEnabled = status;
    }

    function updateMarketingWallet(address newMarketingWallet, address newCharityWallet) external onlyOwner {
        require(newMarketingWallet != address(0),"Fee Address cannot be zero address");
        require(newCharityWallet != address(0),"Fee Address cannot be zero address");
        marketingWallet = newMarketingWallet;
        charityWallet = newCharityWallet;
    }

    function updateExemptFee(address _address, bool state) external onlyOwner {
        exemptFee[_address] = state;
    }

    function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            exemptFee[accounts[i]] = state;
        }
    }

    function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
        require(maxBuy >= 21_000, "Cannot set max buy amount lower than 0.1%");
        require(maxSell >= 21_000, "Cannot set max sell amount lower than 0.1%");
        require(maxWallet >= 210_000, "Cannot set max wallet amount lower than 1%");
        maxBuyLimit = maxBuy * 10**decimals();
        maxSellLimit = maxSell * 10**decimals();
        maxWalletLimit = maxWallet * 10**decimals(); 
    }

    function rescueBNB(uint256 weiAmount) external onlyOwner {
        payable(owner()).transfer(weiAmount);
    }

    function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
        require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
        IERC20(tokenAdd).transfer(owner(), amount);
    }

    // fallbacks
    receive() external payable {}
}