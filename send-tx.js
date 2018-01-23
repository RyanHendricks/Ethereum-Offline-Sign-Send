var Web3 = require('web3');
var fs = require('fs');
var Tx = require('ethereumjs-tx');
var abieth = require('ethereumjs-abi');
var params = require('./params');
var coder = require('web3/lib/solidity/coder');
var rlp = require('rlp');
var CryptoJS = require('crypto-js');
var util = require("ethereumjs-util");


// initialize web3 and set provider
var web3 = new Web3();
var provider = params.config.provider;
web3.setProvider(new Web3.providers.HttpProvider(provider));


// Name of the compiled contract without file extension
var contractName = params.config.contractname;

// Parse compiled contract files
var abiFile = './build/'+contractName+'.abi';
var binFile = './build/'+contractName+'.bin';
var abi = JSON.parse(fs.readFileSync(abiFile).toString());
var bin = fs.readFileSync(binFile).toString()

// create contract object from compiled contract abi
var contract = web3.eth.contract(abi);

// Set contructor parameters from params file
// These variables are unique per Contract 
// ------------------------------------------- //

var _tokenName = params.config.tokenName
var _tokenSymbol = params.config.tokenSymbol
var _tokenDecimals = params.config.tokenDecimals
var _tokenSupply = params.config.tokenSupply

// ------------------------------------------- //

// combine contract bin with contructor parameters to create contractData
var contractData = contract.new.getData(
    _tokenName, _tokenSymbol, _tokenDecimals, _tokenSupply,
    {data: '0x'+bin}
);

// Print contractData in console
// console.log('---RAW TXN DATA----')
// console.log(contractData.toString('hex'))
console.log('--------------------')


var fromAddress = params.config.address;
var txnCount = web3.eth.getTransactionCount(fromAddress);
var balance = web3.eth.getBalance(fromAddress);
var nonce = web3.eth.getTransactionCount(fromAddress);

console.log("Contract deployed from: " + fromAddress.toString());
console.log("Current Balance: " + balance.toString());
console.log("Nonce for Contract Deployment: " + nonce.toString());
console.log('--------------------------------------');

// create a blank transaction

privateKey = new Buffer(params.config.privatekey, 'hex')
gaslimit = params.config.gaslimit;

var rawTx = {
    nonce: web3.toHex(nonce),
    gasPrice: web3.toHex(web3.eth.gasPrice),
    gasLimit: web3.toHex(gaslimit),
    from: web3.toHex(fromAddress),
    data: web3.toHex(contractData)
};

var tx = new Tx(rawTx);
tx.sign(privateKey);
var serializedTx = tx.serialize();

var shortaddress = params.config.shortaddress;

var count = web3.toHex(nonce);
var txnCount = (web3.eth.getTransactionCount(fromAddress.toString()));

var rlpEncodedHex = rlp.encode([new Buffer(shortaddress, 'hex'), count]).toString('hex');
var rlpEncodedWordArray = CryptoJS.enc.Hex.parse(rlpEncodedHex);
var hash = CryptoJS.SHA3(rlpEncodedWordArray, {outputLength: 256}).toString(CryptoJS.enc.Hex);
var contractAddress = hash.slice(24);



return web3.eth.sendRawTransaction("0x" + serializedTx.toString('hex'), function(err, result) {
    if(err) {
        console.log(err);
    } else {
        console.log('--------------- Success --------------');
        console.log("Contract Deployed to Address: 0x" + contractAddress.toString());
        console.log('Transaction Hash: ' + result);
        console.log('--------------------------------------');
        console.log('https://ropsten.etherscan.io/tx/' + result);
        console.log('https://ropsten.etherscan.io/address/0x' + contractAddress.toString());
        console.log('--------------------------------------');
    }
});
