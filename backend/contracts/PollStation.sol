// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./PollHelper.sol";

contract PollStation is PollHelper {
    using SafeMath for uint256;

    function createPoll(string memory _title, string[] memory _options)
        public
        payable
        pollLimit
    {
        require(!isStringEmpty(_title), "Title can't be empty :/");
        require(
            _options.length >= 3 && _options.length <= MaxPollOptions,
            "You can only define 3 to 32 options!"
        );

        // push the new poll to polls list
        uint256 time = block.timestamp;
        Poll memory poll = Poll(
            msg.sender,
            _title,
            _options,
            time + (ExpireAfter * 1 days),
            time,
            0
        );
        Polls.push(poll);

        // fires the NewPoll Event
        emit NewPoll(
            Polls.length - 1,
            _title,
            _options,
            time + (ExpireAfter * 1 days),
            time
        );

        //increace the poll count of the address
        addressToPollCount[msg.sender]++;
    }

    function vote(uint256 _pollId, uint8 _option)
        external
        payable
        voteOnce(_pollId)
        validatePollId(_pollId)
        validateOption(_pollId, _option)
    {
        //push the new vote to poll's vote list
        pollIdToVotes[_pollId].push(
            Vote(msg.sender, _option, uint32(block.timestamp))
        );

        //increase the vote count;
        Polls[_pollId].VotesCount = Polls[_pollId].VotesCount.add(1);

        // fires the NewVote Event
        emit NewVote(_pollId, _option);

        //increase the total votes
        TotalVotes = TotalVotes.add(1);
    }

    function getPolls() external view returns (Poll[] memory) {
        return Polls;
    }

    function getPollVotes(uint256 _pollId)
        external
        view
        validatePollId(_pollId)
        returns (Vote[] memory)
    {
        return pollIdToVotes[_pollId];
    }

    function getPoll(uint256 _pollId)
        external
        view
        validatePollId(_pollId)
        returns (Poll memory)
    {
        return Polls[_pollId];
    }

    // voteOnce(_pollId)
    function hasVoted(uint256 _pollId) external view returns (bool, int8) {
        bool _voted = false;
        int8 _option = -1;

        Vote[] memory voteList = pollIdToVotes[_pollId];
        for (uint256 i = 0; i < voteList.length; i++) {
            if (voteList[i].Voter == msg.sender) {
                _voted = true;
                _option = int8(voteList[i].Opinion);
            }
        }
        return (_voted, _option);
    }
}
