pragma solidity ^0.4.16;


/**
@title SecretSend
@dev This contract allows two users to agree on contract attached to encrypted content
*/

contract SecretSend {

    // @dev Agreement structure represents an agreement made by both parties
    // @dev A complete agreement is made when both bools equal true
    struct Agreement {
        bool approvedByA;
        bool approvedByB;
    }



    // @dev general variable declaration for variables used in the smart contract
    address public user1;       //address of user1
    address public user2;       //address of user2
    bytes32 public location1;   //location of user1
    bytes32 public location2;   //location of user2
    bytes32 public mediaHash;   //encrypted content to which contract is connected
    bytes32 public timeStamp;   //timestamp of contract

    // @dev this mapping associates agreement structure with the hashed content
    mapping (bytes32 => Agreement) public agreements;

    // @dev arrays to track media not yet agreed upon and media agreed upon
    bytes32[] public mediaList; // all
    bytes32[] public approvedDocument; // approved

    // @notice LogProposedDocument records the address of proposer and hased document
    // @dev event listeners for new agreements and approvals to agreements
    event LogProposedDocument(address proposer, bytes32 mediaHashed);
    
    event LogApprovedDocument(address approver, bytes32 mediaHashed);

    // @dev allows only signers of the agreement to interact with agreement aka failsafe
    modifier onlySigners() {
        require(msg.sender == user1 || msg.sender == user2);
        _;
    }
    
    /// @param _user1 public wallet address
    /// @param _user2 public wallet address
    /// @param _dataUser1 bytes32 hash of the combination of location, email, phone.
    /// @param _dataUser2 the inputs are combined, hashed and stored by user
    /// @param _content the content to be hased at contruction of contract
    function SecretSend(
        address _user1,
        address _user2,
        bytes32 _dataUser1,
        bytes32 _dataUser2,
        bytes32 _content
        ) public {
        user1 = _user1;
        user2 = _user2;
        location1 = _dataUser1;
        location2 = _dataUser2;
        mediaHash = keccak256(_content);
        timeStamp = keccak256(block.timestamp);
    }

    // @dev returns the number of hashed contents in media list array between both senders
    function getSecretsCount() public view returns(uint256) {
        return mediaList.length;
    }

    // @dev returns the number of agreements made on an individual piece of content
    function getAgreementsCount() public view returns(uint256) {
        return approvedDocument.length;
    }

    // @dev only the signers restriction here
    // @dev both user1 and user2 need to call this function in order for agreement to be made
    // @dev when called by the 1st signer the hashed media is added to proposed media array
    // @dev when called by the 2nd signer the hashed media is added to approved media array
    // @dev both events are recorded in event listeners defined above
    function agreeDoc() public onlySigners returns(bool success) {
        if (msg.sender == user1) agreements[mediaHash].approvedByA = true;
        if (msg.sender == user2) agreements[mediaHash].approvedByB = true; 

        if (agreements[mediaHash].approvedByA == true && agreements[mediaHash].approvedByB == true) {
            approvedDocument.push(mediaHash);
            LogApprovedDocument(msg.sender, mediaHash);
        } else {
            mediaList.push(mediaHash);
            LogProposedDocument(msg.sender, mediaHash);
        }
        return true;
    }

    // @dev this function is here intentionally for development
    // @notice this is a major security vulnerability and should be removed for production
    function destroyAndSend() public {
        address _recipient = msg.sender; 
        selfdestruct(_recipient);
    }
}