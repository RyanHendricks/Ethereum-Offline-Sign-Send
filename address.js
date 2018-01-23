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

    var fromAddress = '8a5fb1c5afb97d8c6eeb4a61d2db4310db1ffa33';
    var from = '0x8a5fb1c5afb97d8c6eeb4a61d2db4310db1ffa33';

    var nonce = web3.toHex(web3.eth.getTransactionCount(from.toString()));
    var txnCount = web3.eth.getTransactionCount(from.toString());

    var rlpEncodedHex = rlp.encode([new Buffer(fromAddress, 'hex'), nonce]).toString('hex');
    var rlpEncodedWordArray = CryptoJS.enc.Hex.parse(rlpEncodedHex);
    var hash = CryptoJS.SHA3(rlpEncodedWordArray, {outputLength: 256}).toString(CryptoJS.enc.Hex);
    var address = hash.slice(24);

    console.log('--------------------');
    console.log("Nonce:   " + nonce.toString() + " or " + txnCount.toString());
    console.log("Address: 0x" + address.toString());
//    console.log("Hash:    0x" + hash.toString());
    console.log('--------------------');
