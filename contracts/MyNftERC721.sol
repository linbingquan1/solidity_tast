// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
// import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/utils/Context.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// /**
//  * @dev ERC721 Non-Fungible Token Standard基本实现
//  */
// contract ERC721 is Context, IERC165, IERC721 {
//     using Address for address;
//     using Strings for uint256;

//     // Token名称
//     string private _name;
//     // Token符号
//     string private _symbol;

//     // 记录每个tokenId的所有者
//     mapping(uint256 => address) private _owners;
//     // 记录每个所有者拥有的token数量
//     mapping(address => uint256) private _balances;
//     // 记录每个tokenId的授权地址
//     mapping(uint256 => address) private _tokenApprovals;
//     // 记录每个地址对其他地址的批量授权
//     mapping(address => mapping(address => bool)) private _operatorApprovals;

//     /**
//      * @dev 构造函数，初始化token名称和符号
//      */
//     constructor(string memory name_, string memory symbol_) {
//         _name = name_;
//         _symbol = symbol_;
//     }

//     /**
//      * @dev 返回token名称
//      */
//     function name() public view virtual returns (string memory) {
//         return _name;
//     }

//     /**
//      * @dev 返回token符号
//      */
//     function symbol() public view virtual returns (string memory) {
//         return _symbol;
//     }

//     /**
//      * @dev 返回tokenURI，默认实现为tokenId的字符串表示
//      */
//     function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
//         require(_exists(tokenId), "ERC721: URI query for nonexistent token");

//         string memory baseURI = _baseURI();
//         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
//     }

//     /**
//      * @dev 返回基础URI，可在子类中重写
//      */
//     function _baseURI() internal view virtual returns (string memory) {
//         return "";
//     }

//     /**
//      * @dev 检查接口是否支持
//      */
//     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165) returns (bool) {
//         return
//             interfaceId == type(IERC721).interfaceId ||
//             interfaceId == type(IERC165).interfaceId;
//     }

//     /**
//      * @dev 返回指定tokenId的所有者
//      */
//     function ownerOf(uint256 tokenId) public view virtual returns (address) {
//         address owner = _owners[tokenId];
//         require(owner != address(0), "ERC721: owner query for nonexistent token");
//         return owner;
//     }

//     /**
//      * @dev 返回指定地址拥有的token数量
//      */
//     function balanceOf(address owner) public view virtual returns (uint256) {
//         require(owner != address(0), "ERC721: balance query for the zero address");
//         return _balances[owner];
//     }

//     /**
//      * @dev 转移token所有权
//      */
//     function transferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) public virtual override {
//         // 检查调用者是否有权转移
//         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

//         _transfer(from, to, tokenId);
//     }

