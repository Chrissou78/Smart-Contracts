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

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {return payable(msg.sender);}
    function _msgData() internal view virtual returns (bytes calldata) {return msg.data;}
}

abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {_transferOwnership(_msgSender());}

    function owner() public view virtual returns (address) {return _owner;}

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {_transferOwnership(address(0));}

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {
 
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
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

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {size := extcodesize(account)} return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}
 
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
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

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
        if (success) {return returndata;
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

library SafeBEP20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {_callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));}
    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {_callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));}

    function safeApprove(IBEP20 token, address spender, uint256 value) internal {_callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));}

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

contract SafeToken is Ownable {
    address payable safeManager;
    constructor() {safeManager = payable(msg.sender);}
    function setSafeManager(address payable _safeManager) public onlyOwner {safeManager = _safeManager;}
    function withdraw(address _token, uint256 _amount) external { require(msg.sender == safeManager); IBEP20(_token).transfer(safeManager, _amount);}
    function withdrawBNB(uint256 _amount) external {require(msg.sender == safeManager); safeManager.transfer(_amount);}
}

contract EWStakingPool is Ownable, ReentrancyGuard, SafeToken {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    
    address private treasury = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
    uint256 private subEndBlock = 0;
    uint256 private subLengthDays = 60;
    address private subOperator;
    
    // staking fee info
    address private feeReceiver = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
    uint256 private MaxStakingFee = 5;
    uint256 private stakingFee = 0;
    uint256 private unstakingFee = 0;
    uint256 private subFee = 0;
    uint256 private EmergencyFee = 0;  
    uint256 private TransactionFee = 0;  

    bool private hasUserLimit;
    bool private isInitialized;
    uint256 public accTokenPerShare;
    uint256 public bonusEndBlock;
    uint256 public startBlock;
    uint256 public lastRewardBlock;
    uint256 private poolLimitPerUser;
    uint256 private rewardPerBlock;
    uint256 public PRECISION_FACTOR;
    IBEP20 public rewardToken;
    IBEP20 public stakedToken;
    uint256 public extraTokens;
    uint256 public totalNewReward;
    uint256 public totalStaked;
    uint256 private lockDays;
    uint256 public prevAndCurrentRewardsBalance;
    mapping(address => UserInfo) public userInfo;
    uint256 public stakedsupply;
    uint256 decimalsRewardToken;
    uint256 decimalsStakedToken;

    struct UserInfo {
        uint256 amount; // How many staked tokens the user has provided
        uint256 rewardDebt; // Reward debt
        uint256 depositTime;    // The last time when the user deposit funds
    }

    event AdminTokenRecovery(address tokenRecovered, uint256 amount);
    event Deposit(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
    event NewRewardPerBlock(uint256 rewardPerBlock);
    event NewPoolLimit(uint256 poolLimitPerUser);
    event RewardsStop(uint256 blockNumber);
    event Withdraw(address indexed user, uint256 amount);
    event NewLockDays(uint256 lockDays);
    // Subscription
    modifier onlySub() {
      require(msg.sender == subOperator || msg.sender == owner());
      _;
    }

    receive() external payable {}
    //******************************************************************************************************
    // Owner functions
    //******************************************************************************************************
    function setSubOperator(address newSubOperator) public onlyOwner {subOperator = newSubOperator;}
    function ResetSubOperator() public onlyOwner {subOperator = owner();}
    
    function SetPayment (address _treasury, uint256 _subFee, uint256 emergencyfee, uint256 txfee) external onlyOwner {
        require(_subFee <= 1*10**18, "Max 1 bnb renew Fee");
        require(emergencyfee >= 2*10**17, "Min 0.2 bnb Emergency Fee");
        treasury = _treasury;
        subFee = _subFee;
        EmergencyFee = emergencyfee;
        TransactionFee = txfee;
    }

    function initializePool (IBEP20 _stakedToken, IBEP20 _rewardToken, address _admin, uint256 _subLengthDays, uint256 _maxstakingfee) external onlyOwner {
        require(!isInitialized, "Already initialized");
        isInitialized = true;
        stakedToken = _stakedToken; // @param _stakedToken: staked token address
        rewardToken = _rewardToken; // @param _rewardToken: reward token address
        MaxStakingFee = _maxstakingfee;

        decimalsRewardToken = uint256(rewardToken.decimals());
        decimalsStakedToken = uint256(stakedToken.decimals());
        require(decimalsRewardToken < 30, "Must be inferior to 30");
        PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
        prevAndCurrentRewardsBalance = 0;
        totalStaked = 0;
        extraTokens = 0;
        setSubOperator(_admin);
        subLengthDays = _subLengthDays;
    }

    function RecyclePool() external onlyOwner {
        require (subEndBlock <= block.number);
        isInitialized = false;
        prevAndCurrentRewardsBalance = 0;
        totalStaked = 0;
        extraTokens = 0;
        totalNewReward = 0;
        bonusEndBlock = block.number;
        feeReceiver = 0x4aAB4ED440A8406eC15C140e3627dfc7701B9D0F;
        setSubOperator(owner());
    }
    //******************************************************************************************************
    // Subscriber functions
    //******************************************************************************************************
     function startNewPool(bool _hasUserLimit, uint256 _poolLimitPerUser, uint256 _lockDays,uint256 _startInDays, uint256 _poolLengthDays ) external payable onlySub {
        if (subFee != 0) {
            require(msg.value >= subFee,"Not Enough BNB");
            require(payable(treasury).send(subFee));
        }
        require(bonusEndBlock < block.number, "Pool has not ended, Try Extending");
        _updatePool();
        require(totalNewReward > 0, "No funds to start new pool with");
        
        if (_hasUserLimit) {
            hasUserLimit = _hasUserLimit;
            poolLimitPerUser = _poolLimitPerUser;
        } else {
            hasUserLimit = _hasUserLimit;
            poolLimitPerUser = 0;
        }
        emit NewPoolLimit(poolLimitPerUser);
        if(_lockDays != 0) {
            lockDays = _lockDays;
            emit NewLockDays(_lockDays);
        }
        uint256 startInBlocks;
        uint256 totalBlocks;
        startInBlocks = _startInDays * 28800;
        totalBlocks = _poolLengthDays * 28800;

        if (stakedToken == rewardToken) {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this)) - totalStaked;} 
        else {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this));}
        startBlock = (block.number + startInBlocks);
        lastRewardBlock = startBlock;
        bonusEndBlock = startBlock + totalBlocks;
        if(msg.sender != owner()) require(bonusEndBlock <= subEndBlock, "Subscription runs out before this end block renewSubscription");
        rewardPerBlock = totalNewReward / totalBlocks;
        totalNewReward = 0;
        if(subEndBlock == 0) subEndBlock = block.number + (subLengthDays * 28800);
    }
    
    function setFeeOptions(address _feeReceiver, uint256 _stakingFee, uint256 _unstakingFee) external payable onlySub { // setup if staking and/or unstaking Fee
        require(_stakingFee <= MaxStakingFee && _unstakingFee <= MaxStakingFee, "Fees cannot exceed Max staking fee each");
        feeReceiver = _feeReceiver;
        stakingFee = _stakingFee;
        unstakingFee = _unstakingFee;
    }
    
    function RenewOrExtendSubscription() external payable onlySub { // if you want to extend the pool over the initial subscription use this function (when sub still active), first send BNB to the pool address then run this function for update
        require(subEndBlock > 0, "Subscription hasnt started");
        if (subFee != 0) {
            require(msg.value >= subFee,"Not Enough BNB");
            require(payable(treasury).send(subFee));
        }
        uint256 subLength = subLengthDays * 28800;
        if(block.number <= subEndBlock) subEndBlock += subLength;
        else subEndBlock = block.number + subLength;    
    }

    // Token removal Functions
    function RewardWithdraw(uint256 _amount) external payable onlySub { // can adjust down rewards amount
        require (_amount < prevAndCurrentRewardsBalance,"cant remove more than remains");
        rewardToken.safeTransfer(address(msg.sender), _amount);
        prevAndCurrentRewardsBalance -= _amount;
        if (bonusEndBlock > block.number) {
            uint256 blocksLeft = bonusEndBlock - block.number;
            uint256 RemovedRPB = _amount / blocksLeft;
            rewardPerBlock -= RemovedRPB;
        }
    }
    
    function NewRewardWithdraw() external payable onlySub { // can recover new rewards tokens sent
        require(totalNewReward > 0, "No New Reward Tokens to Withdraw");
        rewardToken.safeTransfer(address(msg.sender), totalNewReward);
        totalNewReward = 0; 
    }

    function stopReward() external payable onlySub { // can stop pool rewarding
        _updatePool();
        uint256 timeLeft = bonusEndBlock - block.number;
        uint256 rewardsLeft = rewardPerBlock * timeLeft;

        if (stakedToken == rewardToken) {           
            prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this)) - totalStaked;
        } else {
            // check how much new rewards are available
            prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this));
        }
        prevAndCurrentRewardsBalance -= rewardsLeft;
        prevAndCurrentRewardsBalance -= totalNewReward;
        bonusEndBlock = block.number;
    }
    
    function LoadTokens(uint256 _amount, bool FirstLoad, bool APR) external payable onlySub {
        stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount*10**decimalsStakedToken);
        if (!FirstLoad) {
            if (APR) {UpdateAPR();}
            else {ExtendPool();}
        }
    }
    //******************************************************************************************************
    // Public functions
    //******************************************************************************************************
    function Stake(uint256 _amount) external payable nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        uint256 preBalance;
        uint256 postBalance;
        if (TransactionFee != 0) {
            require(msg.value >= TransactionFee,"Not Enough BNB");
            require(payable(treasury).send(TransactionFee));
        }

        if (hasUserLimit) {require(_amount.add(user.amount) <= poolLimitPerUser, "User amount above limit");}
        _updatePool();
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
            if (pending > 0) {
                rewardToken.safeTransfer(address(msg.sender), pending);
                prevAndCurrentRewardsBalance -= pending; 
            }
        }

        if (_amount > 0) {
            preBalance = stakedToken.balanceOf(address(this));
            if(stakingFee > 0) {
                uint256 FeeAmount = _amount.mul(stakingFee).mul(100).div(10000);
                stakedToken.safeTransferFrom(address(msg.sender), feeReceiver, FeeAmount);
                _amount -= FeeAmount;
                user.depositTime = block.timestamp; 
            }    
            stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            postBalance = stakedToken.balanceOf(address(this));
            user.amount = user.amount.add(postBalance - preBalance);  
            totalStaked += (postBalance - preBalance);
        }
        user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
        user.depositTime = block.timestamp;
        emit Deposit(msg.sender, _amount);
    }

    function UnStake(uint256 _amount) external payable nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        require(user.amount >= _amount, "Amount to withdraw too high");
        if (_amount != 0) require(user.depositTime + lockDays*28800 < block.timestamp, "Can not withdraw in lock period");

        if (TransactionFee != 0) {
            require(msg.value >= TransactionFee,"Not Enough BNB");
            require(payable(treasury).send(TransactionFee));
        }

        _updatePool();
        uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
        if (_amount > 0) {
            user.amount = user.amount.sub(_amount);
            totalStaked -= _amount;
            
            if(unstakingFee > 0) {
                uint256 FeeAmount = _amount.mul(unstakingFee).mul(100).div(10000);
                stakedToken.safeTransfer(feeReceiver, FeeAmount);
                _amount -= FeeAmount;
            }
            stakedToken.safeTransfer(address(msg.sender), _amount);
        }
        if (pending > 0) {
            rewardToken.safeTransfer(address(msg.sender), pending);
            prevAndCurrentRewardsBalance -= pending; 
        }
        user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
        emit Withdraw(msg.sender, _amount);
    }

    function harvest() external payable nonReentrant {
        UserInfo storage user = userInfo[msg.sender];

        if (TransactionFee != 0) {
            require(msg.value >= TransactionFee,"Not Enough BNB");
            require(payable(treasury).send(TransactionFee));
        }
        _updatePool();

        if (user.amount > 0) {
            uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
            if (pending > 0) {
                rewardToken.safeTransfer(address(msg.sender), pending);
                prevAndCurrentRewardsBalance -= pending; 
            }
        }
        user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
    }

    function emergencyWithdraw() external payable nonReentrant {
        if (EmergencyFee != 0) {
            require(msg.value >= EmergencyFee,"Not Enough BNB");
            require(payable(treasury).send(EmergencyFee));
        }
        UserInfo storage user = userInfo[msg.sender];
        uint256 amountToTransfer = user.amount;
        totalStaked -= user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        if (amountToTransfer > 0) {stakedToken.safeTransfer(address(msg.sender), amountToTransfer);}
        emit EmergencyWithdraw(msg.sender, user.amount);
    }

    function pendingReward(address _user) external view returns (uint256) {
        UserInfo storage user = userInfo[_user];
        uint256 stakedTokenSupply = totalStaked;
        if (block.number > lastRewardBlock && stakedTokenSupply != 0) {
            uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
            uint256 EWReward = multiplier.mul(rewardPerBlock);
            uint256 adjustedTokenPerShare = accTokenPerShare.add(EWReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
            return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
        } else {return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);}
    }

    function GetPoolInfo() external view returns (bool Initialised, IBEP20 Token, IBEP20 Reward, uint256 rewardperblock,  uint EndDay, uint EndHour, uint EndMinute, uint EndSecond, bool userlimit, uint256 Limit, uint256 LockDays, uint currentblock){
        if (bonusEndBlock  >= block.number) {
            uint256 Remaining = (bonusEndBlock  - block.number);
            EndDay = Remaining/28800;
            EndHour = (Remaining-(EndDay*28800))/1200;
            EndMinute = (Remaining-(EndDay*28800)-(EndHour*1200))/20;
            EndSecond = Remaining-(EndDay*28800)-(EndHour*1200)-(EndMinute*20);
        } else {
            EndDay = 0;
            EndHour = 0;
            EndMinute = 0;
            EndSecond = 0;
        }
        return(isInitialized, stakedToken, rewardToken, rewardPerBlock, EndDay, EndHour, EndMinute, EndSecond, hasUserLimit, poolLimitPerUser, lockDays, block.number);
    }

    function GetPoolStatus() external view returns (bool Started, uint StartDay, uint StartHour, uint StartMinute, uint StartSecond) {
         if (startBlock >= block.number) {
            uint256 Remaining = ( startBlock - block.number);
            StartDay = Remaining/28800;
            StartHour = (Remaining-(StartDay*28800))/1200;
            StartMinute = (Remaining-(StartDay*28800)-(StartHour*1200))/20;
            StartSecond = Remaining-(StartDay*28800)-(StartHour*1200)-(StartMinute*20);
            Started = false;
        } else {
            StartDay = 0;
            StartHour = 0;
            StartMinute = 0;
            StartSecond = 0;
            Started = true;
        }
        return(Started, StartDay, StartHour, StartMinute, StartSecond);
    }

    function GetFeeInfo() external view returns(address FeeWallet, uint256 MaxFee, uint256 stakingfee, uint256 unstakingfee){return (feeReceiver, MaxStakingFee, stakingFee, unstakingFee);}
    function GetSubscriptionInfo() external view returns(address Paywallet, uint256 subfee, uint256 emergencyfee, uint256 transactionfee, uint256 subend, uint256 sublenght, address suboperator) {return(treasury, subFee, EmergencyFee, TransactionFee, subEndBlock, subLengthDays, subOperator);}
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function _updateExtraAndNewRewards() internal {
        // Set the Extra Tokens Variable and update NewReward
        if (stakedToken == rewardToken) {totalNewReward = (rewardToken.balanceOf(address(this)) - prevAndCurrentRewardsBalance - totalStaked);} 
        else {
            totalNewReward = (rewardToken.balanceOf(address(this)) - prevAndCurrentRewardsBalance);
            extraTokens = (stakedToken.balanceOf(address(this)) - totalStaked);
        }
    }

    function _updatePool() internal {
        if (block.number <= lastRewardBlock) {return;}
        uint256 stakedTokenSupply = totalStaked;
        _updateExtraAndNewRewards();
    
        if (stakedTokenSupply == 0) {
            lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
        uint256 EWReward = multiplier.mul(rewardPerBlock);
        accTokenPerShare = accTokenPerShare.add(EWReward.mul(PRECISION_FACTOR).div(stakedTokenSupply));
        lastRewardBlock = block.number;
    }

    function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
        if (_to <= bonusEndBlock) {return _to.sub(_from);} 
        else if (_from >= bonusEndBlock) {return 0;} 
        else {return bonusEndBlock.sub(_from);}
    }

    function UpdateAPR() private onlySub { // this function is to be used when sending extra Reward tokens to the pool when active, it will update the APR in the time remaining
        _updatePool();
        require(bonusEndBlock > block.number, "Pool has Ended, use startNewPool");
        require(totalNewReward > 0, "no NewRewards availavble, send tokens First");

        uint256 blocksLeft = bonusEndBlock - block.number;
        uint256 addedRPB = totalNewReward / blocksLeft;
        rewardPerBlock += addedRPB;
        totalNewReward = 0;
        if (stakedToken == rewardToken) {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this)) - totalStaked;} 
        else {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this));}
        _updatePool();
    }

    function ExtendPool() private onlySub { // this function is to be used when sending extra Reward tokens to the pool when active, it will update the time remaining by added the corresponding time equivalent to the new token addition
        require(bonusEndBlock > block.number, "Pool has Ended, use startNewPool");
          
        _updatePool();
        require(totalNewReward > 0, "No funds to start new pool with");
        
        if (stakedToken == rewardToken) {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this)) - totalStaked;} 
        else {prevAndCurrentRewardsBalance = rewardToken.balanceOf(address(this));}        
        
        uint256 timeExtended = totalNewReward / rewardPerBlock;
        bonusEndBlock = bonusEndBlock + (timeExtended);
        if(msg.sender != owner()) require(bonusEndBlock <= subEndBlock, "Subscription runs out before this end block renewSubscription");
        totalNewReward = 0;
    }
}