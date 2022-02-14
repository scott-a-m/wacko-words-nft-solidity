// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// also need to import base64 functions

import { Base64 } from "./libraries/Base64.sol";

// inherit contract

contract WackoWordsNFT is ERC721URIStorage {
    

    // OpenZeppelin - helps us keep track of tokenIds

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // need to split svg to produce random word combos and random colour backgrounds

    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: Brush Script MT; font-size: 30px;  text-shadow: 0 20px 5px black;}</style><rect width='100%' height='100%' fill='";
    
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string svgCloser = "</text></svg>";

    // now add arrays of words to create final random string

    string[] firstWords = ["Airport", "Port", "Helipad", "Garage", "Station", "Stop", "Yard", "Dock", "Arena", "Ring", "Strip", "Runway", "Driveway", "Depot", "Terminal", "Lane", "Zone", "Airstrip", "Heliport", "Quay"];

    string[] secondWords = ["Skirt", "Shirt", "Blouse", "Sweater", "Trousers", "Pants", "Knickers", "Bra", "Shorts", "Jeans", "Tights", "Leggings", "Socks", "Hat", "Scarf", "Gloves", "T-shirt", "Poncho", "Coat", "Jacket"];

    string[] thirdWords = ["Spaghetti", "Pizza", "Ham", "Fish", "Steak", "Chicken", "Apple", "Olive","Pistachio", "Cheese", "Yoghurt", "Pineapple", "Burrito", "Chocolate", "Lamb", "Soup", "Potato", "Tomato", "Celery", "Caviar"];

    string[] colors = ["#66ffff", "#66ff66", "#3385ff", "#ff33cc", "#ff1a1a", "#ff9900", "#9933ff", "#800080", "#7575a3", "#bf4040", "#ff80bf"];

    uint totalNFTCount;
    
    mapping (address => uint) userNFTCount;

    event NewEpicNFTMinted(address sender, uint256 tokenId);


    // pass two arguments: NFT Token and symbol

     constructor() ERC721("Wacko Words NFT", "WW") {
        console.log("This is my NFT contract. Whoa!");
    }

    // create random function

    function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }
    
    // now create functions to choose words randomly
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOUR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    // function user hits to get their NFT

    function makeAnEpicNFT() public {

        // each user can only have on free mint

        require(userNFTCount[msg.sender] < 3, "Users can only mint up to three NFTS each.");
        require(totalNFTCount < 100, "Sold out! All 100 NFTS have been minted.");


        // get current tokenId
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        
        string memory color = pickRandomColor(newItemId);

        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, combinedWord, svgCloser));

        string memory json = Base64.encode(
            bytes(
                 string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "Wacko Words NFT", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
        );

        // create finalTokenURI

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------");
        console.log(string(abi.encodePacked(
            "https://nftpreview.0xdev.codes/?code=",
            finalTokenUri
        )));
        console.log("--------------------\n");


        // mint NFT for sender
        _safeMint(msg.sender, newItemId);
        // set NFTs data
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted for %s", newItemId, msg.sender);
        // increment token for next mint
        _tokenIds.increment();

        userNFTCount[msg.sender]++;
        totalNFTCount++;

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function getTotalNFTCount() public view returns (uint) {
        return totalNFTCount;
    }
}