async function main() {
    let contract, signers, chairperson, proposals, game_contract;
    const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());
  proposals = ["Apple", "Banana", "Cellular"];
  [chairperson, ...signers] = await ethers.getSigners();
  const Contract = await ethers.getContractFactory("Ballot", chairperson);
//   const Token = await ethers.getContractFactory("Token");

//   const token = await Token.deploy();


  const GameContract = await ethers.getContractFactory("EthGame");
  game_contract = await GameContract.deploy();
  await game_contract.deployed();

//   console.log("Token address:", token.address);
    // contract = await Contract.deploy();
    // await contract.deployed();
  console.log("Game contract address:", game_contract.address);
  function toBytes32(text) {
    return ethers.utils.formatBytes32String(text);
  }

  console.log(proposals);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });