// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract BeggingContract {
    
    mapping(address => uint256) public donatePriceMap; //记录adderss捐赠金额
    address public owner; //合约发布者

    uint256 public donateStartTime;//捐赠开始时间
    uint256 public donateEndTime;//捐赠结束时间

    //记录捐赠金额前3名的地址和金额
    address[3] public topDonors;
    uint256[3] public topDonations;
    constructor() {
        owner = msg.sender; //设置合约发布者
        donateStartTime = block.timestamp;
        donateEndTime = block.timestamp + 30 days; // 30天后结束
    }

    event DonateEvent(address indexed donor, uint256 amount);


    function donate() public payable {
        //检查捐赠时间是否在规定范围内
        require(block.timestamp >= donateStartTime && block.timestamp <= donateEndTime, "Donation period is not active");

        require(msg.value > 0, "Donation must be greater than zero");
        donatePriceMap[msg.sender] += msg.value; //增加捐赠金额
        updateTopDonors(msg.sender, msg.value); //更新前三名捐赠者
        emit DonateEvent(msg.sender, msg.value); //触发捐赠事件
    }

    function withdraw() public {
        require(owner == msg.sender, "Only owner can withdraw"); //只有合约发布者可以提取
        uint256 balance = address(this).balance;//查询合约余额
        require(balance > 0, "balance is zero");
        payable(owner).transfer(balance); //将合约余额转给调用者
    }

    function getDonatedAmount(address donor) public view returns (uint256) {
        return donatePriceMap[donor]; //查询捐赠金额
    }


    //查询合约余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    //查询合约发布者
    function getOwner() external view returns (address) {
        return owner;
    }

    function updateTopDonors(address donor, uint256 amount) private {
        uint256 totalDonation = donatePriceMap[donor];
        // 检查是否能进入前三名
        if (totalDonation > topDonations[2]) {
            // 找到合适的位置
            if (totalDonation > topDonations[1]) {
                if (totalDonation > topDonations[0]) {
                    // 第一名
                    topDonations[2] = topDonations[1];
                    topDonors[2] = topDonors[1];
                    topDonations[1] = topDonations[0];
                    topDonors[1] = topDonors[0];
                    topDonations[0] = totalDonation;
                    topDonors[0] = donor;
                } else {
                    // 第二名
                    topDonations[2] = topDonations[1];
                    topDonors[2] = topDonors[1];
                    topDonations[1] = totalDonation;
                    topDonors[1] = donor;
                }
            } else {
                // 第三名
                topDonations[2] = totalDonation;
                topDonors[2] = donor;
            }
        }
    }

    function getTopDonors() public view returns (address[3] memory, uint256[3] memory) {
        return (topDonors, topDonations); //返回前三名捐赠者和对应金额
    }

    
}