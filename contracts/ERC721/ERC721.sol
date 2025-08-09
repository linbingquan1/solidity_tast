// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";




// ERC721合约实现
contract ERC721 is Context, IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // Token名称
    string private _name;
    // Token符号
    string private _symbol;
    // 记录NFT-tokenId 持有人
    mapping(uint256 => address) private _owners;
    // 记录NFT-tokenId 对应的uri
    mapping(uint256 => string) private _toknURIs;


    // 记录持有人的NFT-tokenId数量
    mapping(address => uint256) private _balances;
    // 授权NFT-tokenId 
    mapping(uint256 => address) private _tokenApprovals;
    // 授权的记录
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    
    /**
     * 构造函数，初始化token名称和符号
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    
    //返回token名称
    function name() public view virtual returns (string memory) {
        return _name;
    }

    //返回token符号
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
    // 返回tokenURI，默认实现为tokenId的字符串表示
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        // 这里可以返回token的元数据URI
        // 实际实现中可能需要根据tokenId生成URI
        require(_exists(tokenId), "ERC721: URI query for nonexistent token");
        string memory baseURI = _toknURIs[tokenId];
        if(bytes(baseURI).length > 0){
            return string(abi.encodePacked("", tokenId));
        }
        return baseURI;
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }


    //检查接口是否支持 IERC721 或 IERC165---但业务并不进行检查
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IERC165).interfaceId ;
    }

    // 查询指定tokenId的所有者
    function ownerOf(uint256 tokenId) public view returns (address owner) {
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return _owners[tokenId];
    }

    // 查询地址拥有的代币数量
    function balanceOf(address owner) public view returns (uint256 balance) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(from != address(0), "ERC721: transfer from the zero address");
        require(to != address(0), "ERC721: transfer to the zero address");
        require(_owners[tokenId] == from, "ERC721: transfer of token that is not own");
        require(msg.sender == from || _tokenApprovals[tokenId] == msg.sender || _operatorApprovals[from][msg.sender], "ERC721: caller is not owner nor approved");

        // 更新持有者和数量 
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        // 清除token的清除授权
        delete _tokenApprovals[tokenId];

        emit Transfer(from, to, tokenId);
    }
    // 安全转移token，检查接收者是否实现了IERC721Receiver接口
    function safeTransferFrom(address from, address to, uint256 tokenId) external {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from,address to,uint256 tokenId, bytes memory _data) public virtual {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

   function _safeTransfer(address from,address to,uint256 tokenId,bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        // 清除授权
        _approve(address(0), tokenId);

        // 更新余额
        _balances[from] -= 1;
        _balances[to] += 1;

        // 转移所有权
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    //
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
    }

    //检查调用者是否有权操作token
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner ||getApproved(tokenId) == spender ||isApprovedForAll(owner, spender));
    }

    function getApproved(uint256 tokenId) public view virtual returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
        return _tokenApprovals[tokenId];
    }


    //铸造新的token
    function _mint(address to, uint256 tokenId) public  virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        // 更新状态
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    function _mintURI(address to, uint256 tokenId,string memory tokenURI) public virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        // 更新状态
        _balances[to] += 1;
        _owners[tokenId] = to;
        _toknURIs[tokenId] = tokenURI;
        emit Transfer(address(0), to, tokenId);
    }

    // 安全铸造新的token，检查接收者是否实现了IERC721Receiver接口
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    /**
     * @dev 带数据的安全铸造
     */
    function _safeMint(address to,uint256 tokenId,bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }


    // 授权tokenId给指定地址
    function setApprovalForAll(address operator, bool approved) external {
        //不允许自己授权给自己
        require(operator != msg.sender, "ERC721: approve to caller");
        // 更新授权记录
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // 查询是否授权tokenId给指定地址
    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        // if (to.isContract()) {
        //     try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
        //         return retval == IERC721Receiver.onERC721Received.selector;
        //     } catch (bytes memory reason) {
        //         if (reason.length == 0) {
        //             revert("ERC721: transfer to non ERC721Receiver implementer");
        //         } else {
        //             assembly {
        //                 revert(add(32, reason), mload(reason))
        //             }
        //         }
        //     }
        // } else {
        //     return true;
        // }
        return true;
    }
   

}