//     /**
//      * @dev 安全转移token所有权，会检查接收地址是否实现了IERC721Receiver接口
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) public virtual override {
//         safeTransferFrom(from, to, tokenId, "");
//     }

//     /**
//      * @dev 带数据的安全转移
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes memory _data
//     ) public virtual override {
//         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
//         _safeTransfer(from, to, tokenId, _data);
//     }

//     /**
//      * @dev 设置token授权
//      */
//     function approve(address to, uint256 tokenId) public virtual override {
//         address owner = ownerOf(tokenId);
//         require(to != owner, "ERC721: approval to current owner");

//         require(
//             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
//             "ERC721: approve caller is not owner nor approved for all"
//         );

//         _tokenApprovals[tokenId] = to;
//         emit Approval(owner, to, tokenId);
//     }

//     /**
//      * @dev 获取token的授权地址
//      */
//     function getApproved(uint256 tokenId) public view virtual override returns (address) {
//         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
//         return _tokenApprovals[tokenId];
//     }

//     /**
//      * @dev 设置操作符授权
//      */
//     function setApprovalForAll(address operator, bool approved) public virtual override {
//         require(operator != _msgSender(), "ERC721: approve to caller");

//         _operatorApprovals[_msgSender()][operator] = approved;
//         emit ApprovalForAll(_msgSender(), operator, approved);
//     }

//     /**
//      * @dev 检查操作符是否被授权
//      */
//     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
//         return _operatorApprovals[owner][operator];
//     }

//     /**
//      * @dev 安全转移实现
//      */
//     function _safeTransfer(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes memory _data
//     ) internal virtual {
//         _transfer(from, to, tokenId);
//         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
//     }

//     /**
//      * @dev 转移token所有权核心实现
//      */
//     function _transfer(
//         address from,
//         address to,
//         uint256 tokenId
//     ) internal virtual {
//         require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
//         require(to != address(0), "ERC721: transfer to the zero address");

//         // 清除授权
//         _approve(address(0), tokenId);

//         // 更新余额
//         _balances[from] -= 1;
//         _balances[to] += 1;

//         // 转移所有权
//         _owners[tokenId] = to;

//         emit Transfer(from, to, tokenId);
//     }

//     /**
//      * @dev 铸造新token
//      */
//     function _mint(address to, uint256 tokenId) internal virtual {
//         require(to != address(0), "ERC721: mint to the zero address");
//         require(!_exists(tokenId), "ERC721: token already minted");

//         // 更新状态
//         _balances[to] += 1;
//         _owners[tokenId] = to;

//         emit Transfer(address(0), to, tokenId);
//     }

//     /**
//      * @dev 安全铸造新token
//      */
//     function _safeMint(address to, uint256 tokenId) internal virtual {
//         _safeMint(to, tokenId, "");
//     }

//     /**
//      * @dev 带数据的安全铸造
//      */
//     function _safeMint(
//         address to,
//         uint256 tokenId,
//         bytes memory _data
//     ) internal virtual {
//         _mint(to, tokenId);
//         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
//     }

//     /**
//      * @dev 销毁token
//      */
//     function _burn(uint256 tokenId) internal virtual {
//         address owner = ownerOf(tokenId);

//         // 清除授权
//         _approve(address(0), tokenId);

//         // 更新余额
//         _balances[owner] -= 1;

//         // 清除所有权记录
//         delete _owners[tokenId];

//         emit Transfer(owner, address(0), tokenId);
//     }

//     /**
//      * @dev 设置token授权
//      */
//     function _approve(address to, uint256 tokenId) internal virtual {
//         _tokenApprovals[tokenId] = to;
//     }

//     /**
//      * @dev 检查token是否存在
//      */
//     function _exists(uint256 tokenId) internal view virtual returns (bool) {
//         return _owners[tokenId] != address(0);
//     }

//     /**
//      * @dev 检查调用者是否有权操作token
//      */
//     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
//         address owner = ownerOf(tokenId);
//         return (
//             spender == owner ||
//             getApproved(tokenId) == spender ||
//             isApprovedForAll(owner, spender)
//         );
//     }

//     /**
//      * @dev 检查接收地址是否实现了ERC721Receiver接口
//      */
//     function _checkOnERC721Received(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes memory _data
//     ) private returns (bool) {
//         if (to.isContract()) {
//             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
//                 return retval == IERC721Receiver.onERC721Received.selector;
//             } catch (bytes memory reason) {
//                 if (reason.length == 0) {
//                     revert("ERC721: transfer to non ERC721Receiver implementer");
//                 } else {
//                     assembly {
//                         revert(add(32, reason), mload(reason))
//                     }
//                 }
//             }
//         } else {
//             return true;
//         }
//     }
// }

// /**
//  * @dev ERC721标准接口定义
//  */
// interface IERC721 is IERC165 {
//     /**
//      * @dev 当token所有权转移时触发
//      */
//     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

//     /**
//      * @dev 当token授权改变时触发
//      */
//     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

//     /**
//      * @dev 当操作符授权改变时触发
//      */
//     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

//     /**
//      * @dev 返回地址拥有的token数量
//      */
//     function balanceOf(address owner) external view returns (uint256 balance);

//     /**
//      * @dev 返回tokenId的所有者
//      */
//     function ownerOf(uint256 tokenId) external view returns (address owner);

//     /**
//      * @dev 安全转移token
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external;

//     /**
//      * @dev 带数据的安全转移
//      */
//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes calldata data
//     ) external;

//     /**
//      * @dev 转移token
//      */
//     function transferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) external;

//     /**
//      * @dev 设置token授权
//      */
//     function approve(address to, uint256 tokenId) external;

//     /**
//      * @dev 设置操作符授权
//      */
//     function setApprovalForAll(address operator, bool approved) external;

//     /**
//      * @dev 获取token的授权地址
//      */
//     function getApproved(uint256 tokenId) external view returns (address operator);

//     /**
//      * @dev 检查操作符是否被授权
//      */
//     function isApprovedForAll(address owner, address operator) external view returns (bool);
// }

// /**
//  * @dev ERC165接口定义
//  */
// interface IERC165 {
//     /**
//      * @dev 检查接口是否支持
//      */
//     function supportsInterface(bytes4 interfaceId) external view returns (bool);
// }

// /**
//  * @dev ERC721接收接口
//  */
// interface IERC721Receiver {
//     /**
//      * @dev 当接收ERC721 token时调用
//      */
//     function onERC721Received(
//         address operator,
//         address from,
//         uint256 tokenId,
//         bytes calldata data
//     ) external returns (bytes4);
// }