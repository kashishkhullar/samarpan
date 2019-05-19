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

    
    uint private _totalSupply;
    
    address private _reserveBankAddress;
    address private _scheduledBankHQAddress;
    address private _commercialBankHQAddress;
    uint _scheduledBankBalance;
    uint _commercialBankBalance;








}
