// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 * Carbon Credit Coins (CCC)
 * Institutional ERC20 Token with Transparency Layer
 * 
 * Overview:
 * - Initial supply fully minted at deployment
 * - On-chain transparency via certificates registry
 * - Administrative control via Ownable
 * 
 * Links:
 * - Documentation: https://documentccc.digital/
 * - Audits: https://documentccc.online/
 * - Whitepaper: https://whitepaperccc.online/
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarbonCreditCoins is ERC20, Ownable {

    // =========================
    // TOKEN CONFIGURATION
    // =========================

    uint256 public constant MAX_SUPPLY = 20_000_000_000 * 10**18;

    // =========================
    // METADATA
    // =========================

    string public imageURI;

    string public projectInfo =
        "Carbon Credit Coins (CCC) is a digital asset designed to represent environmental value through tokenization of carbon-related assets, supported by documentation, audits, and transparency mechanisms.";

    // =========================
    // RESERVE WALLET
    // =========================

    address public reserveWallet;

    // =========================
    // CERTIFICATES STRUCTURE
    // =========================

    struct Certificate {
        string name;
        string link;
        uint256 timestamp;
        string description;
    }

    Certificate[] private certificates;

    // =========================
    // EVENTS
    // =========================

    event CertificateAdded(
        uint256 indexed id,
        string name,
        string link,
        string description,
        uint256 timestamp
    );

    event ReserveWalletUpdated(address indexed newReserveWallet);
    event ImageURIUpdated(string newURI);

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

        // Mint total supply to master wallet
        _mint(masterWallet, MAX_SUPPLY);

        // =========================
        // INITIAL CERTIFICATES
        // =========================

        _addCertificateInternal(
            "Project Documentation",
            "https://documentccc.digital/",
            "Environmental and asset documentation"
        );

        _addCertificateInternal(
            "Audits and Certifications",
            "https://documentccc.online/",
            "Audit reports and certifications"
        );

        _addCertificateInternal(
            "Whitepaper CCC",
            "https://whitepaperccc.online/",
            "Official project whitepaper"
        );
    }

    // =========================
    // INTERNAL FUNCTIONS
    // =========================

    function _addCertificateInternal(
        string memory _name,
        string memory _link,
        string memory _desc
    ) internal {
        certificates.push(
            Certificate({
                name: _name,
                link: _link,
                timestamp: block.timestamp,
                description: _desc
            })
        );

        emit CertificateAdded(
            certificates.length - 1,
            _name,
            _link,
            _desc,
            block.timestamp
        );
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
        emit ImageURIUpdated(_uri);
    }

    function addCertificate(
        string memory _name,
        string memory _link,
        string memory _desc
    ) external onlyOwner {
        _addCertificateInternal(_name, _link, _desc);
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
        require(index < certificates.length, "Invalid index");
        Certificate memory c = certificates[index];
        return (c.name, c.link, c.timestamp, c.description);
    }

    // 🔥 Melhorado: retorna vários certificados (bom pra frontend)
    function getCertificatesPaginated(uint256 start, uint256 limit)
        external
        view
        returns (Certificate[] memory)
    {
        require(start < certificates.length, "Start out of bounds");

        uint256 end = start + limit;
        if (end > certificates.length) {
            end = certificates.length;
        }

        Certificate[] memory result = new Certificate[](end - start);

        for (uint256 i = start; i < end; i++) {
            result[i - start] = certificates[i];
        }

        return result;
    }

    // 🔥 Getter rápido (front-end friendly)
    function getFullMetadata()
        external
        view
        returns (
            string memory _imageURI,
            string memory _projectInfo,
            address _reserveWallet,
            uint256 _totalSupply
        )
    {
        return (imageURI, projectInfo, reserveWallet, totalSupply());
    }
}
