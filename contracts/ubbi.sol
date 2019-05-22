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
    mapping(address => uint) ruralBankHQBalance;
    mapping(address => uint) ruralBankBranchBalance;
    mapping(address => uint) publicBankBranchBalance;
    mapping(address => uint) privateBankBranchBalance;
    mapping(address => uint) foreignBankBranchBalance;
    mapping(address => bool) registeredUser;
    mapping(address => uint) userBalances;
    
    uint private totalSupply;
    
    address private reserveBankAddress;
    address private scheduledBankHQAddress;
    address private commercialBankHQAddress;
    uint private scheduledBankBalance = 0;
    uint private commercialBankBalance = 0;
    uint private usableTokens;
    uint private reservedTokens;

    modifier onlyReserveBank(){
        require(msg.sender == reserveBankAddress);
        _;
    }

    modifier onlyScheduled(){
        require(msg.sender == scheduledBankHQAddress);
        _;
    }

    modifier onlyCommercial(){
        require(msg.sender == commercialBankHQAddress);
        _;
    }

    modifier onlyRegisteredBankHQ(address _address){
        require(registedPublicBankBranch[_address] ||
                registedPrivateBankBranch[_address] ||
                registedForeignBankBranch[_address] ||
                registedRuralBankBranch[_address]);
        _;
    }

    modifier onlyRegisteredBranch(address _address){
        require(registeredPublicBankHQ[_address] ||
                registeredPrivateBankHQ[_address] ||
                registeredForeignBankHQ[_address] ||
                registeredRuralBankHQ[_address]);
        _;
    }

    modifier onlyRegisteredUser(address _address){
        require(registeredUser[_address] ==true);
        _;
    }

    constructor (uint _totalSupply, uint _usableTokens) public{

        reserveBankAddress = msg.sender;
        totalSupply = _totalSupply;
        usableTokens = _usableTokens;
        reservedTokens = _totalSupply - _usableTokens;

    }

    function registerScheduledBank(address _scheduledBankHQAddress) public onlyReserveBank{
        require(reserveBankAddress != address(0));
        scheduledBankHQAddress = _scheduledBankHQAddress;
    }

    function transferToScheduled(uint _amount) public onlyReserveBank {
        require(usableTokens > _amount);
        require(reserveBankAddress != address(0));
        require(scheduledBankHQAddress!= address(0));
        usableTokens-=_amount;
        scheduledBankBalance+=_amount;
    }

    function registerCommercialBank(address _commercialBankHQAddress) public onlyScheduled{
        commercialBankHQAddress = _commercialBankHQAddress;
    }

    function transferToCommercial(uint _amount) public onlyScheduled {
        require(commercialBankBalance > _amount);
        require(commercialBankHQAddress != address(0));
        require(scheduledBankHQAddress!= address(0));
        scheduledBankBalance-=_amount;
        commercialBankBalance+=_amount;
    }

    function registerBankHQs(uint _type,address _address) public onlyCommercial{
        if(_type == 0){
            registeredPublicBankHQ[_address]= true;
        } else if (_type == 1) {
            registeredPrivateBankHQ[_address]= true;
        } else if(_type == 2){
            registeredForeignBankHQ[_address]= true;
        } else {
            registeredRuralBankHQ[_address] = true;
        }
    }

    function transferToBankHQs(uint _type,uint _amount, address _to) public onlyCommercial onlyRegisteredBankHQ(_to){
        require(commercialBankBalance > _amount);
        commercialBankBalance -= _amount;
        if(_type == 0){
            publicBankHQBalance[_to]+= _amount;
        } else if (_type == 1) {
            privateBankHQBalance[_to]+= _amount;
        } else if(_type == 2){
            foreignBankHQBalance[_to]+= _amount;
        } else {
            ruralBankBranchBalance[_to] += _amount;
        }
    }

    function registerBranch(uint _type,address _address) public onlyRegisteredBankHQ(msg.sender){
        if(_type == 0){
            registedPublicBankBranch[_address]= true;
        } else if (_type == 1) {
            registedPrivateBankBranch[_address]= true;
        } else if(_type == 2){
            registedForeignBankBranch[_address]= true;
        } else {
            registedRuralBankBranch[_address] = true;
        }
    }

    function transferToBranch(uint _type,address _to, uint _amount) public onlyRegisteredBranch(_to) onlyRegisteredBankHQ(msg.sender){
        if(_type == 0){
            require(publicBankHQBalance[msg.sender] > _amount);
            publicBankHQBalance[msg.sender]-= _amount;
            publicBankBranchBalance[_to] +=_amount;
        } else if (_type == 1) {
            require(privateBankHQBalance[msg.sender] > _amount);
            privateBankHQBalance[msg.sender]-= _amount;
            privateBankBranchBalance[_to] += _amount;
        } else if(_type == 2){
            require(foreignBankHQBalance[msg.sender] > _amount);
            foreignBankHQBalance[msg.sender]-= _amount;
            foreignBankBranchBalance[_to] += _amount;
        } else {
            require(ruralBankHQBalance[msg.sender] > _amount);
            ruralBankHQBalance[msg.sender] -= _amount;
            ruralBankBranchBalance[_to] += _amount;
        }
    }

    function registerUsers(address _address) public onlyRegisteredBranch(msg.sender){
        registeredUser[_address] = true;
    }

    function trasferUsers(uint _type,address _to,uint _amount) public onlyRegisteredBranch(msg.sender) onlyRegisteredUser(_to){

        if(_type == 0){
            require(publicBankBranchBalance[msg.sender] > _amount);
            publicBankBranchBalance[msg.sender]-= _amount;
            userBalances[_to] +=_amount;
        } else if (_type == 1) {
            require(privateBankBranchBalance[msg.sender] > _amount);
            privateBankBranchBalance[msg.sender]-= _amount;
            userBalances[_to] += _amount;
        } else if(_type == 2){
            require(foreignBankBranchBalance[msg.sender] > _amount);
            foreignBankBranchBalance[msg.sender]-= _amount;
            userBalances[_to] += _amount;
        } else {
            require(ruralBankBranchBalance[msg.sender] > _amount);
            ruralBankBranchBalance[msg.sender] -= _amount;
            userBalances[_to] += _amount;
        }
    }

    function transfer(address _from, address _to, uint _amount) public onlyRegisteredUser(_from) onlyRegisteredUser(_to){
        require(userBalances[_from] >= _amount);
        userBalances[_from] -= _amount;
        userBalances[_to] += _amount;
    }






    /**
    
    Rest of the function, modifier and events will be added soon
    
     */








}
