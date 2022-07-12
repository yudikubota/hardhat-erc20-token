export interface networkConfigItem {
    blockConfirmations?: number;
}

export interface networkConfigInfo {
    [key: string]: networkConfigItem;
}
const networkConfig: networkConfigInfo = {
    localhost: {
        blockConfirmations: 1,
    },
    hardhat: {
        blockConfirmations: 1,
    },
    rinkeby: {
        blockConfirmations: 6,
    },
    kovan: {
        blockConfirmations: 6,
    },
};

const INITIAL_SUPPLY = "100000000000000000000000000"; // 100million token, and 18dec

const developmentChains = ["hardhat", "localhost"];

export { networkConfig, developmentChains, INITIAL_SUPPLY };
