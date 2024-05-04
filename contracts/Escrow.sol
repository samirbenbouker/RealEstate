// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.24;

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _id) external;
}

contract Escrow {
    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

    modifier onlyBuyer(uint256 _nftId) {
        require(msg.sender == buyer[_nftId], "Only buyer can call this method");
        _;
    }

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this method");
        _;
    }

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice; // nftId => price
    mapping(uint256 => uint256) public escrowAmount; // nftId => escrow amount
    mapping(uint256 => address) public buyer; // nftId => buyer address
    mapping(uint256 => bool) public inspectionPassed;
    mapping(uint256 => mapping(address => bool)) public approval;

    constructor(
        address _nftAddress,
        address payable _seller,
        address _inspector,
        address _lender
    ) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }

    function list(
        uint256 _nftId,
        address _buyer,
        uint256 _purchasePrice,
        uint256 _escrowAmount
    ) public payable onlySeller {
        // Transfer NFT from seller to this contract
        // Who call that function will be a nftAddress
        // we will pass:
        //      - msg.sender will be the seller
        //      - address(this) reference address from this contract
        //      - _nftId like 1,2,3,...
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftId);

        isListed[_nftId] = true;
        purchasePrice[_nftId] = _purchasePrice;
        escrowAmount[_nftId] = _escrowAmount;
        buyer[_nftId] = _buyer;
    }

    // Put under contract (only buyer - payable scrow)
    function depositeEarnest(uint256 _nftId) public payable onlyBuyer(_nftId) {
        require(msg.value >= escrowAmount[_nftId]);
    }

    // updates inspection status (only insepctor)
    function updateInspectionStatus(
        uint256 _nftId,
        bool _passed
    ) public onlyInspector {
        inspectionPassed[_nftId] = _passed;
    }

    // approve sale
    function approveSale(uint256 _nftId) public {
        approval[_nftId][msg.sender] = true;
    }

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Finalize Sale
    // -> Require inspection status (add more items here, like appraisal)
    // -> Require sale to be authorized
    // -> Require funds to be correct amount
    // -> Transfer NFT to buyer
    // -> Transfer Funds to seller
    function finalizeSale(uint256 _nftId) public {
        require(inspectionPassed[_nftId], "Inspection not passed");
        require(approval[_nftId][buyer[_nftId]], "Buyer not approved");
        require(approval[_nftId][seller], "Seller not approved");
        require(approval[_nftId][lender], "Lender not approved");
        require(
            getBalance() >= purchasePrice[_nftId],
            "Balance is less than purchase price"
        );

        isListed[_nftId] = false;

        (bool success, ) = payable(seller).call{value: address(this).balance}(
            ""
        );
        require(success);

        IERC721(nftAddress).transferFrom(address(this), buyer[_nftId], _nftId);
    }

    // Cancel sale (handle earnest deposit)
    // -> if inspection status is not approved, then refund, otherwise send to seller
    function cancelSale(uint256 _nftId) public {
        if (inspectionPassed[_nftId] == false) {
            payable(buyer[_nftId]).transfer(getBalance());
        } else {
            payable(seller).transfer(getBalance());
        }
    }
}
