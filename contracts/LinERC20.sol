// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LinERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public _name;//代币名称
    string private _symbol;//代币简名
    uint8 private _decimals;//代币精度
    uint256 private _totalSupply;//发行代币总数
    mapping(address => uint256) private _balances;//代币持有记录
    mapping(address => mapping(address => uint256)) private _allowances;//代币授权第三方记录
    address public _owner;//代币发行人
    //方法执行监听
    modifier onlyOwner() {
        //调前校验
        require(msg.sender == _owner, "Only owner can mint");
        _;
        //调用后不做
    }
    

    constructor(){
        _name = "LinERC20";
        _symbol = "LREC";
        _decimals = 1;
        _owner = msg.sender;
        mint(_owner,1000*10000*1**18);//发行1000W代币
    }
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }
    function _mint(address account, uint256 amount) internal {
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }


    function name() public view returns(string memory){
        return _name;
    }
    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }
    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }
    function balanceOf(address owner) public view returns (uint256 balance){
        return _balances[owner];
    }

    //转账
    function transfer(address to, uint256 amount) public returns (bool success){
        address from = msg.sender;
        _transfer(from,to,amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0),"ERC20:transfer from the zreo address");
        require(to != address(0),"ERC20:transfer to the zreo address");
        require(_balances[from]>= amount,unicode"ERC20：余额不足");
        unchecked{
            _balances[from] -= amount;
            _balances[to] += amount;
        }

    }

    //授权支出额度
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address owner_, address spender, uint256 amount) internal {
        require(owner_ != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");
        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    //授权后可通过transferFrom进行代扣
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {

        //扣除授权的金额
        _spendAllowance(from, msg.sender, amount);
        //转账到账号的余额
        _transfer(from, to, amount);
        return true;
    }


    function _spendAllowance(address owner_, address spender, uint256 amount) internal {
        uint256 currentAllowance = _allowances[owner_][spender];
        require(currentAllowance >= amount, "Insufficient allowance");
        unchecked {
            _approve(owner_, spender, currentAllowance - amount);
        }
    }
    //查询授权额度
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return _allowances[_owner][_spender];
    }
    
}

