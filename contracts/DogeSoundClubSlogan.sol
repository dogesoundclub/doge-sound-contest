pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/IKIP17Enumerable.sol";
import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/math/SafeMath.sol";
import "./interfaces/IDogeSoundClubSlogan.sol";

contract DogeSoundClubSlogan is Ownable, IDogeSoundClubSlogan {
    using SafeMath for uint256;

    uint8 public constant HOLIDAY_PERIOD = 0;
    uint8 public constant REGISTER_CANDIDATE_PERIOD = 1;
    uint8 public constant VOTE_PERIOD = 2;

    IKIP17Enumerable public mate;

    uint256 public checkpoint;
    uint256 public checkpointRound;
    
    uint256 public holidayInterval = uint256(-1);
    uint256 public candidateInterval = uint256(-1);
    uint256 public candidateMateCount = 20;
    uint256 public voteInterval = uint256(-1);

    mapping(uint256 => string[]) public candidates;
    mapping(uint256 => mapping(uint256 => uint256)) public votes;
    mapping(uint256 => mapping(uint256 => bool)) public mateVoted;

    constructor(IKIP17Enumerable _mate) public {
        mate = _mate;
    }

    function candidateCount(uint256 r) view external returns (uint256) {
        return candidates[r].length;
    }

    function candidate(uint256 r, uint256 index) view external returns (string memory) {
        return candidates[r][index];
    }

    function changeCheckpoint() internal {
        if (checkpoint == 0 || holidayInterval == uint256(-1) || candidateInterval == uint256(-1) || voteInterval == uint256(-1)) {
            checkpoint = block.number;
        } else {
            uint256 interval = holidayInterval.add(candidateInterval).add(voteInterval);
            uint256 blocks = block.number.sub(checkpoint);
            checkpointRound = checkpointRound.add(blocks.div(interval));
            checkpoint = block.number.sub(blocks.mod(interval));
        }
    }

    function setHolidayInterval(uint256 interval) onlyOwner external {
        changeCheckpoint();
        holidayInterval = interval;
    }

    function setCandidateInterval(uint256 interval) onlyOwner external {
        changeCheckpoint();
        candidateInterval = interval;
    }

    function setVoteInterval(uint256 interval) onlyOwner external {
        changeCheckpoint();
        voteInterval = interval;
    }

    function setCandidateMateCount(uint256 count) onlyOwner external {
        candidateMateCount = count;
    }

    function round() view public returns (uint256) {
        return checkpointRound.add(block.number.sub(checkpoint).div(holidayInterval.add(candidateInterval).add(voteInterval)));
    }

    function voteMate(uint256 r, uint256 count, uint256 balance) internal {

        require(count > 0 && balance >= count);

        uint256 mateVotedCount = 0;
        for (uint256 index = 0; index < balance; index += 1) {
            uint256 id = mate.tokenOfOwnerByIndex(msg.sender, index);
            if (mateVoted[r][id] != true) {
                mateVoted[r][id] = true;
                mateVotedCount = mateVotedCount.add(1);
                if (mateVotedCount == count) {
                    break;
                }
            }
        }

        require(mateVotedCount == count);
    }

    function period() view public returns(uint8) {
        uint256 remain = block.number.sub(checkpoint).mod(holidayInterval.add(candidateInterval).add(voteInterval));
        if (remain >= holidayInterval.add(candidateInterval)) {
            return VOTE_PERIOD;
        } else if (remain >= candidateInterval) {
            return REGISTER_CANDIDATE_PERIOD;
        } else {
            return HOLIDAY_PERIOD;
        }
    }

    function registerCandidate(string calldata slogan, uint256 count) external {
        require(period() == REGISTER_CANDIDATE_PERIOD);

        uint256 balance = mate.balanceOf(msg.sender);
        require(balance >= candidateMateCount);

        uint256 r = round();
        voteMate(r, count, balance);

        uint256 _candidate = candidates[r].length;
        candidates[r].push(slogan);
        votes[r][_candidate] = count;
    }

    function vote(uint256 _candidate, uint256 count) external {
        require(period() == VOTE_PERIOD);

        uint256 r = round();
        voteMate(r, count, mate.balanceOf(msg.sender));
        
        votes[r][_candidate] = votes[r][_candidate].add(count);
    }

    function elected(uint256 r) view external returns (uint256) {

        uint256 _candidateCount = candidates[r].length;
        uint256 maxVote = 0;
        uint256 electedCandidate = 0;

        for (uint256 _candidate = 0; _candidate < _candidateCount; _candidate += 1) {
            uint256 v = votes[r][_candidate];
            if (maxVote < v) {
                maxVote = v;
                electedCandidate = _candidate;
            }
        }

        return electedCandidate;
    }
}
