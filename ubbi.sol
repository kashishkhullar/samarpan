pragma solidity^0.5.0;

contract UBBI{

    mapping(address => bool) registeredPublicBankHQ;
    mapping(address => bool) registeredPrivateBankHQ;
    mapping(address => bool) registeredForeignBankHQ;
    mapping(address => bool) registeredRuralBankHQ;
    mapping(address => bool) registedPublicBankBranch;
    mapping(address => bool) registedForeignBankBranch;
    mapping(address => bool) registedPrivateBankBranch;
    mapping(address => bool) registedRuralBankBranch;
    mapping(address => uint) publicBankHQBalance;
    mapping(address => uint) privateBankHQBalance;
    mapping(address => uint) foreignBankHQBalance;
    mapping(address => uint) ruralBankBranchBalance;
    mapping(address => uint) publicBankBranchBalance;
    mapping(address => uint) privateBankBranchBalance;
    mapping(address => uint) foreignBankBranchBalance;
    mapping(address => bool) registeredUser;
    mapping(address => uint) userBalances;

    
    uint private _totalSupply;
    
    address private _reserveBankAddress;
    address private _scheduledBankHQAddress;
    address private _commercialBankHQAddress;
    uint private _scheduledBankBalance;
    uint private _commercialBankBalance;
    uint private _usableTokens;
    uint private _reservedTokens;

    modifier onlyReserveBank(){
        require(msg.sender == _reserveBankAddress);
        _;
    }

    modifier onlyScheduled(){
        require(msg.sender == _scheduledBankHQAddress);
        _;
    }

    constructor(uint totalSupply, uint usableTokens) public{

        _reserveBankAddress = msg.sender;
        _totalSupply = totalSupply;
        _usableTokens = usableTokens;
        _reservedTokens = totalSupply - usableTokens;

    }

    function registerScheduledBank(address scheduledBankHQAddress) public onlyReserveBank{
        require(_reserveBankAddress != address(0));
        _scheduledBankHQAddress = scheduledBankHQAddress;
    }


    /**
    
    Rest of the function will be added soon
    
     */

     /**
     TODO:

     ADD functions, modifiers and events
     create an interface.
     
      */








}
