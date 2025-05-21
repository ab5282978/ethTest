// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//新增权限控制
//编写 Bank合约 withdraw(), 实现只有管理员提取出所有的 ETH
contract Bank {

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Noet owner");
        _;
    }

    mapping(address => uint256) public balances;

    struct TopDepositor {
        address addr;
        uint256 amount;
    }

    //用数据记录存款前三名
    TopDepositor[] public tops;

    constructor() {
        owner = msg.sender;
        // 初始化排行榜
        for (uint256 i = 0; i < 3; i++) {
            tops.push(TopDepositor(address(0), 0));
        }
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function deposit(uint256 amount) public virtual  payable {
        require(msg.value == amount, "Amount mismatch with value sent");
        balances[msg.sender] += msg.value;
        //更新排行榜
        _updateTops(msg.sender);
    }

    function getBalances() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdraw(uint256 money) public onlyOwner{
        payable(msg.sender).transfer(money);
    }

    //内部方法，更新排行榜
    function _updateTops(address depositor) internal {
        uint256 amount = balances[depositor];
        for (uint256 i = 0; i < 3; i++) {
            if (tops[i].addr == depositor) {
                tops[i].amount = amount;
                _sortTopDepositors();
                return;
            }
        }
        for (uint256 i = 0; i < 3; i++) {
            if (amount > tops[i].amount) {
                tops[i] = TopDepositor(depositor, amount);
                _sortTopDepositors();
                return;
            }
        }
    }

    function getTopDepositors() public view returns (TopDepositor[] memory) {
        return tops;
    }

    function _sortTopDepositors() internal {
        for (uint256 i = 0; i < 2; i++) {
            for (uint256 j = i + 1; j < 3; j++) {
                if (tops[j].amount > tops[i].amount) {
                    TopDepositor memory temp = tops[i];
                    tops[i] = tops[j];
                    tops[j] = temp;
                }
            }
        }
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        //更新排行榜
        _updateTops(msg.sender);
    }
}

contract bigBank is Bank{
    modifier isAllowdDeposit(){
        require(msg.value >= 100000000000000000 ,"bigger then 0.1 is allowd");
        _;
    }


    function deposit(uint256 amount) public override  isAllowdDeposit payable {
        super.deposit(amount);
        
    }

}
