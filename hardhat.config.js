require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: 'https://eth-rinkeby.alchemyapi.io/v2/RTwu1NoZVkRTKgX7nUzZZgn44iQPR8oc',
      accounts: ['6864c5e98a5bb0b14247cc2c5bbfd0c5312865f8e71da47b9fc5b44934d25a1d'],
    },
  },
};
