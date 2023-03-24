// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PixelNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("PixelNFT", "PNFT") {}

    function mint(address to) public payable onlyOwner {
        require(msg.value >= 0.1 ether, "Insufficient payment for minting"); // Set the required minting fee
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist");
        string memory image = generateImage(tokenId);
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Pixel NFT #', toString(tokenId), '", "description": "A randomly generated 8x8 pixel image", "image": "data:image/svg+xml;base64,', image, '"}'))));
        return string(abi.encodePacked('data:application/json;base64,', json));
    }

    function generateImage(uint256 tokenId) private view returns (string memory) {
        uint8[64] memory colors = generateColors(tokenId);
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">';
        for (uint8 i = 0; i < 64; i++) {
            uint8 x = (i % 8) * 8;
            uint8 y = (i / 8) * 8;
            string memory color = string(abi.encodePacked("#", toString(colors[i])));
            svg = string(abi.encodePacked(svg, '<rect x="', toString(x), '" y="', toString(y), '" width="8" height="8" fill="', color, '" />'));
        }
        svg = string(abi.encodePacked(svg, "</svg>"));
        return Base64.encode(bytes(svg));
    }

    function generateColors(uint256 tokenId) private view returns (uint8[64] memory) {
        uint8[64] memory colors;
        for (uint8 i = 0; i < 64; i++) {
            bytes32 randomness = keccak256(abi.encodePacked(tokenId, i));
            colors[i] = uint8(uint256(randomness) % 256);
        }
        return colors;
    }

    function toString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        uint256 encodedLen = 4 * ((len + 2) / 3);

        bytes memory result = new bytes(encodedLen + 1);

        bytes memory table = TABLE;

        uint256 i = 0;
        uint256 j = 0;

        for (; i + 2 < len; i += 3) {
            result[j++] = table[uint8(data[i] >> 2)];
            result[j++] = table[uint8(((data[i] & 0x03) << 4) | (data[i + 1] >> 4))];
            result[j++] = table[uint8(((data[i + 1] & 0x0F) << 2) | (data[i + 2] >> 6))];
            result[j++] = table[uint8(data[i + 2] & 0x3F)];
        }

        if (i < len) {
            result[j++] = table[uint8(data[i] >> 2)];
            if (i + 1 < len) {
                result[j++] = table[uint8(((data[i] & 0x03) << 4) | (data[i + 1] >> 4))];
                result[j++] = table[uint8((data[i + 1] & 0x0F) << 2)];
                result[j++] = "=";
            } else {
                result[j++] = table[uint8((data[i] & 0x03) << 4)];
                result[j++] = "=";
                result[j++] = "=";
            }
        }

        bytes memory str = new bytes(encodedLen);
        for (i = 0; i < encodedLen; i++) {
            str[i] = result[i];
        }
        return string(str);
    }
}

