pragma solidity ^0.8.0;

contract Voting {
    
    mapping (address => uint) public voterMap; //存储候选人的得票数
    address public owner;//发布者
    mapping(address => bool) public voterExists;
    address[] public voterArr;

    constructor(){
        owner = msg.sender;
    }

    //1：创建一个名为Voting的合约，包含以下功能：
    function vote(address voter) public {
        //不能投票给自己
        require(msg.sender != voter," Cannot vote for oneself ");
        voterMap[voter] += 1;
        //如果候选人不在数组中，则将该地址存入数组
        if (!voterExists[voter]) {
            voterArr.push(voter);
            voterExists[voter] = true;
        }
    }

    function getVotes (address voter) public view returns (uint256){
        return voterMap[voter];
    }


    function resetVotes() public returns (uint total) {
        uint voterArrlength = voterArr.length;
        for (uint i = 0;i < voterArrlength; i++){
            voterMap[voterArr[i]] = 0;
            voterExists[voterArr[i]] = false;
        }
        return 1;
    }

    
}