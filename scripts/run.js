const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory("WackoWordsNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Contract deployed to:", nftContract.address);

    let rand = await nftContract.pickRandomFirstWord(0);
    console.log(rand)
    rand = await nftContract.pickRandomFirstWord(1);
    console.log(rand)
    rand = await nftContract.pickRandomFirstWord(2);
    console.log(rand)
    rand = await nftContract.pickRandomFirstWord(3);
    console.log(rand)

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();
    let txn2 = await nftContract.makeAnEpicNFT();
    await txn2.wait();
    let txn3 = await nftContract.makeAnEpicNFT();
    await txn3.wait();
    let txn4 = await nftContract.makeAnEpicNFT();
    await txn4.wait();



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