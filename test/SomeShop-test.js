const { expect } = require("chai")
const { ethers } = require("hardhat")

const tokenJSON = require("../artifacts/contracts/ERC20/YarikToken.sol/YarikToken.json")

describe("", function() {
    let owner
    let buyer
    let shop
    let erc20

    beforeEach(async function() {
        [owner, buyer] = await ethers.getSigners()

        const SomeShop = await ethers.getContractFactory("SomeShop", owner)
        shop = await SomeShop.deploy()
        await shop.deployed()

        erc20 = new ethers.Contract(await shop.token(), tokenJSON.abi, owner)
    })

    it("should have an owner and a token", async function() {
        expect(await shop.owner()).to.eq(owner.address)
        
        expect(await shop.token()).to.be.properAddress
    })

    it("should be able to buy tokens", async function() {
        const amount = 10
        const txData = {
            value: amount,
            to: shop.address
        }

        const tx = await buyer.sendTransaction(txData)
        await tx.wait()

        expect(await erc20.balanceOf(buyer.address)).to.eq(amount)

        await expect(() => tx).
            to.changeEtherBalance(shop, amount)

        await expect(tx).
            to.emit(shop, "Bought")
            .withArgs(amount, buyer.address)
    })

    it("should be able to sell tokens", async function() {
        const amount = 10
        const txData = {
            value: amount,
            to: shop.address
        }

        const tx = await buyer.sendTransaction(txData)
        await tx.wait()

        const amountToSell = 5

        const approval = await erc20.connect(buyer).approve(shop.address, amountToSell)

        await approval.wait()

        const sellTx = await shop.connect(buyer).sell(amountToSell)

        expect(await erc20.balanceOf(buyer.address)).to.eq(amount - amountToSell)

        await expect(() => sellTx).
            to.changeEtherBalance(shop, -amountToSell)

        await expect(sellTx).
            to.emit(shop, "Sold")
            .withArgs(amountToSell, buyer.address)
    })
    
})