# Sample ERC20 Token creation

This is the sample smart contracts written to create an ERC20 token according to [EIP-20](https://eips.ethereum.org/EIPS/eip-20) standards.

`/contracts/ManualToken.sol` Has all the methods, events and properties requires to create an ERC-20 token manually.

`/contracts/OurToken.sol` uses standard opensource library [openzeppelin](https://www.openzeppelin.com/contracts) to create and ERC-20 token without much effort. 

The smart contract is developed using `Hardhat` and `TypeScript` while following Patrick Collions course.

## Running the code
To run and test the code in your local development machine copy the repo with the following command. We have used `yarn` package manager to install all dependencies. You can use `NPM`.
```shell
git clone https://github.com/sanjaydefidev/hardhat-erc20-token
```
Installing all the dependencies
```shell
yarn install
```
Check out this [link](https://github.com/PatrickAlphaC/hardhat-erc20-fcc) for more information about this tutorial.

## Note
Thanks to @PatrickAlphaC for creating such a helpful tutorial.
