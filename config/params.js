// Currently configured for Ropsten Testnet
var config = {
    
    // This is just about as insecure as it gets.
    // It is unwise to lower your defenses and use mainnet keys here.
    // Current private keys are for Ropsten so draining the ETH is pointless.
    // Perhaps add some ETH from the faucet instead or switch to key pairs that you specify


    address: '0x8A5FB1c5AFb97D8c6EEb4a61d2Db4310db1FfA33',
    shortaddress: '8A5FB1c5AFb97D8c6EEb4a61d2Db4310db1FfA33',
    privatekey: '9cf61b09525b31c05342a5464e2caa40327836ca86b3c6b256886def0ceb9d8b',
    address2: '0x65271aa4Ad7e9cf8e52668760Aaa0975380cC72B',
    privatekey2: 'f6b51709f90b1f6ee564dfb13b8b3ca7b845e65a5212799eba531eab69ef562b',

    // Localhost or infura-ropsten; uncomment/comment to switch
    // provider: 'http://127.0.0.1:8545',
    provider: 'https://ropsten.infura.io/8oUCPrUo9K5njhj6vbHy',

    // Change these based on contract to be deployed
    gaslimit: '2500000',
    contractname: 'CustomToken',


    // These are the contructors for the token contract
    tokenName: 'Turbo Test Token',
    tokenSymbol: 'TTT',
    tokenDecimals: '0',
    tokenSupply: '1618'

};
exports.config = config;