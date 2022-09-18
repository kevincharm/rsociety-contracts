import { ethers, run } from 'hardhat'
import { MockDai__factory, RedistributionChef__factory } from '../typechain-types'
import { addDays } from 'date-fns'
import { MerkleTree } from 'merkletreejs'
// @ts-ignore
import attendees from './attendees.json'
import { BigNumberish } from 'ethers'

// equiv to keccak256(abi.encodePacked(address))
function hashAddress(address: string) {
    return ethers.utils.solidityKeccak256(['address'], [address])
}

const attendeeAddresses = attendees.map((a: any) => a.address)
const merkleTree = new MerkleTree(attendeeAddresses, hashAddress, {
    sort: true,
    hashLeaves: true,
})

const TOTAL_PARTICIPANTS = 1000
const EXPECTED_DAI_WINNINGS = ethers.utils.parseEther('10000')
const CLAIM_EXPIRY_TIMESTAMP_SECONDS = Math.ceil(addDays(new Date(), 7).getTime() / 1000)

async function main() {
    const signers = await ethers.getSigners()
    const deployer = signers[0]
    console.log('Deploying MockDAI...')
    const mockDai = await new MockDai__factory(deployer).deploy()
    await mockDai.deployed()
    console.log(`Deployed MockDAI at ${mockDai.address}`)
    const redistChefConstructorArgs: [string, BigNumberish, BigNumberish, BigNumberish, string] = [
        mockDai.address,
        TOTAL_PARTICIPANTS,
        EXPECTED_DAI_WINNINGS,
        CLAIM_EXPIRY_TIMESTAMP_SECONDS,
        merkleTree.getHexRoot(),
    ]
    const redistChef = await new RedistributionChef__factory(deployer).deploy(
        ...redistChefConstructorArgs
    )
    await redistChef.deployed()
    console.log(`Deployed RedistributionChef at ${redistChef.address}`)
    const mintTx = await mockDai.mint(EXPECTED_DAI_WINNINGS)
    await mintTx.wait(1)
    const transferTx = await mockDai.transfer(redistChef.address, EXPECTED_DAI_WINNINGS)
    await transferTx.wait(1)

    // Wait for deployments to finish
    await new Promise((resolve) => setTimeout(resolve, 120_000))

    await run('verify:verify', {
        address: mockDai.address,
        constructorArguments: [],
    })
    await run('verify:verify', {
        address: redistChef.address,
        constructorArguments: redistChefConstructorArgs,
    })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
