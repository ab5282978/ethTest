// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract LKCToken {
    //定义代币
    string public name = "LKC coin";
    string public symbol = "LKC";
    //小数位数
    uint256 public decimals = 18;
    //总供应量
    uint256  public totalSupply;

    //记录余额
    mapping(address => uint256) private  balances;

    //授权数组  授权者key 消费者：金额 value
    mapping(address => mapping (address => uint256)) allowances;

    //转账事件定义
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256  value);

    // --- 构造函数：部署时一次性铸造全部代币 ---
    constructor(uint256 _initialSupply){
        totalSupply = _initialSupply;
        balances[msg.sender] = _initialSupply;
        emit Transfer(address(0),msg.sender,_initialSupply);
    }

    //查询余额
    function balanceOf(address _owner) external view returns (uint256){
        return balances[_owner];
    }

    function transfer(address _to ,uint256 _amount) external returns (bool success ){
        require(balances[msg.sender] >= _amount,"not enough balance");
        balances[msg.sender] -= _amount;
        balances[_to] +=  _amount;
        emit Transfer(msg.sender,_to,_amount);
        return true;
    }

    //授权功能 授权某个人可以使用这个金额
    function approve(address _spender,uint256 _amount)
    external returns (bool)
    {
        allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender,_spender,_amount);
        return true;
    }

    //查询可以使用的额度
    function allowance(address _owner, address _spender) external view returns (uint256){
        return allowances[_owner][_spender];
    }


    // --- 在授权范围内转账 ---
    function transferFrom(address _from,address _to ,uint _amount) 
    external returns (bool  ){
        uint256 allowanAmount = allowances[_from][_to];
        require(allowanAmount >= _amount ,"Allowance exceeded");
        require(balances[_from] >=  _amount ,"Balance too low");
        // 扣除授权和余额
        allowances[_from][_to] = allowanAmount - _amount;
        balances[_from] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;

    }


}
