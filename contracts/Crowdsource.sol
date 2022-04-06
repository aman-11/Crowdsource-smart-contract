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
        bool closed;
    }

    mapping(address => Campaign) public campaigns; //get campaign detaild by address

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
        camp.closed = false;
        campaigns[msg.sender] = camp;

        //emit event here
        return true;
    }

    //TODO 2. donate
}
