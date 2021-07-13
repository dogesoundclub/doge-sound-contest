pragma solidity ^0.5.6;
pragma experimental ABIEncoderV2;

interface IDogeSoundClubSlogan {
    
    event RegisterCandidate(address indexed register, uint256 indexed candidate, string slogan, uint256 count);
    event Vote(address indexed voter, uint256 indexed candidate, uint256 count);
    
    function HOLIDAY_PERIOD() view external returns (uint8);
    function REGISTER_CANDIDATE_PERIOD() view external returns (uint8);
    function VOTE_PERIOD() view external returns (uint8);
    
    function candidates(uint256 r) view external returns (string[] memory);
    function votes(uint256 r, uint256 candidate) view external returns (uint256);
    function mateVoted(uint256 r, uint256 id) view external returns (bool);
    
    function round() view external returns (uint256);
    function period() view external returns (uint8);
    
    function registerCandidate(string calldata slogan, uint256 count) external;
    function vote(uint256 candidate, uint256 count) external;
    function elected(uint256 r) external returns (uint256);    
}
