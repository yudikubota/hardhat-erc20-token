import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { assert, expect } from "chai";
import { deployments, ethers, network } from "hardhat";
import { MemoToken } from "../../typechain-types";
import { INITIAL_SUPPLY } from "../../helper-hardhat-config";

describe("MemoToken Unit Test", function () {
    //Multipler is used to make reading the math easier because of the 18 decimal points
    const multiplier = 10 ** 18;
    let memoToken: MemoToken;
    let userToken: MemoToken;
    let deployer: SignerWithAddress;
    let user: SignerWithAddress;
    this.beforeEach(async function () {
        const accounts = await ethers.getSigners();
        deployer = accounts[0];
        user = accounts[1];
        await deployments.fixture("all");
        memoToken = await ethers.getContract("MemoToken", deployer);
    });
    describe("constructor", () => {
        it("Should have correct INITIAL_SUPPLY of token ", async () => {
            const totalSupply = await memoToken.totalSupply();
            assert.equal(totalSupply.toString(), INITIAL_SUPPLY);
        });
        it("initializes the token with the correct name and symbol ", async () => {
            const name = (await memoToken.name()).toString();
            assert.equal(name, "MemoToken");

            const symbol = (await memoToken.symbol()).toString();
            assert.equal(symbol, "MMT");
        });
    });

    describe("transfers", () => {
        it("Should be able to transfer tokens successfully to an address", async () => {
            const tokensToSend = ethers.utils.parseEther("10");
            await memoToken.transfer(user.address, tokensToSend);
            expect(await memoToken.balanceOf(user.address)).to.equal(
                tokensToSend
            );
        });
        it("emits an transfer event, when an transfer occurs", async () => {
            await expect(
                memoToken.transfer(user.address, (10 * multiplier).toString())
            ).to.emit(memoToken, "Transfer");
        });
    });
    describe("allowances", () => {
        const amount = (20 * multiplier).toString();
        beforeEach(async () => {
            userToken = await ethers.getContract("MemoToken", user);
        });
        it("Should approve other address to spend token", async () => {
            const tokensToSpend = ethers.utils.parseEther("5");
            await memoToken.approve(user.address, tokensToSpend);
            await userToken.transferFrom(
                deployer.address,
                user.address,
                tokensToSpend
            );
            expect(await userToken.balanceOf(user.address)).to.equal(
                tokensToSpend
            );
        });
        it("doesn't allow an unnaproved member to do transfers", async () => {
            //Deployer is approving that user can spend 20 of their precious MMT's
            await expect(
                userToken.transferFrom(deployer.address, user.address, amount)
            ).to.be.revertedWith("ERC20: insufficient allowance");
        });
        it("emits an approval event, when an approval occurs", async () => {
            await expect(memoToken.approve(user.address, amount)).to.emit(
                memoToken,
                "Approval"
            );
        });
        it("the allowance being set is accurate", async () => {
            await memoToken.approve(user.address, amount);
            const allowance = await memoToken.allowance(
                deployer.address,
                user.address
            );
            assert.equal(allowance.toString(), amount);
        });
        it("won't allow a user to go over the allowance", async () => {
            await memoToken.approve(user.address, amount);
            await expect(
                userToken.transferFrom(
                    deployer.address,
                    user.address,
                    (40 * multiplier).toString()
                )
            ).to.be.revertedWith("ERC20: insufficient allowance");
        });
    });
});
