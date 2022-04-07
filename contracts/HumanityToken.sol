//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

interface ERC20Interface {
    function totalSupply() external view returns (uint256); //* done

    function balanceOf(address tokenOwner) external view returns (uint256); //* Done

    function transfer(
        address recipient,
        uint256 tokens //* done
    ) external returns (bool);

    function allowance(address tokenOwner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 tokens) external returns (bool);

    function transferFrom(
        address from,
        address recipient,
        uint256 tokens
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 tokens); //* done
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 tokens
    );
}

contract HumanityToken is ERC20Interface {
    string public tokenName = "Helper";
    string public tokenSymbol = "HPR";

    string public decimal = "0";

    uint256 public override totalSupply;

    address public founder; //!! founder address for this token
    mapping(address => uint256) balances; //!! for knowing the balance of any address

    mapping(address => mapping(address => uint256)) allowedTokens; //!! owner address that allowd other address to use token

    constructor() {
        totalSupply = 100000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    //transfer token
    function    (address recipient, uint256 tokens)
        public
        override
        returns (bool)
    {
        require(
            balances[msg.sender] >= tokens,
            "Not enough tokens to transfer"
        );

        balances[msg.sender] -= tokens;
        balances[recipient] += tokens;

        emit Transfer(msg.sender, recipient, tokens);
        return true;
    }

    //if user wants that other user should use his token-> allow that spneder address for token
    function approve(address spender, uint256 tokens)
        public
        override
        returns (bool)
    {
        require(msg.sender != spender, "Token Owner can't be spender");
        require(balances[msg.sender] >= tokens, "Not enough tokens to share");

        allowedTokens[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    //getter for seeing allowedTokens for any user
    function allowance(address tokenOwner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return allowedTokens[tokenOwner][spender];
    }

    //transfer token to allowed token
    function transferFrom(
        address from,
        address recipient,
        uint256 tokens
    ) public override returns (bool) {
        require(from != recipient, "Token can't be transferred to yourself");
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        balances[recipient] += tokens;

        return true;
    }
}
