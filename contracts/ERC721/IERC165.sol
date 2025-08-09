// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    //检查接口是否支持 IERC721 或 IERC165
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}