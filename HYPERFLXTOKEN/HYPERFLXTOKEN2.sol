// SPDX-License-Identifier: MIT

//*************************************************************************************************//

// Website : https://hyperflxtoken.com/
// TG : https://t.me/hyperflxtoken

//*************************************************************************************************//

        pragma solidity 0.8.15;

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
            
            function name() external view returns (string memory);
            function symbol() external view returns (string memory);
            function decimals() external view returns (uint8);
        }

        contract ERC20 is Context, IERC20, IERC20Metadata {
            mapping(address => uint256) private _balances;
            mapping(address => mapping(address => uint256)) private _allowances;

            uint256 private _totalSupply;
            string private _name;
            string private _symbol;

            constructor(string memory name_, string memory symbol_) {
                _name = name_;
                _symbol = symbol_;
            }

            function name() public view virtual override returns (string memory) {
                return _name;
            }

            function symbol() public view virtual override returns (string memory) {
                return _symbol;
            }

            function decimals() public view virtual override returns (uint8) {
                return 18;
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

            function transferFrom(
                address sender,
                address recipient,
                uint256 amount
            ) public virtual override returns (bool) {
                _transfer(sender, recipient, amount);

                uint256 currentAllowance = _allowances[sender][_msgSender()];
                require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
                unchecked {
                    _approve(sender, _msgSender(), currentAllowance - amount);
                }

                return true;
            }

            function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
                _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
                return true;
            }

            function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
                uint256 currentAllowance = _allowances[_msgSender()][spender];
                require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
                unchecked {
                    _approve(_msgSender(), spender, currentAllowance - subtractedValue);
                }

                return true;
            }

            function _transfer(
                address sender,
                address recipient,
                uint256 amount
            ) internal virtual {
                require(sender != address(0), "ERC20: transfer from the zero address");
                require(recipient != address(0), "ERC20: transfer to the zero address");

                uint256 senderBalance = _balances[sender];
                require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
                unchecked {
                    _balances[sender] = senderBalance - amount;
                }
                _balances[recipient] += amount;

                emit Transfer(sender, recipient, amount);
            }

            function _createInitialSupply(address account, uint256 amount) internal virtual {
                require(account != address(0), "ERC20: mint to the zero address");

                _totalSupply += amount;
                _balances[account] += amount;
                emit Transfer(address(0), account, amount);
            }

            function _burn(address account, uint256 amount) internal virtual {
                require(account != address(0), "ERC20: burn from the zero address");
                uint256 accountBalance = _balances[account];
                require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
                unchecked {
                    _balances[account] = accountBalance - amount;
                    // Overflow not possible: amount <= accountBalance <= totalSupply.
                    _totalSupply -= amount;
                }

                emit Transfer(account, address(0), amount);
            }

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

        contract Ownable is Context {
            address private _owner;

            event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

            constructor () {
                address msgSender = _msgSender();
                _owner = msgSender;
                emit OwnershipTransferred(address(0), msgSender);
            }

            function owner() public view returns (address) {
                return _owner;
            }

            modifier onlyOwner() {
                require(_owner == _msgSender(), "Ownable: caller is not the owner");
                _;
            }

            function renounceOwnership() external virtual onlyOwner {
                emit OwnershipTransferred(_owner, address(0));
                _owner = address(0);
            }

            function transferOwnership(address newOwner) public virtual onlyOwner {
                require(newOwner != address(0), "Ownable: new owner is the zero address");
                emit OwnershipTransferred(_owner, newOwner);
                _owner = newOwner;
            }
        }

        interface IDexRouter {
            function factory() external pure returns (address);
            function WETH() external pure returns (address);

            function swapExactTokensForETHSupportingFeeOnTransferTokens(
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
        }

        interface IDexFactory {
            function createPair(address tokenA, address tokenB)
                external
                returns (address pair);
        }

        contract HyperFlxToken is ERC20, Ownable {

            uint256 public maxBuyAmount;
            uint256 public maxSellAmount;
            uint256 public maxWalletAmount;

            IDexRouter public dexRouter;
            address public lpPair;

            bool private swapping;
            uint256 public swapTokensAtAmount;

            address operationsAddress;
            address devAddress;

            uint256 public tradingActiveBlock = 0; // 0 means trading is not active

            bool public tradingActive = false;
            bool public swapEnabled = false;
            bool private JeetsFee = true;
            uint8 private VminDiv = 1;
            uint8 private VmaxDiv = 15;
            uint8 private MaxJeetsFee = 30;

            uint256 public buyTotalFees;
            uint256 public buyOperationsFee;
            uint256 public buyLiquidityFee;
            uint256 public buyDevFee;
            uint256 public buyBurnFee;

            uint256 public sellTotalFees;
            uint256 public sellOperationsFee;
            uint256 public sellLiquidityFee;
            uint256 public sellDevFee;
            uint256 public sellBurnFee;

            uint256 public tokensForOperations;
            uint256 public tokensForLiquidity;
            uint256 public tokensForDev;
            uint256 public tokensForBurn;

            /******************/

            // exlcude from fees and max transaction amount
            mapping (address => bool) private _isExcludedFromFees;
            mapping (address => bool) public _isExcludedMaxTransactionAmount;

            // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
            // could be subject to a maximum transfer amount
            mapping (address => bool) public automatedMarketMakerPairs;

            event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
            event EnabledTrading();
            event RemovedLimits();
            event ExcludeFromFees(address indexed account, bool isExcluded);
            event UpdatedMaxBuyAmount(uint256 newAmount);
            event UpdatedMaxSellAmount(uint256 newAmount);
            event UpdatedMaxWalletAmount(uint256 newAmount);
            event MaxTransactionExclusion(address _address, bool excluded);
            event BuyBackTriggered(uint256 amount);
            event OwnerForcedSwapBack(uint256 timestamp);
            event JeetTaxChanged (uint8 Maxdiv, uint8 Mindiv, uint8 Jeetsfee);

            event SwapAndLiquify(
                uint256 tokensSwapped,
                uint256 ethReceived,
                uint256 tokensIntoLiquidity
            );

            event TransferForeignToken(address token, uint256 amount);

            constructor() ERC20("HyperFlxToken", "HYFX") {

                address newOwner = msg.sender; // can leave alone if owner is deployer.

                IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
                dexRouter = _dexRouter;

                // create pair
                lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
                _excludeFromMaxTransaction(address(lpPair), true);
                _setAutomatedMarketMakerPair(address(lpPair), true);

                uint256 totalSupply = 250_000_000_000 * 1e18;

                maxBuyAmount = totalSupply * 4 / 100;
                maxSellAmount = totalSupply * 2 / 100;
                maxWalletAmount = totalSupply * 4 / 100;
                swapTokensAtAmount = totalSupply * 5 / 10000;

                buyOperationsFee = 0;
                buyLiquidityFee = 2;
                buyDevFee = 0;
                buyBurnFee = 0;
                buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;

                sellOperationsFee = 0;
                sellLiquidityFee = 2;
                sellDevFee = 0;
                sellBurnFee = 0;
                sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;

                _excludeFromMaxTransaction(newOwner, true);
                _excludeFromMaxTransaction(address(this), true);
                _excludeFromMaxTransaction(address(0xdead), true);

                excludeFromFees(newOwner, true);
                excludeFromFees(address(this), true);
                excludeFromFees(address(0xdead), true);

                operationsAddress = address(newOwner);
                devAddress = address(newOwner);

                _createInitialSupply(newOwner, totalSupply);
                transferOwnership(newOwner);
            }

            receive() external payable {}

            // only enable if no plan to airdrop

            function enableTrading() external onlyOwner {
                require(!tradingActive, "Cannot reenable trading");
                tradingActive = true;
                swapEnabled = true;
                tradingActiveBlock = block.number;
                emit EnabledTrading();
            }

            function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
                require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
                maxBuyAmount = newNum * (10**18);
                emit UpdatedMaxBuyAmount(maxBuyAmount);
            }

            function updateMaxSellAmount(uint256 newNum) external onlyOwner {
                require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
                maxSellAmount = newNum * (10**18);
                emit UpdatedMaxSellAmount(maxSellAmount);
            }

            function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
                require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
                maxWalletAmount = newNum * (10**18);
                emit UpdatedMaxWalletAmount(maxWalletAmount);
            }

            function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
                require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
                require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
                swapTokensAtAmount = newAmount;
            }

            function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
                _isExcludedMaxTransactionAmount[updAds] = isExcluded;
                emit MaxTransactionExclusion(updAds, isExcluded);
            }

            function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
                require(wallets.length == amountsInTokens.length, "arrays must be the same length");
                require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
                for(uint256 i = 0; i < wallets.length; i++){
                    address wallet = wallets[i];
                    uint256 amount = amountsInTokens[i];
                    super._transfer(msg.sender, wallet, amount);
                }
            }

            function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
                if(!isEx){
                    require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
                }
                _isExcludedMaxTransactionAmount[updAds] = isEx;
            }

            function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
                require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");

                _setAutomatedMarketMakerPair(pair, value);
                emit SetAutomatedMarketMakerPair(pair, value);
            }

            function _setAutomatedMarketMakerPair(address pair, bool value) private {
                automatedMarketMakerPairs[pair] = value;

                _excludeFromMaxTransaction(pair, value);

                emit SetAutomatedMarketMakerPair(pair, value);
            }

            function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
                buyOperationsFee = _operationsFee;
                buyLiquidityFee = _liquidityFee;
                buyDevFee = _DevFee;
                buyBurnFee = _burnFee;
                buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
                require(buyTotalFees <= 20, "Must keep fees at 20% or less");
            }

            function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
                sellOperationsFee = _operationsFee;
                sellLiquidityFee = _liquidityFee;
                sellDevFee = _DevFee;
                sellBurnFee = _burnFee;
                sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
                require(sellTotalFees <= 20, "Must keep fees at 20% or less");
            }

            function returnToNormalTax() external onlyOwner {
                sellOperationsFee = 0;
                sellLiquidityFee = 2;
                sellDevFee = 0;
                sellBurnFee = 0;
                sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
                require(sellTotalFees <= 10, "Must keep fees at 30% or less");

                buyOperationsFee = 0;
                buyLiquidityFee = 2;
                buyDevFee = 0;
                buyBurnFee = 0;
                buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
                require(buyTotalFees <= 10, "Must keep fees at 15% or less");
            }

            function excludeFromFees(address account, bool excluded) public onlyOwner {
                _isExcludedFromFees[account] = excluded;
                emit ExcludeFromFees(account, excluded);
            }

            function _transfer(address from, address to, uint256 amount) internal override {

                require(from != address(0), "ERC20: transfer from the zero address");
                require(to != address(0), "ERC20: transfer to the zero address");
                require(amount > 0, "amount must be greater than 0");

                if(!tradingActive){
                    require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
                }

                    if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
                        //when buy
                        if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
                                require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
                                require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
                        }
                        //when sell
                        else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
                                require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
                        }
                        else if (!_isExcludedMaxTransactionAmount[to]){
                            require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
                        }
                    }

                uint256 contractTokenBalance = balanceOf(address(this));

                bool canSwap = contractTokenBalance >= swapTokensAtAmount;

                if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
                    swapping = true;

                    swapBack();

                    swapping = false;
                }

                bool takeFee = true;
                // if any account belongs to _isExcludedFromFee account then remove the fee
                if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
                    takeFee = false;
                }

                uint256 fees = 0;
                uint256 extraTax = 0;
                // only take fees on buys/sells, do not take on wallet transfers
                if(takeFee){
                    // on sell
                    if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
                        fees = amount * sellTotalFees / 100;
                        tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
                        tokensForOperations += fees * sellOperationsFee / sellTotalFees;
                        tokensForDev += fees * sellDevFee / sellTotalFees;
                        tokensForBurn += fees * sellBurnFee / sellTotalFees;
                        if (JeetsFee){ // Jeets extra Fee against massive dumpers
                            extraTax = JeetsSellTax(amount);
                            if (extraTax > 0) {
                                amount -= extraTax;
                                super._burn(from, extraTax);
                            }
                        }
                    }
                    // on buy
                    else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                        fees = amount * buyTotalFees / 100;
                        tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
                        tokensForOperations += fees * buyOperationsFee / buyTotalFees;
                        tokensForDev += fees * buyDevFee / buyTotalFees;
                        tokensForBurn += fees * buyBurnFee / buyTotalFees;
                    }

                    if(fees > 0){
                        super._transfer(from, address(this), fees);
                    }

                    amount -= fees;
                }

                super._transfer(from, to, amount);
            }

            function swapTokensForEth(uint256 tokenAmount) private {

                // generate the uniswap pair path of token -> weth
                address[] memory path = new address[](2);
                path[0] = address(this);
                path[1] = dexRouter.WETH();

                _approve(address(this), address(dexRouter), tokenAmount);

                // make the swap
                dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
                    tokenAmount,
                    0, // accept any amount of ETH
                    path,
                    address(this),
                    block.timestamp
                );
            }

            function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
                // approve token transfer to cover all possible scenarios
                _approve(address(this), address(dexRouter), tokenAmount);

                // add the liquidity
                dexRouter.addLiquidityETH{value: ethAmount}(
                    address(this),
                    tokenAmount,
                    0, // slippage is unavoidable
                    0, // slippage is unavoidable
                    address(0xdead),
                    block.timestamp
                );
            }

            function swapBack() private {

                if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
                    _burn(address(this), tokensForBurn);
                }
                tokensForBurn = 0;

                uint256 contractBalance = balanceOf(address(this));
                uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;

                if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

                if(contractBalance > swapTokensAtAmount * 20){
                    contractBalance = swapTokensAtAmount * 20;
                }

                bool success;

                // Halve the amount of liquidity tokens
                uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;

                swapTokensForEth(contractBalance - liquidityTokens);

                uint256 ethBalance = address(this).balance;
                uint256 ethForLiquidity = ethBalance;

                uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
                uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));

                ethForLiquidity -= ethForOperations + ethForDev;

                tokensForLiquidity = 0;
                tokensForOperations = 0;
                tokensForDev = 0;
                tokensForBurn = 0;

                if(liquidityTokens > 0 && ethForLiquidity > 0){
                    addLiquidity(liquidityTokens, ethForLiquidity);
                }

                (success,) = address(devAddress).call{value: ethForDev}("");

                (success,) = address(operationsAddress).call{value: address(this).balance}("");
            }

            function SetJeetsTax(bool jeetsfee, uint8 vmaxdiv, uint8 vmindiv, uint8 maxjeetsfee)  external onlyOwner {
                require (vmaxdiv >= 10 && vmaxdiv <= 40, "cannot set Vmax outside 10%/40% ratio");
                require (vmindiv >= 1 && vmindiv <= 10, "cannot set Vmin outside 1%/10% ratio");
                require (maxjeetsfee >= 1 && maxjeetsfee <= 40, "max jeets fee must be betwwen 1% and 40%");
                JeetsFee = jeetsfee;
                VmaxDiv = vmaxdiv;
                VminDiv = vmindiv;
                MaxJeetsFee = maxjeetsfee;
                emit JeetTaxChanged (vmaxdiv, vmindiv, maxjeetsfee);
            }

            function JeetsSellTax (uint256 amount) internal view returns (uint256) {
                uint256 value = balanceOf(lpPair);
                uint256 vMin = value * VminDiv / 100;
                uint256 vMax = value * VmaxDiv / 100;
                if (amount <= vMin) return amount = 0;
                if (amount > vMax) return amount * MaxJeetsFee / 100;
                return (((amount-vMin) * MaxJeetsFee * amount) / (vMax-vMin)) / 100;
            }

            function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
                require(_token != address(0), "_token address cannot be 0");
                require(_token != address(this), "Can't withdraw native tokens");
                uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
                _sent = IERC20(_token).transfer(_to, _contractBalance);
                emit TransferForeignToken(_token, _contractBalance);
            }
            // withdraw ETH if stuck or someone sends to the address
            function withdrawStuckETH() external onlyOwner {
                bool success;
                (success,) = address(msg.sender).call{value: address(this).balance}("");
            }
            // force Swap back if slippage issues.
            function forceSwapBack() external onlyOwner {
                require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
                swapping = true;
                swapBack();
                swapping = false;
                emit OwnerForcedSwapBack(block.timestamp);
            }
            // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
            function buyBackTokens(uint256 amountInWei) external onlyOwner {
                require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");

                address[] memory path = new address[](2);
                path[0] = dexRouter.WETH();
                path[1] = address(this);

                // make the swap
                dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
                    0, // accept any amount of Ethereum
                    path,
                    address(0xdead),
                    block.timestamp
                );
                emit BuyBackTriggered(amountInWei);
            }
        }