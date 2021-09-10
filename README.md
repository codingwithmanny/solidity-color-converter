# Solidity Color Converter

This is a library that helps convert colors to hexadecimal, decimal, and / or rgb.
This has a limitted amount of functions to try and keep the size small.

## Credit

Thanks to [Guffa](https://stackoverflow.com/users/69083/guffa) for the RGB mathematics.
- [Decimal to RGB in Javascript and PHP](https://stackoverflow.com/a/29241510/11317072)

Thanks to [@themandalore](https://github.com/themandalore) for their HexUtils contract.
- [Parse string into multiple variables](https://ethereum.stackexchange.com/a/53115/75902)

## Requirements

- Solidity `^0.8.4`

## How To Use

Clone the repository and copy what you need or just copy the code from `./ColorConverter.sol`;

Place in the same directory as your main contract and import:

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./ColorDefinitions.sol";

contact YourContract {

}
```

## Deploy Linking With Hardhat

If your project requires linking and you get an error similar to the following:

```bash
NomicLabsHardhatPluginError: The contract YourContract is missing links for the following libraries:
* contracts/ColorConverter.sol:ColorConverter
```

You will need to link library in your `deploy.js` file.

**File:** `/scripts/deploy.js`

```js
const hre = require("hardhat");

async function main() {
  // Add these two lines
  const ColorConverter = await hre.ethers.getContractFactory("ColorConverter");
  const cc = await ColorConverter.deploy();

  // Add the library here
  const Dev = await hre.ethers.getContractFactory("YourContract", {
    libraries:{
      ColorConverter: cc.address,
    },
  });

  const dev = await Dev.deploy();
  await dev.deployed();

  console.log("YourContract deployed to:", dev.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```