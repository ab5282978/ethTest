// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract EventTest{
    event Transer(address indexed from,address indexed to ,uint256 amount);

    mapping(address => uint256) public  balances;


}
