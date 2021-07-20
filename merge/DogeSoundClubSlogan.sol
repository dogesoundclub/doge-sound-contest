pragma solidity ^0.5.6;


/**
 * @dev Interface of the KIP-13 standard, as defined in the
 * [KIP-13](http://kips.klaytn.com/KIPs/kip-13-interface_query_standard).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others.
 *
 * For an implementation, see `KIP13`.
 */
interface IKIP13 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [KIP-13 section](http://kips.klaytn.com/KIPs/kip-13-interface_query_standard#how-interface-identifiers-are-defined)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an KIP17 compliant contract.
 */
contract IKIP17 is IKIP13 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either `approve` or `setApproveForAll`.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either `approve` or `setApproveForAll`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

/**
 * @title KIP-17 Non-Fungible Token Standard, optional enumeration extension
 * @dev See http://kips.klaytn.com/KIPs/kip-17-non_fungible_token
 */
contract IKIP17Enumerable is IKIP17 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address payable private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address payable) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address payable newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IDogeSoundClubSlogan {
    
    event RegisterCandidate(address indexed register, uint256 indexed _candidate, string slogan, uint256 count);
    event Vote(address indexed voter, uint256 indexed _candidate, uint256 count);
    
    function HOLIDAY_PERIOD() view external returns (uint8);
    function REGISTER_CANDIDATE_PERIOD() view external returns (uint8);
    function VOTE_PERIOD() view external returns (uint8);
    
    function candidateCount(uint256 r) view external returns (uint256);
    function candidate(uint256 r, uint256 index) view external returns (string memory);
    function totalVotes(uint256 r) view external returns (uint256);
    function userVotes(uint256 r, address user) view external returns (uint256);
    function votes(uint256 r, uint256 _candidate) view external returns (uint256);
    function mateVoted(uint256 r, uint256 id) view external returns (bool);
    
    function round() view external returns (uint256);
    function period() view external returns (uint8);
    function remains() view external returns (uint256);
    
    function registerCandidate(string calldata slogan, uint256 count) external;
    function vote(uint256 _candidate, uint256 count) external;
    function elected(uint256 r) view external returns (uint256);    
}

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
    mapping(uint256 => uint256) public totalVotes;
    mapping(uint256 => mapping(address => uint256)) public userVotes;
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

    function period() view public returns (uint8) {
        uint256 remain = block.number.sub(checkpoint).mod(holidayInterval.add(candidateInterval).add(voteInterval));
        if (remain >= holidayInterval.add(candidateInterval)) {
            return VOTE_PERIOD;
        } else if (remain >= holidayInterval) {
            return REGISTER_CANDIDATE_PERIOD;
        } else {
            return HOLIDAY_PERIOD;
        }
    }

    function remains() view public returns (uint256) {
        uint256 remain = block.number.sub(checkpoint).mod(holidayInterval.add(candidateInterval).add(voteInterval));
        if (remain >= holidayInterval.add(candidateInterval)) {
            return voteInterval.sub(remain.sub(holidayInterval).sub(candidateInterval));
        } else if (remain >= holidayInterval) {
            return candidateInterval.sub(remain.sub(holidayInterval));
        } else {
            return holidayInterval.sub(remain);
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
        totalVotes[r] = totalVotes[r].add(count);
        userVotes[r][msg.sender] = userVotes[r][msg.sender].add(count);
        votes[r][_candidate] = count;
    }

    function vote(uint256 _candidate, uint256 count) external {
        require(period() == VOTE_PERIOD);

        uint256 r = round();
        voteMate(r, count, mate.balanceOf(msg.sender));
        
        totalVotes[r] = totalVotes[r].add(count);
        userVotes[r][msg.sender] = userVotes[r][msg.sender].add(count);
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