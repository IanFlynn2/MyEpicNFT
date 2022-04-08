// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { Base64 } from "./libraries/Base64.sol";

//Use their/they insted of gender for pronoun in madlib 
//URI Storage is ERC721 token with some added extensions 
contract MyEpicNFT is ERC721URIStorage, Ownable{
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
     using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    //SVG code 
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;        
    string species;
    string gender;
    string sexuality;
    string god;
    string caste;
    string weapon;
    string hobby;
  }

  // I create 7 arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Human", "Elf", "Dwarf", "Gnome", "Hobbit", "Goblin", "Orc", "Giant", "Undead","Lycan","Ent", "Nymph", "Dragonkin","Fae", "Vampire", "Catfolk"];
  
  string[] secondWords = ["He/Him", "She/Her", "They/Them"];
  
  string[] thirdWords = ["Straight", "Gay", "Bisexual", "Asexual"];
  
  string[] fourthWords = ["Xyto!chit", "Sto'chresta", "Artulachan", "Jedoh","Ya'ast Arisen","The Blind One","Grendarc","Holy Sentcha","Ezeriel","Saint Oshewa","The Unknowable","Drosk"];
  
  string[] fifthWords = ["Slave", "Peasant", "Artisan", "Merchant", "Clergy","Soldier","Knight","Bureaucrat","Lord","Monarch"];

  string[] sixthWords = ["Blade", "Bow", "Blunt", "Fist", "Magic","Poison","Flame","Cunning","Influence","Holy Relic"];

  string[] seventhWords = ["Drink", "Dice", "Cards", "Brothel", "Romance","Sport","Hunt","Prayer","Duel","Song","Dance","Brush","Rhyme","Theater","Letter","Quill"];

  string[] caste_Lookup = ["a wretched slave","a lowly peasant","an inspired artisan","a crafty merchant","a devout clergy","an obedient soldier","a valiant commander","a fastidious bureaucrat","a noble Lord","a Holy Monarch"];

  string [] romance_Lookup = ["is attracted to the other.","is drawn to the self.","feels desire for all.","feels desire for all."];

  string [] god_Lookup = ["lives in service of Xyto!chit.","will stamp out all enemies of Sto'chresta.","believes in the Truth of Artulachan.","will die when Jedoh commands it.","will sacrifice everything to bring back Ya'ast.","follows the signs of The Blind One.","is devoted to the blood of Grendarc.","worships at the altar of Holy Sentcha.","is an eternal slave to Ezeriel.","has accepted Saint Oshewa as the One True God.","prays for the sweet release that only The Unknowable can provide.","wishes to ascend to the Heavenly Throne beside Drosk."];

  string [] hobby_Lookup = ["drink fills the void of time.","dice provides the thrill of life.","cards whittle the days away.","the brothel silences the inner voice.","romance provides escape.","sport distracts from the harsh reality of life.","the hunt is where stillness is found.","prayer drowns out the urges inside.","duel provides the rush that life lacks.","song fills the heart and mind.","dance is the only escape.","the brush helps channel inner rage.","rhyme provides humble amusement.","the theater calls out.","the letter provides some solace.","the quill is a familiar companion."]; 

  string firstPart = "Born";
  string species;
    string  gender;
    string  sexuality;
    string  god;
    string  caste;
    string  weapon;
    string hobby;


  //Magical Event 
  event NewEpicNFTMinted(address sender, uint256 tokenId);

    //call contract collection
    constructor() ERC721("NPC Lore", "NPC"){
        console.log("This is the NPC contract, Amazing!");
    }

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

  function pickRandomFourthWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FOURTH_WORD", Strings.toString(tokenId))));
    rand = rand % fourthWords.length;
    return fourthWords[rand];
  }

  function pickRandomFifthWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("Fifth_WORD", Strings.toString(tokenId))));
    rand = rand % fifthWords.length;
    return fifthWords[rand];
  }

  function pickRandomSixthWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("Sixth_WORD", Strings.toString(tokenId))));
    rand = rand % sixthWords.length;
    return sixthWords[rand];
  }

  function pickRandomSeventhWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("Seventh_WORD", Strings.toString(tokenId))));
    rand = rand % seventhWords.length;
    return seventhWords[rand];
  }

    




  //just randomizer function
  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  
     // A function our user will hit to get their NFT.
  function makeAnEpicNFT() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

     // We go and randomly grab one word from each of the three arrays.
    

    










    string [17] memory parts;
    parts[0] = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    parts[1] = '</text><text x="10" y="20" class="base">';
    parts[2] = pickRandomFirstWord(newItemId);
    parts[3] = '</text><text x="10" y="40" class="base">';
    parts[4] = pickRandomSecondWord(newItemId);
    parts[5] = '</text><text x="10" y="60" class="base">'; 
    parts[6] = pickRandomThirdWord(newItemId);
    parts[7] = '</text><text x="10" y="80" class="base">';
    parts[8] = pickRandomFourthWord(newItemId);
    parts[9] = '</text><text x="10" y="100" class="base">';
    parts[10] = pickRandomFifthWord(newItemId);
    parts[11] = '</text><text x="10" y="120" class="base">';
    parts[12] = pickRandomSixthWord(newItemId);
    parts[13] = '</text><text x="10" y="140" class="base">';
    parts[14] = pickRandomSeventhWord(newItemId);
    parts[15] = '</text><text x="10" y="160" class="base">';
    parts[16] = '</text></svg>';

     species = parts[2];
     gender = parts[4];
     sexuality = parts[6];
     god = parts[8];
    caste = parts[10];
    weapon = parts[12];
    hobby = parts[14];





    // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6],parts[7],parts[8]));
        finalSvg = string(abi.encodePacked(finalSvg, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14],parts[15], parts[16]));
         

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
      bytes(
        string(
        
            
                abi.encodePacked(
                    '{"name": "Character #', Strings.toString(newItemId),
                    // We set the title of our NFT as the generated word.
                   
                    '", "description": "A highly acclaimed collection of NPC characters. Feel free to use your character however you want!", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),

                    '"}'
                )
                )
            )
    );
      

    
    // Just like before, we prepend data:application/json;base64, to our data.
    
    
    console.log("\n=======================");
    console.log(finalSvg);
    


    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
      console.log("\n--------------------");
      console.log(
    string(
        abi.encodePacked(
            "https://nftpreview.0xdev.codes/?code=",
            finalTokenUri
        )
    )
);
      console.log("--------------------\n");






      console.log("\n--------------------");
      console.log(finalTokenUri);
      console.log("--------------------\n");


    
    
    // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);
    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    //Emit Magical Event 
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }


}