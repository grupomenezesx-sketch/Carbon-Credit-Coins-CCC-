// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Carbon Credit Coins (CCC)
Institutional ERC20 Token with Transparency Layer
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarbonCreditCoins is ERC20, Ownable {

    // =========================
    // TOKEN CONFIG
    // =========================

    uint256 public constant MAX_SUPPLY = 20000000000 * 10**18;

    // =========================
    // METADATA
    // =========================

    string public imageURI;

    string public projectInfo =
        "Carbon Credit Coins (CCC) is a digital asset designed to represent environmental value through tokenization of carbon-related assets, supported by documentation, audits, and transparency mechanisms.";

    // =========================
    // RESERVE
    // =========================

    address public reserveWallet;

    // =========================
    // CERTIFICATES (IPFS / LINKS)
    // =========================

    struct Certificate {
        string name;
        string link;
        uint256 timestamp;
        string description;
    }

    Certificate[] public certificates;

    // =========================
    // EVENTS
    // =========================

    event CertificateAdded(
        uint256 indexed id,
        string name,
        string link,
        string description
    );

    event ReserveWalletUpdated(address newReserveWallet);

    // =========================
    // CONSTRUCTOR
    // =========================

    constructor(
        address masterWallet,
        string memory _imageURI,
        address _reserveWallet
    )
        ERC20("Carbon Credit Coins", "CCC")
        Ownable(masterWallet)
    {
        require(masterWallet != address(0), "Invalid owner");
        require(_reserveWallet != address(0), "Invalid reserve");

        imageURI = _imageURI;
        reserveWallet = _reserveWallet;

        _mint(masterWallet, MAX_SUPPLY);

        // =========================
        // INITIAL DOCUMENTS
        // =========================

        certificates.push(Certificate(
            "Project Documentation",
            "https://documentccc.digital/",
            block.timestamp,
            "Environmental and asset documentation"
        ));

        certificates.push(Certificate(
            "Audits and Certifications",
            "https://documentccc.online/",
            block.timestamp,
            "Audit reports and certifications"
        ));

        certificates.push(Certificate(
            "Whitepaper CCC",
            "https://whitepaperccc.online/",
            block.timestamp,
            "Official project whitepaper"
        ));
    }

    // =========================
    // ADMIN FUNCTIONS
    // =========================

    function setReserveWallet(address _wallet) external onlyOwner {
        require(_wallet != address(0), "Invalid address");
        reserveWallet = _wallet;
        emit ReserveWalletUpdated(_wallet);
    }

    function setImageURI(string memory _uri) external onlyOwner {
        imageURI = _uri;
    }

    function addCertificate(
        string memory _name,
        string memory _link,
        string memory _desc
    ) external onlyOwner {
        certificates.push(
            Certificate(_name, _link, block.timestamp, _desc)
        );

        emit CertificateAdded(
            certificates.length - 1,
            _name,
            _link,
            _desc
        );
    }

    // =========================
    // VIEW FUNCTIONS
    // =========================

    function getCertificatesCount() external view returns (uint256) {
        return certificates.length;
    }

    function getCertificate(uint256 index)
        external
        view
        returns (
            string memory name,
            string memory link,
            uint256 timestamp,
            string memory description
        )
    {
        Certificate memory c = certificates[index];
        return (c.name, c.link, c.timestamp, c.description);
    }
}
