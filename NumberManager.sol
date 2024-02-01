// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract NumberManager {
    uint private totalSum;
    uint public lastAddedNumber;

    constructor() {
        totalSum = 0;
        lastAddedNumber = 0;
    }

    function addNumber(uint number) public {
        totalSum += number;
        lastAddedNumber = number;
    }

    function getTotalSum() external view returns(uint) {
        return totalSum;
    }

    function increasementTotalSum(uint number) private {
        totalSum += number;
    }

    function increasementTotalSumPublic(uint number) public  {
        increasementTotalSum(number);
    }
}
