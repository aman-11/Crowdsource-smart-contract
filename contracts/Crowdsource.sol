//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract CrowdSource {
    address public manager;

    struct Donor {
        address payable donorAddress;
        address campaign;
        uint256 amount;
    }

    Donor[] donors;

    struct Campaign {
        address payable campaignOwner;
        string title;
        string desc;
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

    constructor(address _manager) {
        manager = _manager;
    }

    function createCampaign(
        string memory _title,
        string memory _desc,
        uint256 _goal
    ) public returns (bool) {
        Campaign memory camp;
        camp.campaignOwner = payable(msg.sender);
        camp.title = _title;
        camp.desc = _desc;
        camp.goal = _goal;
        camp.endDate = block.timestamp + (3600 * 7);
        camp.closed = false;
        campaigns.push(camp);

        emit CampaignCreated(camp.campaignOwner, _title, _goal, camp.endDate);
        return true;
    }

    //TODO 2. donate
}
