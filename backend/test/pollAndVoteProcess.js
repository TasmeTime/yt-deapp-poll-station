const PollStationArtifact = artifacts.require("PollStation");

contract("PollStation", (accounts) => {
  const [acc1, acc2, acc3, acc4, acc5] = accounts;
  let pollStation;
  beforeEach(async () => {
    pollStation = await PollStationArtifact.new();
  });
  xit("Should be able to register a poll", async () => {
    let pollId = await pollStation.createPoll(
      "What is you prefered text editor",
      ["NotePad", "Visual Studio Code", "Sublime", "Atom"]
    );

    const title = pollId.receipt.logs[0].args._title;
    const options = pollId.receipt.logs[0].args._options;
    const expireDate = parseInt(pollId.receipt.logs[0].args._expireDate);
    const insertionDate = parseInt(pollId.receipt.logs[0].args._insertionDate);
    pollId = parseInt(pollId.receipt.logs[0].args._pollId);

    console.log("* NewPoll: ", {
      pollId,
      title,
      options,
      expireDate,
      insertionDate,
    });
  });
  xit("Should be able to vote using 2 different accounts", async () => {
    let pollId = await pollStation.createPoll(
      "What is you prefered text editor",
      ["NotePad", "Visual Studio Code", "Sublime", "Atom"]
    );
    await pollStation.createPoll("Choose a year :/", [
      "2011",
      "1998",
      "2022",
      "2015",
    ]);
    pollId = parseInt(pollId.receipt.logs[0].args._pollId);
    const voteRes = await pollStation.vote(pollId, 2);
    await pollStation.vote(pollId, 2, { from: acc2 });
    await pollStation.vote(pollId, 1, { from: acc3 });
    await pollStation.vote(pollId, 0, { from: acc4 });
    await pollStation.vote(pollId, 3, { from: acc5 });

    // const pollVotes = await pollStation.getPollVotes(pollId);
  });
  it("Should be able to vote and check voted", async () => {
    let pollId = await pollStation.createPoll(
      "What is you prefered text editor",
      ["NotePad", "Visual Studio Code", "Sublime", "Atom"]
    );
    let secPollId = await pollStation.createPoll(
      "What is you prefered text editor",
      ["NotePad", "Visual Studio Code", "Sublime", "Atom"]
    );

    const title = pollId.receipt.logs[0].args._title;
    const options = pollId.receipt.logs[0].args._options;
    const expireDate = parseInt(pollId.receipt.logs[0].args._expireDate);
    const insertionDate = parseInt(pollId.receipt.logs[0].args._insertionDate);
    pollId = parseInt(pollId.receipt.logs[0].args._pollId);
    secPollId = parseInt(secPollId.receipt.logs[0].args._pollId);

    const voteRes = await pollStation.vote(pollId, 2);
    const hasVotedRes = await pollStation.hasVoted(secPollId);
    // const [_hasVoted2, _option2] = await pollStation.hasVoted(secPollId);
    console.log("hasVotedRes:", hasVotedRes[0], hasVotedRes[1]);
    // console.log("hasVotedRes2:", _hasVoted2, _option2);

    // console.log("* NewPoll: ", {
    //   pollId,
    //   title,
    //   options,
    //   expireDate,
    //   insertionDate,
    // });
  });
});
