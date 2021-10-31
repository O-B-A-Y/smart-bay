require("dotenv");

module.exports = {
  KOVAN: `https://kovan.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
  RINKEBY: `https://rinkeby.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
  ROPSTEN: `https://ropsten.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
};
