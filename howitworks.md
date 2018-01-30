# How It Works

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
Feel free to modify the token parameters in params.js

```javascript
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
    _user1, _user2, _dataUser1, _dataUser2, _content,
    {data: '0x'+bin}
);

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

var shortaddress = params.config.shortaddress;

var count = web3.toHex(nonce);
var txnCount = (web3.eth.getTransactionCount(fromAddress.toString()));

var rlpEncodedHex = rlp.encode([new Buffer(shortaddress, 'hex'), count]).toString('hex');
var rlpEncodedWordArray = CryptoJS.enc.Hex.parse(rlpEncodedHex);
var hash = CryptoJS.SHA3(rlpEncodedWordArray, {outputLength: 256}).toString(CryptoJS.enc.Hex);
var contractAddress = hash.slice(24);
```
