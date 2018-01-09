# :palm_tree: Ethereum Sign Send :palm_tree:

## Generate, Sign, and Deploy Ethereum Smart-Contracts

### Steps

1. git clone or download this repository
2. `npm install`
3. `node send-tx`

That's it.

----

### How It Works

First we parse the compiled contract .bin and .abi files.
```javascript

// Name of the compiled contract without file extension
var contractName = params.config.contractname;

// Parse compiled contract files
var abiFile = './build/'+contractName+'.abi';
var binFile = './build/'+contractName+'.bin';
var abi = JSON.parse(fs.readFileSync(abiFile).toString());
var bin = fs.readFileSync(binFile).toString()

// create contract object from compiled contract abi
var contract = web3.eth.contract(abi);
```

Next we pass the desired constructor values from params.js to create data for a new contract.

```javascript
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
```

Next, we set the parameters of the transaction to deploy the contract

```javascript
var fromAddress = params.config.address;
var txnCount = web3.eth.getTransactionCount(fromAddress);
var balance = web3.eth.getBalance(fromAddress);
var nonce = txnCount + 1;

privateKey = new Buffer(params.config.privatekey, 'hex')
gaslimit = params.config.gaslimit;
```

Finally, we create the raw transaction, sign with a private key, serialize, and send.

```javascript
var rawTx = {
    nonce: web3.toHex(web3.eth.getTransactionCount(fromAddress)),
    gasPrice: web3.toHex(web3.eth.gasPrice),
    gasLimit: web3.toHex(gaslimit),
    from: web3.toHex(fromAddress),
    data: web3.toHex(contractData)
};

var tx = new Tx(rawTx);
tx.sign(privateKey);
var serializedTx = tx.serialize();
return web3.eth.sendRawTransaction("0x" + serializedTx.toString('hex'), function(err, result) {
    if(err) {
        console.log(err);
    } else {
        console.log('-----------> Success :)');
        console.log('Transaction Hash: ' + result);
    }
});
```

### Disclaimer

This project as it stands exposes the private key of the sending address. Do not use this for production but only for learning purposes and to gain a better understanding of how contracts are deployed on Ethereum. 

This project also has the potential to pollute the network which we would all do well to avoid as much as possible. The current contracts deployed using send-tx.js include a public function for self-destruct (callable by anyone; Yes, another major security flaw if this was used in production). If you remember the days (or even if you don't) when your VHS tape had a sticker that said "Be Kind, Please Rewind" then adhere to the new "Be Kind, Please Self-Destruct your Contract".