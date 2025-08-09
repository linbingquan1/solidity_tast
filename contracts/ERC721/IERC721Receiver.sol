//SPDX-Li  cense-Identifier: MIT
pragma solidity ^0.8.0;
interface IERC721Receiver {
    //接收token时调用
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}