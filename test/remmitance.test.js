const Remittance = artifacts.require("./Remittance.sol");
const sha3 = require("browserify-sha3");

contract('Remittance contract', function (accounts) {
    var instance;

    const owner = accounts[0];
    const receiver = accounts[2];

    const pass1 = "anypass1";
    const pass2 = "anypass2";

    const paymentHash = (new sha3.SHA3Hash(256)).update(pass1, pass2).digest();

    const deadline = 20;

    const count = 5;
    const status = 1;

    beforeEach(function () {
        return Remittance.new(paymentHash, deadline, receiver, {
            from: owner,
            value: count
        }).then(function (_instance) {
            assert.equal(deadline, _instance.logs[0].args._deadline.toString(10));
            assert.equal(paymentHash, _instance.logs[0].args._paymentHash.toString(10));
            assert.equal(receiver, _instance.logs[0].args._receiver);
            instance = _instance;
        });
    });

    it("receiveMoney test", function () {
        return instance.receiveMoney(pass1, pass2, {from: receiver})
            .then(function (txObj) {
                assert.equal(status, txObj.receipt.status);
                assert.strictEqual(receiver, txObj.logs[0].args.reciever);
                assert.equal(count, txObj.logs[0].args.amount.toString(10));
            })
    });

    it("withdraw test", function () {
        return instance.withdraw({from: owner})
            .then(function (txObj) {
                assert.equal(status, txObj.receipt.status);
                assert.strictEqual(owner, txObj.logs[0].args._reciever);
                assert.equal(count, txObj.logs[0].args._amount.toString(10));
            })
    });
});