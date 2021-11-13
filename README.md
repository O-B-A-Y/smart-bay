# Smart Bay - OBAY's smart contract implementation

## Getting Started

First, run the development server:
Notice: You must install Ganache (https://www.trufflesuite.com/ganache) or any other local development blockchain.

For Remix:

```bash
Connect with Remix to compile and deploy smart contract
```

For Truffle (local environment):

```bash
npm install -g truffle solc
npm install
```

To generate the Typescript types of smart contracts, run: 

```bash
npm run gat
```

Recommended VSCode extensions for Solidity development: 

Ethereum Solidity Language for Visual Studio Code: https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity
Solidity Debugger: https://marketplace.visualstudio.com/items?itemName=hosho.solidity-debugger

## Contribution Guide

All the commit messages must be following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) guide for semantic purposes! Otherwise your commits will be rejected automatically by commit hook!

#### <a name="commit-header"></a>Commit Message Header

```
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: Feature scopes
  │
  └─⫸ Commit Type: build|ci|docs|feat|fix|perf|refactor|test|chore
```

The `<type>` and `<summary>` fields are mandatory, the `(<scope>)` field is optional.

##### Type

Must be one of the following:

- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **ci**: Changes to our CI configuration files and scripts (example scopes: Circle, BrowserStack, SauceLabs)
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **test**: Adding missing tests or correcting existing tests
- **chore**: Adding commit that is not related to code (resolve conflicts, etc...)

##### Scope (Optional)

The scope should be the name of the feature's scope that you're developing, it is OPTIONAL so feel free to skip it if you want to be more generic!

##### Web3 Guideline

- **OBAY Token address ENS**: https://app.ens.domains/name/obay.eth/details
- **INFURA**: https://infura.io/
- **Get OBAY Token on Uniswap**: https://app.uniswap.org/#/swap
