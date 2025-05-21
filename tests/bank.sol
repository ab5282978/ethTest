// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Bank {
    mapping(address => uint256) public balances;

    struct TopDepositor {
        address addr;
        uint256 amount;
    }

    //用数据记录存款前三名
    TopDepositor[] public tops;

    constructor() {
        // 初始化排行榜
        for (uint256 i = 0; i < 3; i++) {
            tops.push(TopDepositor(address(0), 0));
        }
    }

    function deposit(uint256 amount) public payable {
        require(msg.value == amount, "Amount mismatch with value sent");
        balances[msg.sender] += msg.value;
        //更新排行榜
        _updateTops(msg.sender);
    }

    function getBalances() public view returns (uint256) {
        return balances[msg.sender];
    }

    function withdraw(uint256 money) public {
        require(money <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= money;
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
