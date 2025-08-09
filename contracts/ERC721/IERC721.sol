//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interfece IERC721 {
    //返回指定地址拥有的token数量
    function balanceOf(address owner) external view returns (uint256 balance);

    //返回tokenId的所有者
    function ownerOf(uint256 tokenId) external view returns (address owner);
    
    //安全转移token
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    //带数据的安全转移--但这个数据指的是什么？
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    //转移token
    function transferfrom(address from, address to, uint256 tokenId) external;
    
    //设置token授权
    function approve(address to, uint256 tokenId) external;

    //查询token授权
    function getApproved(uint256 tokenId) external view returns (address operator);

    //设置token授权
    function setApprovalForAll(address operator, bool approved) external;
    
    //查询token是否被授权给某人
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
}
