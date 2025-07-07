// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Task{

    //2：反转字符串 (Reverse String)
    function task02(string memory str) public pure returns ( string memory ){
        bytes memory bytesInput = bytes(str);
        bytes memory resultStr = new bytes(bytesInput.length);
        for (uint i = 0; i < bytesInput.length; i++) {
            resultStr[i] = bytesInput[bytesInput.length - 1 - i];
        }
        return string(resultStr);
    }

    mapping(bytes1 => uint)  romanValues;
    // replace `function PiggyBank public()` to `constructor()`
    constructor() {
        // 创建一个映射来存储罗马数字和其对应的整数值
        romanValues['I'] = 1;
        romanValues['V'] = 5;
        romanValues['X'] = 10;
        romanValues['L'] = 50;
        romanValues['C'] = 100;
        romanValues['D'] = 500;
        romanValues['M'] = 1000;
    }
    
    //3：用 solidity 实现整数转罗马数字
    function romanToInt(string memory roman) public view returns (uint) {
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



    //4:用 solidity 实现罗马数字转数整数
    function intToRoman(uint number) public pure returns (string memory) {
        string memory result;// 存储最终结果的变量
        uint16[13] memory values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        string[13] memory  symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
        uint valuesLeng = values.length;
        for(uint i= 0 ; i < valuesLeng; i++ ){
            uint16  value = values[i];
            string memory symbol = symbols[i];
            while (number>=value){
                number -= value;
                result = concatStrings(result,symbol);
            }
        }
        return result;
    }
    //拼接字符串
    function concatStrings(string memory a, string memory b) public pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }



    //5:合并两个有序数组 (Merge Sorted Array)
    function mergeSortedArrays(uint[] memory arr1, uint[] memory arr2) public pure returns (uint[] memory) {
        uint[] memory result = new uint[](arr1.length + arr2.length);
        uint index1 = 0;
        uint index2 = 0;
        uint resultIndex = 0;
 
        while (index1 < arr1.length && index2 < arr2.length) {
            if (arr1[index1] < arr2[index2]) {
                result[resultIndex++] = arr1[index1++];
            } else {
                result[resultIndex++] = arr2[index2++];
            }
        }
        // 将剩余的元素添加到结果数组中
        while (index1 < arr1.length) {
            result[resultIndex++] = arr1[index1++];
        }
        while (index2 < arr2.length) {
            result[resultIndex++] = arr2[index2++];
        }
        return result;
    }

    //6: 二分查找 (Binary Search)
    function binarySearch(uint[] memory arr,uint target) public pure returns (int){
        uint leftIndex = 0;
        uint rightIndex = arr.length -1;
        int temperature = -1;
        while (leftIndex <= rightIndex){
            uint mid = leftIndex + (rightIndex-leftIndex)/2;
            if(arr[mid] == target){
                return int(mid);//找到目标值，返回索引
            }else if(arr[mid] < target) {
                leftIndex = mid +1;//整左边界
            } else {
                rightIndex = mid -1 ;
            }
        }
        return temperature;
    }

    

}