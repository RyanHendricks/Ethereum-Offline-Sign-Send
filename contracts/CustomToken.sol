pragma solidity ^0.4.15;


library SafeMath {
    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint a, uint b) internal pure returns (uint) {
        require(b > 0);
        uint c = a / b;
        require(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c>=a && c>=b);
        return c;
    }

    /// The following functions are meant to catch function calls
    /// that do not use the 'Safe' prefix
    function mul(uint a, uint b) internal pure returns (uint) {
        safeMul(a,b);
    }

    function div(uint a, uint b) internal pure returns (uint) {
        safeDiv(a,b);
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        safeSub(a,b);
    }

    function add(uint a, uint b) internal pure returns (uint) {
        safeAdd(a,b);
    }

    /// Same as the above except catching functions that do 
    /// not follow the camelCase spec for function names
    function Mul(uint a, uint b) internal pure returns (uint) {
        safeMul(a,b);
    }

    function Div(uint a, uint b) internal pure returns (uint) {
        safeDiv(a,b);
    }

    function Sub(uint a, uint b) internal pure returns (uint) {
        safeSub(a,b);
    }

    function Add(uint a, uint b) internal pure returns (uint) {
        safeAdd(a,b);
    }
}



// Standard token interface (ERC 20)
// https://github.com/ethereum/EIPs/issues/20
contract ERC20 {

    // Functions:
    /// @return total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public returns (uint256);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public returns (uint256);

    // Events:
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Owned {

    /**
     * Contract owner address
     */
    address public owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function isOwner(address _address) internal view returns (bool) {
        require(_address == owner);
    }

}


/**
 * @title Token contract represents any asset in digital economy
 */
contract Token is ERC20 {

    using SafeMath for *;
    /* Short description of token */
    string public name;
    string public symbol;

    /* Total count of tokens exist */
    uint256 public totalSupply;

    /* Fixed point position */
    uint256 public decimals;

    /* Token approvement system */
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    /* Token constructor */
    function Token(string _name, string _symbol, uint8 _decimals, uint256 _count) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _count;
        balances[msg.sender] = _count;
    }

    /**
     * @dev Get balance of plain address
     * @param _owner is a target address
     * @return amount of tokens on balance
     */
    function balanceOf(address _owner) public returns (uint256) {
        return balances[_owner];
    }

    /**
     * @dev Take allowed tokens
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer the tokens
     * @return Amount of remaining tokens allowed to spent
     */
    function allowance(address _owner, address _spender) public returns (uint256) {
        return allowances[_owner][_spender];
    }

    /**
     * @dev Transfer self tokens to given address
     * @param _to destination address
     * @param _value amount of token values to send
     * @notice `_value` tokens will be sended to `_to`
     * @return `true` when transfer done
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        if (balances[msg.sender] >= _value) {
            balances[msg.sender] -= _value;
            balances[_to]        += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
     * @dev Transfer with approvement mechainsm
     * @param _from source address, `_value` tokens shold be approved for `sender`
     * @param _to destination address
     * @param _value amount of token values to send
     * @notice from `_from` will be sent `_value` tokens to `_to`
     * @return `true` when transfer is done
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        var avail = allowances[_from][msg.sender] > balances[_from] ? balances[_from] : allowances[_from][msg.sender];
        if (avail >= _value) {
            allowances[_from][msg.sender] -= _value;
            balances[_from] -= _value;
            balances[_to]   += _value;
            Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }

    /**
     * @dev Give to target address ability for self token manipulation without sending
     * @param _spender target address (future requester)
     * @param _value amount of token values for approving
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowances[msg.sender][_spender] += _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Reset count of tokens approved for given address
     * @param _spender target address (future requester)
     */
    function unapprove(address _spender) public {
        allowances[msg.sender][_spender] = 0;
    }
}

contract CustomToken is Owned, Token {
    using SafeMath for *;

    event Emission(uint256 _value);

    function CustomToken(string _name, string _symbol, uint8 _decimals, uint256 startSupply)
    public
    Token(_name, _symbol, _decimals, startSupply) 
    {}

    /**
     * @dev Token emission
     * @param _value amount of token values to emit
     * @notice receiver balance will be increased by `_value`
     */
    function emission(address receiver, uint256 _value) public onlyOwner {
        // Overflow check
        if (_value + totalSupply < totalSupply) {
            revert();
        } else {
            totalSupply += _value;
            balances[receiver] += _value;
            Emission(_value);
        }
    }

    event Burn(address indexed burner, uint256 value);


    function burn(uint256 _value) public {
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}