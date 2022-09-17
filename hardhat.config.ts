import * as dotenv from 'dotenv'

import { HardhatUserConfig, task } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
// import '@nomiclabs/hardhat-etherscan'
// import '@nomiclabs/hardhat-waffle'
// import '@typechain/hardhat'
// import 'hardhat-gas-reporter'
// import 'solidity-coverage'

dotenv.config()

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
    solidity: {
        version: '0.8.13',
        settings: {
            viaIR: true,
            optimizer: {
                enabled: true,
                runs: 1000,
            },
        },
    },
    networks: {
        hardhat: {
            forking: {
                enabled: true,
                url: process.env.OPTIMISM_URL as string,
                blockNumber: 23547072,
            },
            accounts: {
                count: 10,
            },
        },
        optimism: {
            url: process.env.OPTIMISM_URL as string,
            chainId: 10,
            accounts: [process.env.MAINNET_PK as string],
        },
    },
    gasReporter: {
        enabled: true,
        currency: 'USD',
        gasPrice: 60,
    },
    etherscan: {
        apiKey: {
            mainnet: process.env.ETHERSCAN_API_KEY as string,
            optimism: process.env.OPTIMISTIC_ETHERSCAN_API_KEY as string,
        },
    },
}

export default config
