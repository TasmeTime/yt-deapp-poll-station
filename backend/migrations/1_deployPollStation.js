const PollStation = artifacts.require("./PollStation.sol");

module.exports = function (deployer) {
  deployer.then(async () => {
    await deployer.deploy(PollStation);
    const pollStationInstance = await PollStation.deployed();

    console.log(
      "\n*************************************************************************\n"
    );
    console.log(`PollStation Contract Address: ${pollStationInstance.address}`);

    console.log(
      "\n*************************************************************************\n"
    );
  });
};
