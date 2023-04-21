const main = async () => {
	const contractFactory = await hre.ethers.getContractFactory("Portal");
	const contract = await contractFactory.deploy({
		value: hre.ethers.utils.parseEther("0.1"),
	});
	await contract.deployed();
	console.log("Contract added to: ", contract.address);

	let contractBalance = await hre.ethers.provider.getBalance(contract.address);
	console.log(
		"Contract balance: ",
		hre.ethers.utils.formatEther(contractBalance)
	);

	// post twice
	const txn1 = await contract.post("first message!!");
	await txn1.wait();

	const txn2 = await contract.post("second message!!");
	await txn2.wait();

	contractBalance = await hre.ethers.provider.getBalance(contract.address);

	console.log(
		"Contract balance: ",
		hre.ethers.utils.formatEther(contractBalance)
	);

	let allPosts = await contract.getAllPosts();
	console.log(allPosts);
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
