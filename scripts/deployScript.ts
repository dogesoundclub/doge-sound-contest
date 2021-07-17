import hardhat from "hardhat";

async function main() {
    console.log("deploy start")

    const DogeSoundClubSlogan = await hardhat.ethers.getContractFactory("DogeSoundClubSlogan")
    const slogan = await DogeSoundClubSlogan.deploy()
    console.log(`DogeSoundClubSlogan address: ${slogan.address}`)
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
