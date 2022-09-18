import { ethers, run } from 'hardhat'
import { RedistributionChef__factory } from '../typechain-types'
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

const OPTIMISM_DAI_ADDR = '0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1'
const TOTAL_PARTICIPANTS = 1000
const EXPECTED_DAI_WINNINGS = ethers.utils.parseEther('10000')

async function main() {
    const signers = await ethers.getSigners()
    const deployer = signers[0]
    const redistChefConstructorArgs: [string, BigNumberish, BigNumberish, string] = [
        OPTIMISM_DAI_ADDR,
        TOTAL_PARTICIPANTS,
        EXPECTED_DAI_WINNINGS,
        merkleTree.getHexRoot(),
    ]
    const redistChef = await new RedistributionChef__factory(deployer).deploy(
        ...redistChefConstructorArgs
    )
    await redistChef.deployed()
    console.log(`Deployed RedistributionChef at ${redistChef.address}`)

    // Wait for deployments to finish
    await new Promise((resolve) => setTimeout(resolve, 120_000))

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
