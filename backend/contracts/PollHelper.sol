// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Owner.sol";
import "./SafeMath.sol";

contract PollHelper is Owner {
    struct Vote {
        address Voter;
        uint8 Opinion;
        uint256 Date;
    }

    struct Poll {
        address Owner;
        string Title;
        string[] Options;
        uint256 ExpireDate;
        uint256 InsertionDate;
        uint256 VotesCount;
    }

    using SafeMath for uint256;

    uint256 public TotalVotes;

    uint8 internal ExpireAfter = 90;
    uint8 public MaxPollsPerAddress = 5;
    uint8 internal MaxPollOptions = 32;

    mapping(address => uint8) public addressToPollCount;
    mapping(uint256 => Vote[]) public pollIdToVotes;

    Poll[] public Polls;

    // Looping over Votes of a specific poll to see if we can find someone with the same address.
    function _isVoted(address _voter, uint256 _pollId)
        private
        view
        returns (bool)
    {
        bool _res = false;
        uint256 _pollVotesCount = pollIdToVotes[_pollId].length;
        if (_pollVotesCount == 0) return _res;
        Vote[] memory _pollVotes = pollIdToVotes[_pollId];

        for (uint256 i = 0; i < _pollVotesCount; i++) {
            if (_pollVotes[i].Voter == _voter) _res = true;
        }
        return _res;
    }

    function isStringEmpty(string memory _input) internal pure returns (bool) {
        bytes memory b = bytes(_input);
        if (b.length == 0) return true;
        else return false;
    }

    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    // This modifier will prevent someone(address) from voting twice.
    modifier voteOnce(uint256 _pollId) {
        require(
            !_isVoted(msg.sender, _pollId),
            "You have already voted for this poll!"
        );
        _;
    }

    modifier pollLimit() {
        require(
            addressToPollCount[msg.sender] < MaxPollsPerAddress,
            "You have reached max poll per address!"
        );
        _;
    }

    // function _isOptionValid(uint256 _option) private view returns (bool) {
    //     return (_option >= 0 && _option <= MaxPollOptions);
    // }

    modifier validatePollId(uint256 _pollId) {
        require(_pollId < Polls.length, "Invalid PollId :/");
        require(
            Polls[_pollId].ExpireDate <
                block.timestamp * (ExpireAfter * 1 days),
            "Poll Is Expired :("
        );
        _;
    }

    modifier validateOption(uint256 _pollId, uint256 _option) {
        uint256 pollLength = Polls[_pollId].Options.length;
        require(_option >= 0 && _option <= pollLength, "Invalid Option :(");
        _;
    }

    event NewPoll(
        uint256 _pollId,
        string _title,
        string[] _options,
        uint256 _expireDate,
        uint256 _insertionDate
    );

    event NewVote(uint256 indexed _pollId, uint8 _option);
}
