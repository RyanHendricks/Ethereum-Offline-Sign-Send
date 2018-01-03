compile:
	solc --optimize-runs 200 --gas --overwrite --bin --bin-runtime --clone-bin $(shell pwd -P)/contracts/$(contract).sol > $ $(shell pwd -P)/build/$(contract)_bin.json
	solc --optimize-runs 200 --gas --overwrite --abi $(shell pwd -P)/contracts/$(contract).sol > $ $(shell pwd -P)/build/$(contract)_abi.json
	solc --optimize-runs 200 --gas --overwrite --hashes $(shell pwd -P)/contracts/$(contract).sol > $ $(shell pwd -P)/build/$(contract)_hashes.json
	solc --optimize-runs 200 --gas --overwrite --combined abi,asm,ast,bin,bin-runtime,clone-bin,hashes,interface,metadata,opcodes,srcmap $(shell pwd -P)/contracts/$(contract).sol > $ $(shell pwd -P)/build/$(contract)_combined.txt

compiled:
	solc --abi --optimize-runs 200 --bin --overwrite $(shell pwd -P)/contracts/$(contract).sol -o $(shell pwd -P)/build