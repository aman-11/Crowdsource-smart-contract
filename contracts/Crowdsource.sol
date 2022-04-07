//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract CrowdSource {
    address public manager;
    uint256 public campCount = 1;

    struct Donor {
        address payable donorAddress;
        address campaign;
        uint256 amount;
    }

    Donor[] donors;

    struct Campaign {
        address payable campaignOwner;
        string title;
        uint256 campId;
        uint256 goal;
        uint256 raised;
        uint256 endDate;
        bool closed;
    }

    Campaign[] campaigns;

    event CampaignCreated(
        address campOwner,
        string title,
        uint256 goal,
        uint256 endDate
    );

    event Donated(
        address indexed dnonor,
        uint256 campId,
        address indexed campaign,
        uint256 amount
    );

    constructor(address _manager) {
        manager = _manager;
    }

    bool isDestroyed = false;
    modifier isNotDestroyed() {
        require(isDestroyed != true);
        _;
    }

    modifier managerOnly() {
        require(
            msg.sender == manager,
            "You need to be manager to access this."
        );
        _;
    }

    function createCampaign(string memory _title, uint256 _goal)
        public
        isNotDestroyed
        returns (bool)
    {
        Campaign memory camp;
        camp.campaignOwner = payable(msg.sender);
        camp.title = _title;
        camp.campId = campCount;
        camp.goal = _goal * 10**18;
        camp.endDate = block.timestamp + (3600 * 7);
        camp.closed = false;
        campaigns.push(camp);

        campCount++;
        emit CampaignCreated(camp.campaignOwner, _title, _goal, camp.endDate);
        return true;
    }

    function getCampaignList() public view returns (Campaign[] memory) {
        return campaigns;
    }

    function getCampaignById(uint256 _campId)
        public
        view
        returns (Campaign memory)
    {
        return campaigns[_campId - 1];
    }

    function Donate(uint256 _campId)
        public
        payable
        isNotDestroyed
        returns (bool)
    {
        require(msg.value < msg.sender.balance, "Not enough balance to send");
        require(msg.value > 0, "Amount should be greater than 0");
        require(campaigns[_campId - 1].closed != true, "Campaign is closed.");

        campaigns[_campId - 1].campaignOwner.transfer(msg.value);
        campaigns[_campId - 1].raised += msg.value;

        if (campaigns[_campId - 1].raised == campaigns[_campId - 1].goal) {
            campaigns[_campId - 1].closed = true;
        }

        emit Donated(
            msg.sender,
            _campId,
            campaigns[_campId - 1].campaignOwner,
            msg.value
        );
        return true;
    }

    function getDonors() public view returns (Donor[] memory) {
        return donors;
    }

    function destroy() public managerOnly isNotDestroyed {
        isDestroyed = true;
    }

    fallback() external payable {
        payable(msg.sender).transfer(msg.value);
    }
}
