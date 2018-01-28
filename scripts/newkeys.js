var ethers = require('ethers');

// Generate a new random wallet keypair
var Wallet = ethers.Wallet;
var wallet = Wallet.createRandom();


var privateKey = wallet.privateKey;
var walletaddress =  wallet.address;

// Tests to make sure generated key pair and address are valid
var SigningKey = ethers._SigningKey;
var signingKey = new SigningKey(privateKey);
var signingKeyprivate = signingKey.privateKey;
var publicKey = signingKey.publicKey;
var compressedPublicKey = SigningKey.getPublicKey(publicKey, true);
var uncompressedPublicKey = SigningKey.getPublicKey(publicKey, false);
var pubaddress = SigningKey.publicKeyToAddress(publicKey);

console.log("-------------All 3 addresses should be the same-------------");
console.log('Address: ' + walletaddress);
console.log('Address: ' + signingKey.address);
console.log("Address: " + pubaddress);
console.log("------------------------------------------------------------");
console.log("---------------First 2 keys should be the same--------------");
console.log("Private Key: " + privateKey);
console.log("Private Key: " + signingKeyprivate);
console.log("Private Key: " + signingKey);
console.log("------------------------------------------------------------");
console.log("---------------First 2 keys should be the same--------------");
console.log("Public Key: " + publicKey);
console.log('Compressed: ' + compressedPublicKey);
console.log('Uncompressed: ' + uncompressedPublicKey);
console.log("------------------------------------------------------------");
