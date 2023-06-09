const main = async () => {
	const [deployer] = await hre.ethers.getSigners();
	const accountBalance = await deployer.getBalance();
	const contractFactory = await hre.ethers.getContractFactory("Portal");
	const contract = await contractFactory.deploy();
	const portal = await contract.deployed();

	console.log("Deploying contracts with account:", deployer.address);
	console.log("Account balance: ", accountBalance.toString());
	console.log("Contract deployed to: ", portal.address);
	console.log("Contract deployed by: ", deployer.address);
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();
