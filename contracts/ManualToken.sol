// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf; // This creates an array with all balances
    mapping(address => mapping(address => uint256)) public allowanceAmt;

    //events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) {
        totalSupply = initialSupply * 10**decimals; // Update total supply with the decimal amount
        name = tokenName; // Set the name for display purposes
        symbol = tokenSymbol; // Set the symbol for display purposes
        balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != address(0x0), "Can't transfer to null address");

        // Check if the sender has enough
        require(balanceOf[_from] >= _amount, "Sender has not enough balance");

        // Check for overflows
        require(balanceOf[_to] + _amount >= balanceOf[_to], "Overflow");
        // Save this for an assertion in the future
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];

        // Subtract from the sender
        balanceOf[_from] -= _amount;

        // Add to the receiver
        balanceOf[_to] += _amount;

        emit Transfer(_from, _to, _amount);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_amount` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _amount the amount to send
     */
    function transfer(address _to, uint256 _amount)
        public
        returns (bool success)
    {
        _transfer(msg.sender, _to, _amount);
        success = true;
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_amount` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _amount the amount to send
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool success) {
        require(_amount <= allowanceAmt[_from][msg.sender]); //check allowance
        allowanceAmt[_from][msg.sender] -= _amount;
        _transfer(_from, _to, _amount);
        success = true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_amount` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _amount the max amount they can spend
     */
    function approve(address _spender, uint256 _amount)
        public
        returns (bool success)
    {
        allowanceAmt[msg.sender][_spender] = _amount;
        emit Approval(_spender, msg.sender, _amount);
        success = true;
    }

    /**
     * Returns the amount which `_spender` is still allowed to withdraw from `_owner`
     *
     * @param  _owner the address who allow to spend
     * @param _spender The address authorized to withdraw from
     */
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowanceAmt[_owner][_spender];
    }

    /**
     * Destroy tokens
     *
     * Remove `_amount` tokens from the system irreversibly
     *
     * @param _amount the amount of money to burn
     */
    function burn(uint256 _amount) public returns (bool success) {
        require(balanceOf[msg.sender] >= _amount); //check if it has enough amount to burn
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Burn(msg.sender, _amount);
        success = true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_amount` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _amount the amount of money to burn
     */
    function burnFrom(address _from, uint256 _amount)
        public
        returns (bool success)
    {
        require(balanceOf[_from] >= _amount); // Check if the targeted balance is enough
        require(_amount <= allowanceAmt[_from][msg.sender]); //Check the allowance
        balanceOf[_from] -= _amount; // Subtract from the targeted balance
        allowanceAmt[_from][msg.sender] -= _amount; // Subtract from the sender's allowance
        totalSupply -= _amount; // Update totalSupply
        emit Burn(_from, _amount); // Emit event to notifiy
        success = true;
    }
}
