pragma solidity^0.5.0;

/**
TODO:
Perform testing
Add events
break code into seperate files
abstract code into an interface
*/




contract UBBI{

    mapping(address => bool) registeredPublicBankHQ;
    mapping(address => bool) registeredPrivateBankHQ;
    mapping(address => bool) registeredForeignBankHQ;
    mapping(address => bool) registeredRuralBankHQ;
    mapping(address => mapping(address => bool)) registedPublicBankBranch;
    mapping(address => mapping(address => bool)) registedForeignBankBranch;
    mapping(address => mapping(address => bool)) registedPrivateBankBranch;
    mapping(address => mapping(address => bool)) registedRuralBankBranch;
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
        require(msg.sender == reserveBankAddress,"only reserved bank");
        _;
    }

    modifier onlyScheduled(){
        require(msg.sender == scheduledBankHQAddress,"only scheduled bank hq");
        _;
    }

    modifier onlyCommercial(){
        require(msg.sender == commercialBankHQAddress,"only commercial bank");
        _;
    }

    modifier onlyRegisteredBranch(address _HQ, address _branch){
        require(
            registedPublicBankBranch[_HQ][_branch] ||
            registedPrivateBankBranch[_HQ][_branch] ||
            registedForeignBankBranch[_HQ][_branch] ||
            registedRuralBankBranch[_HQ][_branch],"branch not registered");
        _;
    }

    modifier onlyRegisteredBankHQ(address _address){
        require(
            registeredPublicBankHQ[_address] ||
            registeredPrivateBankHQ[_address] ||
            registeredForeignBankHQ[_address] ||
            registeredRuralBankHQ[_address],"HQ not registered");
        _;
    }

    modifier onlyRegisteredUser(address _address){
        require(registeredUser[_address] == true,"only registered users");
        _;
    }

    constructor (uint _totalSupply, uint _usableTokens) public{

        require(_totalSupply > 0,"total supply must be greater than zero");
        require(_usableTokens > 0,"usable token must be greater than zero");
        require(_totalSupply > _usableTokens,"usable token must be less than total supply");
        reserveBankAddress = msg.sender;
        totalSupply = _totalSupply;
        usableTokens = _usableTokens;
        reservedTokens = _totalSupply - _usableTokens;

    }

    function getTotalSupply() public view returns(uint){
        return totalSupply;
    }

    function getUsableTokens() public view returns(uint){
        return usableTokens;
    }

    function getReservedTokens() public view returns(uint){
        return reservedTokens;
    }

    function getReserveBankAddress() public view returns(address){
        return reserveBankAddress;
    }


    function registerScheduledBank(address _scheduledBankHQAddress) public onlyReserveBank{
        require(reserveBankAddress != address(0),"Reserve bank not registered");
        scheduledBankHQAddress = _scheduledBankHQAddress;
    }

    function getScheduledBankAddress() public view returns(address){
        return scheduledBankHQAddress;
    }

    function transferToScheduled(uint _amount) public onlyReserveBank {
        require(usableTokens > _amount,"Amount value greater than usable tokens");
        require(reserveBankAddress != address(0),"Reserve bank not registered");
        require(scheduledBankHQAddress != address(0),"Scheduled bank HQ not registered");
        usableTokens -= _amount;
        scheduledBankBalance += _amount;
    }

    function getScheduledBankBalance() public view returns(uint){
        return scheduledBankBalance;
    }

    function registerCommercialBank(address _commercialBankHQAddress) public onlyScheduled{
        commercialBankHQAddress = _commercialBankHQAddress;
    }

    function getCommercialBankAddress() public view returns(address){
        return commercialBankHQAddress;
    }

    function transferToCommercial(uint _amount) public onlyScheduled {
        require(scheduledBankBalance > _amount,"amount greater than balance");
        require(commercialBankHQAddress != address(0),"commercial bank not registered");
        require(scheduledBankHQAddress != address(0),"scheduled bank not registered");
        scheduledBankBalance -= _amount;
        commercialBankBalance += _amount;
    }

    function getCommercialBankBalance() public view returns(uint){
        return commercialBankBalance;
    }

    function registerBankHQs(uint _type,address _address) public onlyCommercial{
        if(_type == 0){
            registeredPublicBankHQ[_address] = true;
        } else if (_type == 1) {
            registeredPrivateBankHQ[_address] = true;
        } else if(_type == 2){
            registeredForeignBankHQ[_address] = true;
        } else {
            registeredRuralBankHQ[_address] = true;
        }
    }

    function checkRegisteredBankHQ(uint _type,address _address) public view returns(bool){
        if(_type == 0){
            return registeredPublicBankHQ[_address];
        } else if (_type == 1) {
            return registeredPrivateBankHQ[_address];
        } else if(_type == 2){
            return registeredForeignBankHQ[_address];
        } else {
            return registeredRuralBankHQ[_address];
        }
    }

    function transferToBankHQs(uint _type,uint _amount, address _to) public onlyCommercial onlyRegisteredBankHQ(_to){
        require(commercialBankBalance > _amount,"amount is greater than commercial bank balance");
        commercialBankBalance -= _amount;
        if(_type == 0){
            publicBankHQBalance[_to] += _amount;
        } else if (_type == 1) {
            privateBankHQBalance[_to] += _amount;
        } else if(_type == 2){
            foreignBankHQBalance[_to] += _amount;
        } else {
            ruralBankHQBalance[_to] += _amount;
        }
    }

    function getBankHQBalance(uint _type,address _address) public view returns(uint){
        if(_type == 0){
            return publicBankHQBalance[_address];
        } else if (_type == 1) {
            return privateBankHQBalance[_address];
        } else if(_type == 2){
            return foreignBankHQBalance[_address];
        } else {
            return ruralBankHQBalance[_address];
        }
    }

    function registerBranch(uint _type,address _address) public onlyRegisteredBankHQ(msg.sender){
        if(_type == 0){
            registedPublicBankBranch[msg.sender][_address] = true;
        } else if (_type == 1) {
            registedPrivateBankBranch[msg.sender][_address] = true;
        } else if(_type == 2){
            registedForeignBankBranch[msg.sender][_address] = true;
        } else {
            registedRuralBankBranch[msg.sender][_address] = true;
        }
    }

    function checkRegisteredBranch(uint _type,address _branchAddress,address _HQAddress) public view returns(bool){
        if(_type == 0){
            return registedPublicBankBranch[_HQAddress][_branchAddress];
        } else if (_type == 1) {
            return registedPrivateBankBranch[_HQAddress][_branchAddress];
        } else if(_type == 2){
            return registedForeignBankBranch[_HQAddress][_branchAddress];
        } else {
            return registedRuralBankBranch[_HQAddress][_branchAddress];
        }
    }

    function transferToBranch(uint _type,address _to, uint _amount) public onlyRegisteredBranch(msg.sender,_to) onlyRegisteredBankHQ(msg.sender){
        if(_type == 0){
            require(publicBankHQBalance[msg.sender] > _amount,"amount greater than public hq balance");
            publicBankHQBalance[msg.sender] -= _amount;
            publicBankBranchBalance[_to] += _amount;
        } else if (_type == 1) {
            require(privateBankHQBalance[msg.sender] > _amount,"amount greater than private hq balance");
            privateBankHQBalance[msg.sender] -= _amount;
            privateBankBranchBalance[_to] += _amount;
        } else if(_type == 2){
            require(foreignBankHQBalance[msg.sender] > _amount,"amount greater than foreign hq balance");
            foreignBankHQBalance[msg.sender] -= _amount;
            foreignBankBranchBalance[_to] += _amount;
        } else {
            require(ruralBankHQBalance[msg.sender] > _amount,"amount greater than rural hq balance");
            ruralBankHQBalance[msg.sender] -= _amount;
            ruralBankBranchBalance[_to] += _amount;
        }
    }

    function checkBranchBalance(uint _type,address _address) public view returns(uint){
        if(_type == 0){
            return publicBankBranchBalance[_address];
        } else if (_type == 1) {
            return privateBankBranchBalance[_address];
        } else if(_type == 2){
            return foreignBankBranchBalance[_address];
        } else {
            return ruralBankBranchBalance[_address];
        }
    }

    function registerUsers(address _address,address _HQAddress) public onlyRegisteredBranch(_HQAddress,msg.sender){
        registeredUser[_address] = true;
    }

    function checkRegisteredUser(address _address) public view returns(bool){
        return registeredUser[_address];
    }

    function transferToUsers(uint _type,address _to,uint _amount,address _HQAddress) public onlyRegisteredBranch(_HQAddress,msg.sender) onlyRegisteredUser(_to){

        if(_type == 0){
            require(publicBankBranchBalance[msg.sender] > _amount,"amount greater than public branch balance");
            publicBankBranchBalance[msg.sender] -= _amount;
            userBalances[_to] += _amount;
        } else if (_type == 1) {
            require(privateBankBranchBalance[msg.sender] > _amount,"amount greater than praivte branch balance");
            privateBankBranchBalance[msg.sender] -= _amount;
            userBalances[_to] += _amount;
        } else if(_type == 2){
            require(foreignBankBranchBalance[msg.sender] > _amount,"amount greater than foreign branch balance");
            foreignBankBranchBalance[msg.sender] -= _amount;
            userBalances[_to] += _amount;
        } else {
            require(ruralBankBranchBalance[msg.sender] > _amount,"amount greater than rural branch balance");
            ruralBankBranchBalance[msg.sender] -= _amount;
            userBalances[_to] += _amount;
        }
    }

    function transfer( address _to, uint _amount) public onlyRegisteredUser(msg.sender) onlyRegisteredUser(_to){
        require(userBalances[msg.sender] >= _amount,"amount is greater than balance");
        userBalances[msg.sender] -= _amount;
        userBalances[_to] += _amount;
    }

    function checkBalance(address _address) public view returns (uint){
        return userBalances[_address];
    }


}
