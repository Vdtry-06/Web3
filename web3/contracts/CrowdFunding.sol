// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner; // địa chỉ người tạo chiến dịch
        string title; // tiêu đề chiến dịch
        string description; // mô tả chiến dịch
        uint256 target; // số tiền (bằng wei) cần huy động để đạt mục tiêu
        uint256 deadline; // thời gian kết thúc chiến dịch
        uint256 amountCollected; // Tổng số tiền đã huy động được từ các nhà tài trợ
        string image; // URL hình ảnh đại diện chiến dịch
        address[] donators; // mảng chứa địa chỉ của những người đã khuyên góp
        uint256[] donations; // mảng chứa số tiền tương ứng mà mỗi người đã khuyên góp
    }

    mapping(uint256 => Campaign) public campaigns; // lưu trữ danh sách các chiến dịch gây quỹ theo id

    uint256 public numberOfCampaigns = 0; // đếm số lượng chiến dịch đã tạo

    // Tạo chiến dịch
    function createCampaign(
        address _owner, 
        string memory _title, 
        string memory _description, 
        uint256 _target, 
        uint256 _deadline,
        string memory _image
        ) public returns (uint256) {
            // Lấy tham chiếu đến campaign sắp tạo
            Campaign storage campaign = campaigns[numberOfCampaigns];

            // Đảm bảo deadline nằm trong tương lai
            require(campaign.deadline > block.timestamp, "The deadline should be a date in the future.");

            // Gán các giá trị cho chiến dịch
            campaign.owner = _owner;
            campaign.title = _title;
            campaign.description = _description;
            campaign.target = _target;
            campaign.deadline = _deadline;
            campaign.image = _image;
            campaign.amountCollected = 0;
            campaign.image = _image;

            // Tăng số lượng chiến dịch
            numberOfCampaigns++;

            return numberOfCampaigns - 1;
        }

    // Huy động tiền cho chiến dịch
    function donateToCampaign(uint256 _id) public payable {
        // lấy số tiền người dung muốn khuyến góp
        uint256 amount = msg.value;

        // truy xuất chiến dịch cần nhận quyên góp
        Campaign storage campaign = campaigns[_id];

        // lưu thông tin người quyên góp
        campaign.donators.push(msg.sender); // lưu địa chỉ
        campaign.donations.push(amount); // lưu số tiền quyên góp

        // chuyển tiền cho chủ chiến dịch
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        // cập nhật số tiền đã thu được
        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // Lấy danh sách người khuyên góp và số tiền họ khuyên góp cho 1 chiến dịch cụ thể
    function getDonations(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() {}

}