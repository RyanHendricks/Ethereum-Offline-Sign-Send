var Web3 = require('web3');
var fs = require('fs');
var Tx = require('ethereumjs-tx');
var abieth = require('ethereumjs-abi');
var params = require('./params');

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
var _user1 = params.config.address
var _user2 = params.config.address2
var _dataUser1 = params.config.user1data
var _dataUser2 = params.config.user2data
var _content = params.config.content
// ------------------------------------------- //

// combine contract bin with contructor parameters to create contractData
var contractData = contract.new.getData(
    _user1, _user2, _dataUser1, _dataUser2, _content,
    {data: '0x'+bin}
);

// Print contractData in console
console.log('---RAW TXN DATA----')
console.log(contractData.toString('hex'))
console.log('--------------------')


var fromAddress = params.config.address;
var txnCount = web3.eth.getTransactionCount(fromAddress);
var balance = web3.eth.getBalance(fromAddress);
var nonce = txnCount + 1;

console.log("Contract deployed from: " + fromAddress.toString());
console.log("Current Balance: " + balance.toString());
console.log("# of Transactions Sent by Address: " + txnCount.toString());
console.log("Nonce for Contract Deployment: " + nonce.toString());

// create a blank transaction

privateKey = new Buffer(params.config.privatekey, 'hex')

var rawTx = {
    nonce: web3.toHex(web3.eth.getTransactionCount(fromAddress)),
    gasPrice: web3.toHex(web3.eth.gasPrice),
    gasLimit: web3.toHex(3500000),
    from: web3.toHex(fromAddress),
    data: web3.toHex(contractData)
};

var tx = new Tx(rawTx);
tx.sign(privateKey);
var serializedTx = tx.serialize();
return web3.eth.sendRawTransaction("0x" + serializedTx.toString('hex'));