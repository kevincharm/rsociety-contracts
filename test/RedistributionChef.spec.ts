import { expect } from 'chai'
import { ethers, network } from 'hardhat'
import {
    MockDai,
    MockDai__factory,
    RedistributionChef,
    RedistributionChef__factory,
} from '../typechain-types'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import { MerkleTree } from 'merkletreejs'
import { randomBytes } from 'crypto'
import { JsonRpcSigner } from '@ethersproject/providers'

// equiv to keccak256(abi.encodePacked(address))
function hashAddress(address: string) {
    return ethers.utils.solidityKeccak256(['address'], [address])
}

async function createRandomSigner() {
    const addr = '0x' + randomBytes(20).toString('hex')
    await network.provider.request({
        method: 'hardhat_impersonateAccount',
        params: [addr],
    })
    return ethers.provider.getSigner(addr)
}

describe('RedistributionChef', () => {
    let deployer: SignerWithAddress
    let mockDai: MockDai
    let claimExpiryTimestamp: number
    let participants: JsonRpcSigner[] = []
    let merkleTree: MerkleTree
    before(async () => {
        const signers = await ethers.getSigners()
        deployer = signers[0]
        participants = await Promise.all(
            Array(1000)
                .fill(0)
                .map((_) => createRandomSigner())
        )

        mockDai = await new MockDai__factory(deployer).deploy()

        merkleTree = new MerkleTree(
            participants.map((p) => p._address),
            hashAddress,
            {
                sort: true,
                hashLeaves: true,
            }
        )
    })

    async function fundAccount(addr: string) {
        await deployer.sendTransaction({
            to: addr,
            value: ethers.utils.parseEther('1'),
        })
    }

    let redistChef: RedistributionChef
    beforeEach(async () => {
        const block = await ethers.provider.getBlock(await ethers.provider.getBlockNumber())
        claimExpiryTimestamp = block.timestamp + 8 * 24 * 60 * 60
        redistChef = await new RedistributionChef__factory(deployer).deploy(
            mockDai.address,
            1000,
            ethers.utils.parseEther('10000'),
            claimExpiryTimestamp,
            merkleTree.getHexRoot()
        )
        const prizeAmount = ethers.utils.parseEther('10000')
        await mockDai.mint(prizeAmount)
        await mockDai.transfer(redistChef.address, prizeAmount)
        expect(await mockDai.balanceOf(redistChef.address)).to.equal(prizeAmount)
    })

    describe('#claim', () => {
        it('should allow claim from any participant ONCE', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)
            const balanceBefore = await mockDai.balanceOf(randomParticipant._address)

            // 1st claim
            const proof = merkleTree.getHexProof(hashAddress(randomParticipant._address))
            await redistChef.connect(randomParticipant).claim(proof)
            expect(await mockDai.balanceOf(randomParticipant._address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('10'))
            )

            // 2nd claim should fail
            await expect(redistChef.connect(randomParticipant).claim(proof)).to.be.revertedWith(
                'There is no greater guilt than discontentment'
            )
        })

        it('should reject claim from participant not in merkle tree', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)
            const balanceBefore = await mockDai.balanceOf(randomParticipant._address)

            await expect(redistChef.connect(randomParticipant).claim([])).to.be.revertedWith(
                'Not part of the redistribution'
            )
        })

        it('should reject claim if total winnings is below expected total winnings', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)

            // Re-deploy redist contract with no DAI balance
            redistChef = await new RedistributionChef__factory(deployer).deploy(
                mockDai.address,
                1000,
                ethers.utils.parseEther('10000'),
                claimExpiryTimestamp,
                merkleTree.getHexRoot()
            )
            // Seed contract with not enough DAI
            await mockDai.mint(ethers.utils.parseEther('9999'))

            const proof = merkleTree.getHexProof(hashAddress(randomParticipant._address))
            await expect(redistChef.connect(randomParticipant).claim(proof)).to.be.revertedWith(
                'Winnings are not yet loaded'
            )
        })
    })

    describe('#isClaimable', () => {
        it('should be claimable if enough DAI balance in contract', async () => {
            expect(await redistChef.isClaimable()).to.equal(true)
        })

        it('should NOT be claimable if enough DAI balance in contract', async () => {
            // Re-deploy redist contract with no DAI balance
            redistChef = await new RedistributionChef__factory(deployer).deploy(
                mockDai.address,
                1000,
                ethers.utils.parseEther('10000'),
                claimExpiryTimestamp,
                merkleTree.getHexRoot()
            )
            // Seed contract with not enough DAI
            await mockDai.mint(ethers.utils.parseEther('9999'))

            expect(await redistChef.isClaimable()).to.equal(false)
        })
    })

    describe('#redistributeRemainder', () => {
        it('should reject redistribution of remaining DAI if there have been no claims (div-by-zero)', async () => {
            // Advance chain by (at least) # blocks for claims to expire
            await network.provider.send('evm_setNextBlockTimestamp', [claimExpiryTimestamp])
            await network.provider.send('hardhat_mine')

            // Redistribute without claiming
            await expect(redistChef.redistributeRemainder()).to.be.revertedWith(
                'No claims have been made'
            )
        })

        it('should reject redistribution of remaining DAI if claims have not expired', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)
            const balanceBefore = await mockDai.balanceOf(randomParticipant._address)

            // 1st claim
            const proof = merkleTree.getHexProof(hashAddress(randomParticipant._address))
            await redistChef.connect(randomParticipant).claim(proof)
            expect(await mockDai.balanceOf(randomParticipant._address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('10'))
            )

            // 2nd claim should fail
            await expect(
                redistChef.connect(randomParticipant).redistributeRemainder()
            ).to.be.revertedWith('Claims have not expired')
        })

        it('should allow redistribution of remaining DAI after claims have expired', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)
            let balanceBefore = await mockDai.balanceOf(randomParticipant._address)

            // Claim at least once
            const proof = merkleTree.getHexProof(hashAddress(randomParticipant._address))
            await redistChef.connect(randomParticipant).claim(proof)
            expect(await mockDai.balanceOf(randomParticipant._address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('10'))
            )

            // Advance chain by (at least) # blocks for claims to expire
            await network.provider.send('evm_setNextBlockTimestamp', [claimExpiryTimestamp])
            await network.provider.send('hardhat_mine')

            // Redistribute remainder (anyone can call)
            balanceBefore = await mockDai.balanceOf(randomParticipant._address)
            await redistChef.connect(randomParticipant).redistributeRemainder()
            expect(await mockDai.balanceOf(randomParticipant._address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('9990'))
            )
        })
    })

    describe('#rescueTokens', () => {
        it('should not allow withdrawing DAI under normal conditions', async () => {
            await expect(redistChef.rescueTokens(mockDai.address)).to.be.reverted
        })

        it('should not allow withdrawing DAI if claims have expired, but somebody claimed', async () => {
            const randomParticipant = participants[Math.floor(Math.random() * participants.length)]
            await fundAccount(randomParticipant._address)
            let balanceBefore = await mockDai.balanceOf(randomParticipant._address)

            // Advance chain by (at least) # blocks for claims to expire
            await network.provider.send('evm_setNextBlockTimestamp', [claimExpiryTimestamp])
            await network.provider.send('hardhat_mine')

            // Claim at least once
            const proof = merkleTree.getHexProof(hashAddress(randomParticipant._address))
            await redistChef.connect(randomParticipant).claim(proof)
            expect(await mockDai.balanceOf(randomParticipant._address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('10'))
            )

            await expect(redistChef.rescueTokens(mockDai.address)).to.be.reverted
        })

        it('should allow withdrawing DAI if claims have expired and nobody claimed', async () => {
            // Advance chain by (at least) # blocks for claims to expire
            await network.provider.send('evm_setNextBlockTimestamp', [claimExpiryTimestamp])
            await network.provider.send('hardhat_mine')

            const balanceBefore = await mockDai.balanceOf(deployer.address)
            await redistChef.rescueTokens(mockDai.address)
            expect(await mockDai.balanceOf(deployer.address)).to.equal(
                balanceBefore.add(ethers.utils.parseEther('10000'))
            )
        })
    })
})
