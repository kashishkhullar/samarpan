const UBBI = artifacts.require('UBBI');

contract("UBBI", async (accounts) => {

    let reserveBankAddress;
    let scheduledBankHAddress;
    let commercialBankAddress;
    let totalSupply = 100000;
    let usableTokens = 80000;
    let instance;
    let publicBankHQAddress;
    let privateBankHQAddress;
    let ruralBankHQAddress;
    let foreignBankHQAddress;
    let publicBranchAddress, forignBranchAddress, privateBranchAddress, ruralBranchAddress;
    let users;

    before(async () => {
        reserveBankAddress = accounts[0];
        scheduledBankHQAddress = accounts[1];
        commercialBankAddress = accounts[2];
        publicBankHQAddress = accounts[3];
        privateBankHQAddress = accounts[4];
        ruralBankHQAddress = accounts[5];
        foreignBankHQAddress = accounts[6];
        publicBranchAddress = accounts[7];
        forignBranchAddress = accounts[9];
        privateBranchAddress = accounts[8];
        ruralBranchAddress = accounts[10];
        users = accounts.slice(11);
        instance = await UBBI.new(totalSupply, usableTokens, { from: reserveBankAddress });
    });

    it("should be deployed by reserve bank", async () => {

        let _reserveBankAddress = await instance.getReserveBankAddress.call();
        assert.equal(_reserveBankAddress, reserveBankAddress);
    });

    it("it should register scheduled bank", async () => {

        await instance.registerScheduledBank(scheduledBankHQAddress, { from: reserveBankAddress });
        let _scheduledBankHQAddress = await instance.getScheduledBankAddress.call();
        assert.equal(_scheduledBankHQAddress, scheduledBankHQAddress);

    });

    it("should transfer to scheduled bank", async () => {

        let amount = 50000;
        await instance.transferToScheduled(amount, { from: reserveBankAddress });
        let balance = await instance.getScheduledBankBalance.call();
        assert.equal(balance, amount);
    });

    it("should register commercial bank", async () => {
        await instance.registerCommercialBank(commercialBankAddress, { from: scheduledBankHQAddress });
        let _commercialBankAddress = await instance.getCommercialBankAddress.call();
        assert.equal(_commercialBankAddress, commercialBankAddress);
    });

    it("should transfer to commercial bank", async () => {

        let amount = 40000;
        await instance.transferToCommercial(amount, { from: scheduledBankHQAddress });
        let balance = await instance.getCommercialBankBalance.call();
        assert.equal(balance, amount);
    });

    it("should register bank hqs", async () => {

        await instance.registerBankHQs(0, publicBankHQAddress, { from: commercialBankAddress });
        await instance.registerBankHQs(1, privateBankHQAddress, { from: commercialBankAddress });
        await instance.registerBankHQs(2, foreignBankHQAddress, { from: commercialBankAddress });
        await instance.registerBankHQs(3, ruralBankHQAddress, { from: commercialBankAddress });

        assert.ok(await instance.checkRegisteredBankHQ(0, publicBankHQAddress));
        assert.ok(await instance.checkRegisteredBankHQ(1, privateBankHQAddress));
        assert.ok(await instance.checkRegisteredBankHQ(2, foreignBankHQAddress));
        assert.ok(await instance.checkRegisteredBankHQ(3, ruralBankHQAddress));

    });

    it("should transfer to bank hq", async () => {
        let amountPublic = 5000;
        let amountPrivate = 4000;
        let amountForeign = 6000;
        let amountRural = 1000;

        await instance.transferToBankHQs(0, amountPublic, publicBankHQAddress, { from: commercialBankAddress });
        await instance.transferToBankHQs(1, amountPrivate, privateBankHQAddress, { from: commercialBankAddress });
        await instance.transferToBankHQs(2, amountForeign, foreignBankHQAddress, { from: commercialBankAddress });
        await instance.transferToBankHQs(3, amountRural, ruralBankHQAddress, { from: commercialBankAddress });

        assert.equal(await instance.getBankHQBalance.call(0, publicBankHQAddress), amountPublic, "transfer to public failed");
        assert.equal(await instance.getBankHQBalance.call(1, privateBankHQAddress), amountPrivate, "transfer to private failed");
        assert.equal(await instance.getBankHQBalance.call(2, foreignBankHQAddress), amountForeign, "transfer to foreign failed");
        assert.equal(await instance.getBankHQBalance.call(3, ruralBankHQAddress), amountRural, "transfer to rural failed");
    });

    it("should register bank branches", async () => {

        await instance.registerBranch(0, publicBranchAddress, { from: publicBankHQAddress });
        await instance.registerBranch(1, privateBranchAddress, { from: privateBankHQAddress });
        await instance.registerBranch(2, forignBranchAddress, { from: foreignBankHQAddress });
        await instance.registerBranch(3, ruralBranchAddress, { from: ruralBankHQAddress });

        assert.ok(await instance.checkRegisteredBranch.call(0, publicBranchAddress, publicBankHQAddress));
        assert.ok(await instance.checkRegisteredBranch.call(1, privateBranchAddress, privateBankHQAddress));
        assert.ok(await instance.checkRegisteredBranch.call(2, forignBranchAddress, foreignBankHQAddress));
        assert.ok(await instance.checkRegisteredBranch.call(3, ruralBranchAddress, ruralBankHQAddress));
    });

    it("should transfer to branches", async () => {
        let amountPublic = 500;
        let amountPrivate = 400;
        let amountForeign = 600;
        let amountRural = 100;

        await instance.transferToBranch(0, publicBranchAddress, amountPublic, { from: publicBankHQAddress });
        await instance.transferToBranch(1, privateBranchAddress, amountPrivate, { from: privateBankHQAddress });
        await instance.transferToBranch(2, forignBranchAddress, amountForeign, { from: foreignBankHQAddress });
        await instance.transferToBranch(3, ruralBranchAddress, amountRural, { from: ruralBankHQAddress });

        assert.equal(await instance.checkBranchBalance.call(0, publicBranchAddress), amountPublic, "transfer to public failed");
        assert.equal(await instance.checkBranchBalance.call(1, privateBranchAddress), amountPrivate, "transfer to private failed");
        assert.equal(await instance.checkBranchBalance.call(2, forignBranchAddress), amountForeign, "transfer to foreign failed");
        assert.equal(await instance.checkBranchBalance.call(3, ruralBranchAddress), amountRural, "transfer to rural failed");


    });

    it("should register users", async () => {

        await instance.registerUsers(users[0], publicBankHQAddress, { from: publicBranchAddress });
        await instance.registerUsers(users[1], publicBankHQAddress, { from: publicBranchAddress });
        await instance.registerUsers(users[2], privateBankHQAddress, { from: privateBranchAddress });
        await instance.registerUsers(users[3], privateBankHQAddress, { from: privateBranchAddress });
        await instance.registerUsers(users[4], foreignBankHQAddress, { from: forignBranchAddress });
        await instance.registerUsers(users[5], foreignBankHQAddress, { from: forignBranchAddress });
        await instance.registerUsers(users[6], ruralBankHQAddress, { from: ruralBranchAddress });
        await instance.registerUsers(users[7], ruralBankHQAddress, { from: ruralBranchAddress });
        await instance.registerUsers(users[8], ruralBankHQAddress, { from: ruralBranchAddress });

        assert.ok(await instance.checkRegisteredUser.call(users[0]));
        assert.ok(await instance.checkRegisteredUser.call(users[1]));
        assert.ok(await instance.checkRegisteredUser.call(users[2]));
        assert.ok(await instance.checkRegisteredUser.call(users[3]));
        assert.ok(await instance.checkRegisteredUser.call(users[4]));
        assert.ok(await instance.checkRegisteredUser.call(users[5]));
        assert.ok(await instance.checkRegisteredUser.call(users[6]));
        assert.ok(await instance.checkRegisteredUser.call(users[7]));
        assert.ok(await instance.checkRegisteredUser.call(users[8]));



    });

    it("should transfer to users", async () => {
        let amount = 10;

        await instance.transferToUsers(0, users[0], amount, publicBankHQAddress, { from: publicBranchAddress });
        await instance.transferToUsers(0, users[1], amount + 1, publicBankHQAddress, { from: publicBranchAddress });
        await instance.transferToUsers(1, users[2], amount + 2, privateBankHQAddress, { from: privateBranchAddress });
        await instance.transferToUsers(1, users[3], amount + 3, privateBankHQAddress, { from: privateBranchAddress });
        await instance.transferToUsers(2, users[4], amount + 4, foreignBankHQAddress, { from: forignBranchAddress });
        await instance.transferToUsers(2, users[5], amount + 5, foreignBankHQAddress, { from: forignBranchAddress });
        await instance.transferToUsers(3, users[6], amount + 6, ruralBankHQAddress, { from: ruralBranchAddress });
        await instance.transferToUsers(3, users[7], amount + 7, ruralBankHQAddress, { from: ruralBranchAddress });
        await instance.transferToUsers(3, users[8], amount + 8, ruralBankHQAddress, { from: ruralBranchAddress });

        assert.equal(await instance.checkBalance.call(users[0]), amount);
        assert.equal(await instance.checkBalance.call(users[1]), amount + 1);
        assert.equal(await instance.checkBalance.call(users[2]), amount + 2);
        assert.equal(await instance.checkBalance.call(users[3]), amount + 3);
        assert.equal(await instance.checkBalance.call(users[4]), amount + 4);
        assert.equal(await instance.checkBalance.call(users[5]), amount + 5);
        assert.equal(await instance.checkBalance.call(users[6]), amount + 6);
        assert.equal(await instance.checkBalance.call(users[7]), amount + 7);
        assert.equal(await instance.checkBalance.call(users[8]), amount + 8);

    });

    it("should transfer among users", async () => {
        let amount = 1;
        let balance0 = await instance.checkBalance.call(users[0]);
        let balance1 = await instance.checkBalance.call(users[1]);

        await instance.transfer(users[1], amount, { from: users[0] });

        assert.equal(await instance.checkBalance.call(users[0]), parseInt(balance0.toString()) - 1);
        assert.equal(await instance.checkBalance.call(users[1]), parseInt(balance1.toString()) + 1);

    })












});