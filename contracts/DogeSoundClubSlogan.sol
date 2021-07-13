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
    uint256 public voteInterval = uint256(-1);
    uint256 public voterMateCount = 20;

    mapping(uint256 => string[]) public candidates;
    mapping(uint256 => mapping(uint256 => uint256)) public votes;
    mapping(uint256 => mapping(uint256 => bool)) public mateVoted;

    constructor(IKIP17Enumerable _mate) public {
        mate = _mate;
    }

    function changeCheckpoint(uint256 toInterval) internal {
        if (holidayInterval != uint256(-1) && candidateInterval != uint256(-1) && voteInterval != uint256(-1)) {
            if (checkpoint == 0) {
                checkpoint = block.number;
            } else {
                
                uint256 interval = holidayInterval + candidateInterval + voteInterval;
                uint256 blocks = (block.number - checkpoint);
                checkpointRound += blocks / interval;

                uint256 remain = blocks % interval;
                int256 diff = int256(toInterval) - int256(interval);
                checkpoint = uint256(int256(block.number) - int256(remain) + diff);
            }
        }
    }

    function setHolidayInterval(uint256 interval) onlyOwner external {
        changeCheckpoint(interval + candidateInterval + voteInterval);
        holidayInterval = interval;
    }

    function setCandidateInterval(uint256 interval) onlyOwner external {
        changeCheckpoint(holidayInterval + interval + voteInterval);
        candidateInterval = interval;
    }

    function setVoteInterval(uint256 interval) onlyOwner external {
        changeCheckpoint(holidayInterval + candidateInterval + interval);
        voteInterval = interval;
    }

    function setVoterMateCount(uint256 count) onlyOwner external {
        voterMateCount = count;
    }

    function round() view public returns (uint256) {
        return checkpointRound + (block.number - checkpoint) / (holidayInterval + candidateInterval + voteInterval);
    }

    function voteMate(uint256 r, uint256 count) internal {

        require(count > 0);
        uint256 balance = mate.balanceOf(msg.sender);
        require(balance >= count);

        uint256 mateVotedCount = 0;
        for (uint256 index = 0; index < balance; index += 1) {
            uint256 id = mate.tokenOfOwnerByIndex(msg.sender, index);
            if (mateVoted[r][id] != true) {
                mateVoted[r][id] = true;
                mateVotedCount += 1;
                if (mateVotedCount == count) {
                    break;
                }
            }
        }

        require(mateVotedCount == count);
    }

    function period() view public returns(uint8) {
        uint256 remain = (block.number - checkpoint) / (holidayInterval + candidateInterval + voteInterval);
        if (remain >= holidayInterval + candidateInterval) {
            return VOTE_PERIOD;
        } else if (remain >= candidateInterval) {
            return REGISTER_CANDIDATE_PERIOD;
        } else {
            return HOLIDAY_PERIOD;
        }
    }

    function registerCandidate(string calldata slogan, uint256 count) external {
        require(period() == REGISTER_CANDIDATE_PERIOD);

        uint256 r = round();
        voteMate(r, count);

        uint256 candidate = candidates[r].length;
        candidates[r].push(slogan);
        votes[r][candidate] = count;
    }

    function vote(uint256 candidate, uint256 count) external {
        require(period() == VOTE_PERIOD);

        uint256 r = round();
        voteMate(r, count);
        
        votes[r][candidate] += count;
    }

    function elected(uint256 r) external returns (uint256) {

        uint256 candidateCount = candidates[r].length;
        uint256 maxVote = 0;
        uint256 electedCandidate = 0;

        for (uint256 candidate = 0; candidate < candidateCount; candidate += 1) {
            uint256 v = votes[r][candidate];
            if (maxVote < v) {
                maxVote = v;
                electedCandidate = candidate;
            }
        }

        return electedCandidate;
    }
}
