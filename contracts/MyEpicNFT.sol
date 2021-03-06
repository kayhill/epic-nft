//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.0;

//util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: black; font-family: serif; font-size: 24px; }</style><text id='base' fill='black' x='70%' y='80%' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Creepy", "Crawly", "Spooky", "Scary", "Bloody", "Dead", "Undead", "Witchy", "Murderous", "Haunted", "Mysterious", "Hungry", "Rotten", "Decayed", "Ghoulish"];
  string[] secondWords = [" Ghost", " Jack-O-Lantern", " Witch", " Zombie", " Monster", " Dracula", " Frankenstein", " Skeleton", " Pumpkin", " Clown", " Mad-Scientist", " Vampire", " Vampire-Slayer", " Ghoul", " Changling"];
  string[] thirdWords = [" Wart", " Tomb", " Stew", " Cat", " Bones", " Poison", " Cat", " Bones", " Rat", " Voodoo-doll", " Gravestone", " Cauldron", " Candy", " Tricks", " Treat"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("HalloweenNFT", "HLWN") {
    console.log("A Halloween themed NFT contract?! Spooky!");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
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

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

 function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    require(newItemId <= 50, "No more NFTs left to mint in this collection :(");

    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text><g id='layer1' transform='translate(-218.47 -468.09)'><path id='path2996' d='m357.87 541.9c5.5793-1.1736 10.757-3.8718 16.32-5.12 9.8766-2.216 19.97-3.6644 30.08-4.16 8.1032-0.39726 16.368-0.64624 24.32 0.96 9.2216 1.8626 18.35 5.0886 26.423 9.92 8.9352 5.3477 16.449 12.921 23.497 20.587 4.2162 4.5859 8.0258 9.6181 11.093 15.04 4.7407 8.3792 9.4081 17.188 11.093 26.667 1.9124 10.757 0.85712 22.054-1.3866 32.747-2.3744 11.315-6.104 22.747-12.587 32.32-6.569 9.7005-15.521 18.159-25.676 24-7.3798 4.2449-16.217 5.2209-24.457 7.36-11.098 2.8808-22.3 5.4202-33.6 7.36-12.714 2.1824-25.502 4.6145-38.4 4.8-15.643 0.22495-31.31-1.7789-46.72-4.48-11.824-2.0725-24.176-3.5257-34.88-8.96-16.623-8.4396-32.145-20.509-43.2-35.52-7.3764-10.016-12.264-22.254-14.08-34.56-2.1579-14.627-0.95013-30.286 4.16-44.16 4.0985-11.127 11.826-20.965 20.434-29.12 8.045-7.6218 17.79-13.814 28.206-17.6 11.54-4.195 24.202-4.9328 36.48-5.12 6.8666-0.10471 13.803 0.63602 20.48 2.24 3.2169 0.77273 6.0818 2.6734 9.28 3.52 3.3397 0.88404 6.7861 1.5234 10.24 1.6 0.96567 0.0214 1.9348-0.12116 2.88-0.32z' transform='matrix(.8 0 0 .8 72.639 119)' stroke='#6b1512' stroke-width='2.56' fill='#ec4c29'/><path id='path2998' d='m316.44 547.14s11.823-0.25181 17.664 0.512c4.4331 0.57973 8.7612 1.8297 13.056 3.072 2.5146 0.72737 4.8077 2.4766 7.424 2.56 3.5382 0.11272 6.8072-1.9511 10.24-2.816 4.0748-1.0267 8.169-1.9842 12.288-2.816 3.3966-0.68592 10.24-1.792 10.24-1.792s-3.1766 6.5837-5.376 9.472c-2.1934 2.8804-4.6162 5.7512-7.68 7.68-4.1339 2.6025-8.9769 4.2574-13.824 4.864-5.6958 0.71284-11.592-0.1085-17.152-1.536-5.1444-1.3208-10.118-3.5379-14.592-6.4-3.3609-2.15-6.3203-4.9444-8.96-7.936-1.2998-1.4731-3.328-4.864-3.328-4.864z' stroke='#5b1118' stroke-width='2.048' fill='none'/> <path id='path3000' d='m344.09 549.95c-1.024-2.816-2.862-10.831-3.328-16.384-0.64972-7.7423-1.7486-15.945 0.768-23.296 1.9793-5.7813 6.4674-10.491 10.752-14.848 4.1882-4.259 14.336-10.752 14.336-10.752s2.0667 6.7266 3.84 9.728c1.634 2.7656 6.144 7.424 6.144 7.424s-7.3305 5.6222-10.496 8.96c-3.4764 3.6657-7.2249 7.3889-9.216 12.032-2.5877 6.0342-3.7083 12.921-3.072 19.456 0.36103 3.7079 3.84 10.496 3.84 10.496s-3.4354 0.27337-5.12 0c-2.93-0.47547-8.448-2.816-8.448-2.816z' stroke='#662916' stroke-width='2.048' fill='#732016'/> <path id='path3002' stroke-linejoin='round' d='m367.13 484.93s5.3923 2.6722 6.9486 5.0834c1.9928 3.0875 2.2674 10.789 2.2674 10.789s-5.4954-4.6035-7.168-7.68c-1.3444-2.4729-2.048-8.192-2.048-8.192z' stroke='#662916' stroke-linecap='round' stroke-width='2.048' fill='#c95b4e' /><path id='path3004' d='m312.6 553.28s-10.368 15.862-14.592 24.32c-3.9504 7.9107-7.5785 16.067-9.984 24.576-3.1066 10.989-5.5392 22.373-5.632 33.792-0.0702 8.6285 2.1286 17.143 3.84 25.6 0.75122 3.7122 2.816 11.008 2.816 11.008' stroke='#5b1118' stroke-width='2.048' fill='none' /><path id='path3006' d='m338.57 565.39s-2.9407 9.7778-3.9497 14.775c-3.086 15.284-5.3951 30.776-6.4 46.336-0.66549 10.304-0.17648 20.659 0.256 30.976 0.63462 15.139 3.584 25.856 3.584 25.856' stroke='#5b1118' stroke-width='2.048' fill='none' /><path id='path3008' d='m362.19 567.73s-1.3135 22.275-1.4629 33.426c-0.20233 15.105 0.14071 30.219 0.768 45.312 0.53625 12.902 2.56 38.656 2.56 38.656' stroke='#5b1118' stroke-width='2.048' fill='none' /><path id='path3010' d='m393.75 551.49s5.5939 16.939 7.68 25.6c3.8799 16.109 7.5801 32.384 8.96 48.896 0.98075 11.736 0.50915 23.595-0.512 35.328-0.60697 6.9741-3.328 20.736-3.328 20.736' stroke='#5b1118' stroke-width='2.048' fill='none' /><path id='path3012' d='m420.89 552.51s17.611 27.102 22.784 42.24c3.5518 10.394 5.5213 21.528 5.376 32.512-0.1253 9.4716-2.9997 18.735-5.376 27.904-1.3742 5.3028-5.12 15.616-5.12 15.616' stroke='#5b1118' stroke-width='2.048' fill='none'/> <path id='path3014' d='m295.41 635.31s-0.64676-15.524 0.54857-23.15c1.2126-7.7358 2.9414-15.635 6.656-22.528 2.3843-4.4244 5.2074-9.3234 9.728-11.52 4.3776-2.1271 9.9984-2.1203 14.592-0.512 5.1978 1.8198 9.4415 6.202 12.544 10.752 3.512 5.1506 5.1746 11.506 6.144 17.664 1.1813 7.5042-0.512 22.784-0.512 22.784s-13.767-9.2154-21.65-9.5817c-3.7892-0.17608-7.4147 1.8867-10.789 3.6206-6.3135 3.2446-17.262 12.471-17.262 12.471z' stroke='#000' stroke-width='.768' fill='#ebc48e'/><path id='path3016' d='m306.71 627.08s-0.28994-6.7848-0.0731-10.167c0.34707-5.4144 0.4752-10.982 2.1943-16.128 2.1062-6.3048 5.1306-12.607 9.728-17.408 2.1995-2.2969 4.9415-5.1434 8.1189-5.0103 4.9987 0.20949 9.0823 4.9093 12.069 8.9234 3.7424 5.0305 5.3526 11.513 6.3634 17.701 1.2934 7.9182-0.512 24.064-0.512 24.064s-10.559-7.7294-16.786-8.643c-4.1509-0.60908-8.3961 0.96887-12.373 2.304-3.0838 1.0352-8.7284 4.3642-8.7284 4.3642z' stroke='#a71d3e' stroke-width='.768' fill='#551a1d'/><path id='path3018' d='m377.81 631.36s-1.0781-19.695 1.0971-29.184c1.5198-6.6296 4.0319-13.307 8.192-18.688 3.4562-4.4705 7.9036-8.859 13.312-10.496 4.0968-1.24 8.8588-0.64575 12.8 1.024 5.2332 2.2171 9.8364 6.4144 12.8 11.264 3.6262 5.9337 4.3509 13.313 5.12 20.224 0.7175 6.4478-0.512 19.456-0.512 19.456s-11.575-6.763-18.03-8.0457c-5.239-1.0411-10.973-1.314-16.018 0.43885-7.3722 2.5611-18.761 14.007-18.761 14.007z' stroke='#000' stroke-width='.768' fill='#ebc48e'/><path id='path3020' d='m388.93 621.74s0.0701-12.29 1.2434-18.286c1.1884-6.0721 2.7349-12.261 5.8149-17.627 2.8417-4.9512 5.7551-11.641 11.337-12.837 4.8546-1.0402 9.953 2.741 13.568 6.144 5.0586 4.7618 8.0176 11.699 9.728 18.432 1.7649 6.9478 0.62491 14.345 0.256 21.504-0.11493 2.2304-0.768 6.656-0.768 6.656s-9.05-6.1246-14.193-7.7252c-4.7508-1.4785-9.9274-2.3242-14.845-1.5639-4.3645 0.67486-12.142 5.3029-12.142 5.3029z' stroke='#a71d3e' stroke-width='.768' fill='#551a1d'/><path id='path3022' d='m353.56 630.85 19.456-2.304 0.256 9.216-17.664 2.304z' stroke='#a71d3e' stroke-width='.768' fill='#551a1d'/><path id='path3024' d='m409.93 676.53s-19.3-3.1397-29.003-4.3199c-5.9443-0.72303-11.898-1.8201-17.885-1.6902-6.1799 0.13416-12.302 1.3569-18.369 2.5442-6.6424 1.3001-19.68 5.0027-19.68 5.0027s6.8695-13.302 12.028-18.574c5.943-6.0744 12.979-11.79 21.091-14.322 4.512-1.4084 9.5415-1.033 14.18-0.12219 5.3899 1.0585 10.609 3.3483 15.201 6.363 4.52 2.9676 8.0828 7.2174 11.696 11.24 3.9096 4.3515 10.74 13.879 10.74 13.879z' stroke='#a71d3e' stroke-width='.768' fill='#551a1d'/></g></svg>"));

     // base64 encode json metadata
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    //set the title of NFT as the generated word
                    combinedWord,
                    '", "description": "The highly regarded pumpkin patch collection", "image": "data:image/svg+xml;base64,',
                    //add data:image/svg+xml;base64 and then append base64
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    //prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getTotalMinted() public view returns (uint256)  {
    uint256 totalMinted = _tokenIds.current();
    return totalMinted;
    }
}
  