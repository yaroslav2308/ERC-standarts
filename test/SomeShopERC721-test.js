const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("ERC721Tests", function() {
    let owner
    let buyer
    let buyer2
    let token

    beforeEach(async function() {
        [owner, buyer, buyer2] = await ethers.getSigners()

        const ERC721 = await ethers.getContractFactory("ERC721", owner)
        token = await ERC721.deploy("Yarik721", "YRK")
        await ERC721.deployed()

        shop.setToken(token.address)
    })
})