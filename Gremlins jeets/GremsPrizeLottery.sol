// SPDX-License-Identifier: MIT

//*************************************************************************************************//
// TG : https://t.me/GremlinsCoin
// Website : https://gremlinscoin.com/
//*************************************************************************************************//

pragma solidity ^0.8.16;

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

contract GremsGrandPrizeLottery is SharedOwnable, SafeToken {
    uint256[] participants;
    uint256 PartNb = 0;
    mapping (uint256 => bool) public TicketList;
    uint counter = 5531;
 
    constructor(){}
    //******************************************************************************************************
    // Public functions
    //******************************************************************************************************
    function LoadTicket(uint256 Ticket) public {
        participants[PartNb] = Ticket;
        PartNb +=1;
    }
    
    function Winner(uint Draw) onlySharedOwners public returns (uint256 W1, uint256 W2, uint256 W3){
        require (Draw <= 11, "maw 11 draws");
        uint256 winner1;
        uint256 winner2;
        uint256 winner3;
        uint256[1000] memory DrawList;

        if (Draw <= 10) {
            for(uint i = (Draw-1)*1000 ; i < Draw*1000 ; i++) {DrawList[i] = participants[i];}
            uint index1 = (random() % DrawList.length) + (Draw-1)*1000;
            winner1 = participants[index1];
            counter += 3331;
            uint index2 = (random() % DrawList.length) + (Draw-1)*1000;
            winner2 = participants[index2];
            counter += 1171;
            uint index3 = (random() % DrawList.length) + (Draw-1)*1000;
            winner3 = participants[index3];
        }

        else if (Draw == 11){
            uint index1 = random() % participants.length;
            winner1 = participants[index1];
            counter += 6053;
            uint index2 = random() % participants.length;
            winner2 = participants[index2];
            counter += 4723;
            uint index3 = random() % participants.length;
            winner3 = participants[index3];
        }
        return(winner1, winner2, winner3);
    }
    //******************************************************************************************************
    // Internal functions
    //******************************************************************************************************
    function random() internal view returns(uint) {return uint(keccak256(abi.encodePacked(block.difficulty, block.number, participants.length, counter)));}

    
}