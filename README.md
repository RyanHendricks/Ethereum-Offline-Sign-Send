# Ethereum Offline Sign Send :palm_tree:

*Generate, Sign, and Deploy Ethereum Smart-Contracts*

## Requirements

Node 8+  
Solc *(only if you want to deploy a different contract than the included custom token contract)*


## Installation

`npm install`

## Usage

## Deploy the included token contract

Change the token parameters in ./config/params.js  
Then use the following command deploy your custom token.

```bash
$ npm run sendtx

OUTPUT
--------------------
Contract deployed from: 0x8A5FB1c5AFb97D8c6EEb4a61d2Db4310db1FfA33
Current Balance: 16782190361249127960
Nonce for Contract Deployment: 184
--------------------------------------
--------------- Success --------------
Contract Deployed to Address: 0x206b7bf0a82a7bd782a50e934899b5374a06b6f1
Transaction Hash: 0x019fb0aca60cb685ba7756a8a886f8f99a34e93f32454e29208a2a9cb5365e70
--------------------------------------
https://ropsten.etherscan.io/tx/0x019fb0aca60cb685ba7756a8a886f8f99a34e93f32454e29208a2a9cb5365e70
https://ropsten.etherscan.io/address/0x206b7bf0a82a7bd782a50e934899b5374a06b6f1
```
**NOTE:** the contract address link will not work until transaction is confirmed


## Create a new keypair

```bash
$ npm run newkeys

OUTPUT
-------------All 3 addresses should be the same-------------
Address: 0x583747c8ad0cA0EE857c54285A55Eb20dCC6243A
Address: 0x583747c8ad0cA0EE857c54285A55Eb20dCC6243A
Address: 0x583747c8ad0cA0EE857c54285A55Eb20dCC6243A
------------------------------------------------------------
---------------First 2 keys should be the same--------------
Private Key: 0xd022b2d77e0786d573d0837192f395e935dc8ae4d01fb1bfc0def6d25160587f
Private Key: 0xd022b2d77e0786d573d0837192f395e935dc8ae4d01fb1bfc0def6d25160587f
Private Key: [object Object]
------------------------------------------------------------
---------------First 2 keys should be the same--------------
Public Key: 0x03759cb9acae34b2649d992c01e404601d0ab1bf2ff53843c93c7f4de671f20252
Compressed: 0x03759cb9acae34b2649d992c01e404601d0ab1bf2ff53843c93c7f4de671f20252
Uncompressed: 0x04759cb9acae34b2649d992c01e404601d0ab1bf2ff53843c93c7f4de671f20252ce01ceaa58a2f528d9f5f7a3dee8c82a3a62b2befc65beacac84dcf21885395d
------------------------------------------------------------
```

## Why Make This?

Because sometimes there is the need to create an Ethereum Transaction without running a node such as from an app running on a mobile device. 

It is also useful for deploying contracts for development purposes, if you simply find truffle to be more trouble than it is useful, or would prefer address consistency.

## [How this works](./howitworks.md)


## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License

[MIT](https://choosealicense.com/licenses/mit/)


## Disclaimer

This project as it stands exposes the private key of the sending address. Do not use this for production but only for learning purposes and to gain a better understanding of how contracts are deployed on Ethereum. 

This project also has the potential to pollute the network which we would all do well to avoid as much as possible. The current contracts deployed using send-tx.js include a public function for self-destruct (callable by anyone; Yes, another major security flaw if this was used in production). If you remember the days (or even if you don't) when your VHS tape had a sticker that said "Be Kind, Please Rewind" then adhere to the new "Be Kind, Please Self-Destruct your Contract".