const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("ERC20Tests", function() {
    let owner
    let buyer
    let shop
    // let erc20
    let token

    beforeEach(async function() {
        [owner, buyer, shopOwner] = await ethers.getSigners()

        const SomeShop = await ethers.getContractFactory("SomeShopERC20", shopOwner)
        shop = await SomeShop.deploy()
        await shop.deployed()

        const YarikToken = await ethers.getContractFactory("YarikToken", owner)
        token = await YarikToken.deploy(shop.address)
        await token.deployed()

        shop.setToken(token.address)

        // erc20 = new ethers.Contract(await shop.token(), tokenJSON.abi, owner)
    })

    it("should have an owner and a token", async function() {
        expect(await shop.owner()).to.eq(shopOwner.address)
        
        expect(await shop.token()).to.eq(token.address)
    })

    it("should be able to buy tokens", async function() {
        const amount = 10
        const txData = {
            value: amount,
            to: shop.address
        }

        const tx = await buyer.sendTransaction(txData)
        await tx.wait()

        expect(await token.balanceOf(buyer.address)).to.eq(amount)

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

        const approval = await token.connect(buyer).approve(shop.address, amountToSell)

        await approval.wait()

        const sellTx = await shop.connect(buyer).sell(amountToSell)

        expect(await token.balanceOf(buyer.address)).to.eq(amount - amountToSell)

        await expect(() => sellTx).
            to.changeEtherBalance(shop, -amountToSell)

        await expect(sellTx).
            to.emit(shop, "Sold")
            .withArgs(amountToSell, buyer.address)
    })
    
})