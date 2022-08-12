//SPDX-License-Identifier:MIT

pragma solidity ^0.5.0;

import "@openzeppelin/upgrades/contracts/upgradeability/ProxyFactory.sol";

contract StoreFactory is ProxyFactory {

    address public implementation;
    address public owner;

    constructor(address _implementation) public {
        implementation = _implementation;
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }


function cloneStore() public onlyOwner{
    deployMinimal(implementation, "");
}
}


/* truffle console
truffle(development)> truffle migrate --reset
truffle(development)> sf = await StoreFactory.deployed()
truffle(development)> sf.address
0x5dB3A480Ae25852E84c656549B33482682666e5D
truffle(development)> store = await Store.deployed()
truffle(development)> store.address
0x75C408617307d4ac07CB5632273fFE08C7429fCb
truffle(development)> networks
Network: UNKNOWN (id: 1660286814588)
  Migrations: 0x86E49a005eCe0527c9f9F670a4c62164a1F45c1d
  Store: 0x75C408617307d4ac07CB5632273fFE08C7429fCb
  StoreFactory: 0x5dB3A480Ae25852E84c656549B33482682666e5D
truffle(development)> sf.owner()
0x8f4129063C02c16F7DF365f57f51cC4D94EEE921
truffle(development)> sf.cloneStore()
truffle(development)> sf.getPastEvents('ProxyCreated')
proxy: 0xeDa4ceD30b13Defde676d7B255dc062Df0785E53
truffle(development)> sf.cloneStore()
truffle(development)> sf.cloneStore()
truffle(development)> sf.getPastEvents('ProxyCreated', {fromBlock: 0})
proxy1: 0xeDa4ceD30b13Defde676d7B255dc062Df0785E53
proxy2: 0xC9c5A71b5F75aEc8aD74Ca478b544d53DA61b4Ac
proxy3: 0x36538C3562D977728169197A9910D34537998e9D
truffle(development)> store1 = await Store.at('0xeDa4ceD30b13Defde676d7B255dc062Df0785E53')
truffle(development)> store1.value()
''
truffle(development)> store1.setValue('My First Store')
truffle(development)> store1.value()
'My First Store'
truffle(development)> store2 = await Store.at('0xC9c5A71b5F75aEc8aD74Ca478b544d53DA61b4Ac')
truffle(development)> store2.value()
''
truffle(development)> store2.setValue('My Second Store')
truffle(development)> store2.value()
'My Second Store'
truffle(development)> store3 = await Store.at('0x36538C3562D977728169197A9910D34537998e9D')
truffle(development)> store3.value()
''
truffle(development)> store3.setValue('My Third Store')
truffle(development)> store3.value()
'My Third Store'








ProxyCreated:
0xD019d3AE2F34F15ced7477da6E54F203f4C633bD
0x44343cF37Bb19B1605C6c8927B7b9eD924d5C04D
0x4D431Aff98F07C5ad9dc3A14952912b89dF69F1d
*/