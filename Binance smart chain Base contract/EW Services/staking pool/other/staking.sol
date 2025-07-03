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

 
library SafeMath {
	function add(uint x, uint y) internal pure returns (uint z) {
		require((z = x + y) >= x, 'ds-math-add-overflow');
	}

	function sub(uint x, uint y) internal pure returns (uint z) {
		require((z = x - y) <= x, 'ds-math-sub-underflow');
	}

	function mul(uint x, uint y) internal pure returns (uint z) {
		require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
	}  
	
	function div(uint a, uint b) internal pure returns (uint c) {
		require(b > 0, "ds-math-mul-overflow");
		c = a / b;
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

contract SafeToken is SharedOwnable {
    address payable safeManager;
    constructor() {safeManager = payable(msg.sender);}
    function setSafeManager(address payable _safeManager) public onlySharedOwners {safeManager = _safeManager;}
    function withdraw(address _token, uint256 _amount) external { require(msg.sender == safeManager); IBEP20(_token).transfer(safeManager, _amount);}
    function withdrawBNB(uint256 _amount) external {require(msg.sender == safeManager); safeManager.transfer(_amount);}
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

// each staking instance mapping to each pool
contract Staking is SharedOwnable, SafeToken {
	using SafeMath for uint;
	event Stake(address staker, uint amount);
	event Reward(address staker, uint amount);
	event Withdraw(address staker, uint amount);
    //staker inform
	struct Staker {
		uint firstStakingBlock; // block number when first staking
		uint stakingAmount;  // staking token amount
		uint lastUpdateTime;  // last amount updatetime
		uint lastStakeUpdateTime;  // last Stake updatetime
		uint stake;          // stake amount
		uint rewards;          // reward amount
	}

	uint public startStakingTime;  // in seconds

	address public tokenAddress;
	uint public decimal;

	uint public totalStakingAmount; // total staking token amount

	uint public lastUpdateTime; // total stake amount and reward update time
	uint public totalReward;  // total reward amount
	uint public totalStake;   // total stake amount
	uint public VestedRewardTime;	  //Time in days when claim reward not possible
	uint public VestedStakeTime;	  //Time in days when unstaking not possible
	
	uint256 public PoolReward;
	uint256 public limitReward;
	mapping(address=>Staker) public stakers;
	// 
	constructor (address _tokenAddress, uint _decimal, uint256 _quota, uint256 _limitReward, uint _vestrewardtime, uint _veststaketime, uint _starttime) {
		tokenAddress = _tokenAddress;
		decimal = _decimal;
		lastUpdateTime = block.timestamp;
		PoolReward = _quota*10**decimal;
		limitReward = _limitReward*10**decimal;
		VestedRewardTime = _vestrewardtime;
		VestedStakeTime = _veststaketime;
		startStakingTime = lastUpdateTime + _starttime;
	}
	
	function InitialisePool (address _tokenAddress, uint _decimal, uint256 _poolreward, uint _vestrewardtime, uint _veststaketime, uint _starttime) public onlySharedOwners {
		tokenAddress = _tokenAddress;
		decimal = _decimal;
		lastUpdateTime = block.timestamp;
		PoolReward = _poolreward*10**decimal;
		limitReward = PoolReward;
		VestedRewardTime = _vestrewardtime;
		VestedStakeTime = _veststaketime;
		startStakingTime = lastUpdateTime + _starttime;
	}
	
	function AddReward (uint256 reward) public onlySharedOwners {
		PoolReward += reward*10**decimal;
	}

	function countTotalStake() public view returns (uint _totalStake) {
		_totalStake = totalStake + totalStakingAmount.mul((block.timestamp).sub(lastUpdateTime));
	}

	function countTotalReward() public view returns (uint _totalReward) {
		_totalReward = totalReward + PoolReward.mul(block.timestamp.sub(lastUpdateTime)).div(86400);
	}

	function updateTotalStake() internal {
		totalStake = countTotalStake();
		totalReward = countTotalReward();
		lastUpdateTime = block.timestamp;
		totalStakingAmount = IBEP20(tokenAddress).balanceOf(address(this));
	}

	/* ----------------- personal counts ----------------- */

	function getStakeInfo(address stakerAddress) public view returns(uint _total, uint _staking, uint _rewardable, uint _rewards) {
		_total = totalStakingAmount;
		_staking = stakers[stakerAddress].stakingAmount;
		_rewardable = countReward(stakerAddress); 
		_rewards = stakers[stakerAddress].rewards;

	}
	function countStake(address stakerAddress) public view returns(uint _stake) {
		Staker memory _staker = stakers[stakerAddress];
		if(totalStakingAmount == 0 && _staker.stake == 0 ) return 0;
		_stake = _staker.stake + ((block.timestamp).sub(_staker.lastUpdateTime)).mul(_staker.stakingAmount);
	}
	
	function countReward(address stakerAddress) public view returns(uint _reward) {
		uint _totalStake = countTotalStake();
		uint _totalReward = countTotalReward();
		uint _stake = countStake(stakerAddress);
		_reward = _totalStake==0 ? 0 : _totalReward.mul(_stake).div(_totalStake);
	}

	function stake(uint256 amount) external {
		require(block.timestamp >= startStakingTime, "staking : you can not stake yet");
		uint256 Amount = amount*10**decimal;
		address stakerAddress = msg.sender;
		IBEP20(tokenAddress).transferFrom(stakerAddress,address(this),Amount);
		if(stakers[stakerAddress].firstStakingBlock==0) stakers[stakerAddress].firstStakingBlock = block.timestamp;
		stakers[stakerAddress].stake = countStake(stakerAddress);
		stakers[stakerAddress].stakingAmount += Amount;
		stakers[stakerAddress].lastUpdateTime = block.timestamp;
		stakers[stakerAddress].lastStakeUpdateTime = block.timestamp;
		
		updateTotalStake();
		emit Stake(stakerAddress,amount);
	}

	function unstaking(uint256 amount) external {
		address stakerAddress = msg.sender;
		uint256 Amount = amount*10**decimal;
		require(Amount <= stakers[stakerAddress].stakingAmount,"staking : amount over stakeAmount");
		require((block.timestamp-stakers[stakerAddress].lastStakeUpdateTime).div(86400) >= VestedStakeTime,"Unstake : you can not unstake yet");
		IBEP20(tokenAddress).transfer(stakerAddress,amount.mul(1000).div(1000));
		stakers[stakerAddress].stake = countStake(stakerAddress);
		stakers[stakerAddress].stakingAmount = stakers[stakerAddress].stakingAmount - Amount;
		stakers[stakerAddress].lastUpdateTime = block.timestamp;
		stakers[stakerAddress].lastStakeUpdateTime = block.timestamp;

		updateTotalStake();
		emit Withdraw(stakerAddress,amount);
	}

	function claimRewards() external {
		address stakerAddress = msg.sender;

		uint _stake = countStake(stakerAddress);
		uint _reward = countReward(stakerAddress);

		require((block.timestamp-stakers[stakerAddress].lastStakeUpdateTime).div(86400) >= VestedRewardTime,"claim : you can not claim the reward yet");
		require(_reward>0 && limitReward>0,"claim : reward amount is 0");
		_reward = limitReward<_reward ? limitReward : _reward;
		IBEP20(tokenAddress).transfer(stakerAddress, _reward);
		stakers[stakerAddress].rewards += _reward;
		totalStake -= _stake;
		totalReward -= _reward;
		limitReward -= _reward;
		stakers[stakerAddress].stake = 0;
		stakers[stakerAddress].lastUpdateTime = block.timestamp;
		
		updateTotalStake();
		emit Reward(stakerAddress,_reward);
	}
}  