import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import {
    networkConfig,
    developmentChains,
    INITIAL_SUPPLY,
} from "../helper-hardhat-config";
import verify from "../utils/verify";

const deployERC20Token: DeployFunction = async function (
    hre: HardhatRuntimeEnvironment
) {
    const { deployments, getNamedAccounts, network, ethers } = hre;
    const { deployer } = await getNamedAccounts();
    const { deploy, log } = deployments;
    const waitConfirmations =
        networkConfig[network.name].blockConfirmations || 1;

    const MemoToken = await deploy("MemoToken", {
        from: deployer,
        args: [INITIAL_SUPPLY],
        log: true,
        waitConfirmations: waitConfirmations,
    });
    log(`MemoToken deployed at ${MemoToken.address}`);

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(MemoToken.address, [INITIAL_SUPPLY]);
    }
};
export default deployERC20Token;
deployERC20Token.tags = ["all", "erc20token"];
