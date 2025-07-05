// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Task{
    function task02(string memory str) public pure returns ( string memory ){
        bytes memory bytesInput = bytes(str);
        bytes memory resultStr = new bytes(bytesInput.length);
        for (uint i = 0; i < bytesInput.length; i++) {
            resultStr[i] = bytesInput[bytesInput.length - 1 - i];
        }
        return string(resultStr);
    }

    // replace `function PiggyBank public()` to `constructor()`
    constructor() {
    }
    




    mapping(bytes8 => uint) public romanValues;
    
    //罗马数字转整数
    function romanToInt(string memory roman) public returns (uint) {
        // 创建一个映射来存储罗马数字和其对应的整数值
        romanValues['I'] = 1;
        romanValues['V'] = 5;
        romanValues['X'] = 10;
        romanValues['L'] = 50;
        romanValues['C'] = 100;
        romanValues['D'] = 500;
        romanValues['M'] = 1000;
        
        uint result = 0; // 存储最终结果的变量
        uint prevValue = 0; // 上一个罗马数字的值，初始化为0
        uint romanLength = bytes(roman).length;
        for (uint i = 0; i < romanLength; i++) {
            bytes1 currentChar = bytes(roman)[i]; // 获取当前字符
            uint currentValue = romanValues[currentChar]; // 获取当前字符的值
            if (i < bytes(roman).length - 1) { // 如果不是最后一个字符，检查下一个字符的值
                bytes1 nextChar = bytes(roman)[i + 1]; // 获取下一个字符
                uint nextValue = romanValues[nextChar]; // 获取下一个字符的值
                if (currentValue < nextValue) { // 如果当前值小于下一个值，进行减法操作
                    result -= currentValue;
                } else { // 否则进行加法操作
                    result += currentValue;
                }
            } else { // 如果处理的是最后一个字符，直接加到结果中（因为没有下一个字符可以比较）
                result += currentValue;
            }
            prevValue = currentValue; // 更新prevValue为当前值，为下一次循环做准备（虽然在这个例子中用处不大）
        }
        return result; // 返回计算结果
    }






}
