pragma solidity >=0.7.0 <0.9.0;

library SafeMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256) {
        uint256 z = x + y;
        require(z > x, "unit overflow");
        return z;
    }
}

contract libTest {
    using SafeMath for uint256;

    function testAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return SafeMath.add(x,y);
    }
}
