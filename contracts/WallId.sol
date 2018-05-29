pragma solidity ^ 0.4 .17;

contract WallId {

    struct User {
        address userAddress;
        bytes idAttribute; //array de byte
        bytes addressAttributes; //array de byte
    }

    uint itemCount = 0;
    mapping(address => User) public users;

    function addInfo(bytes idAttr, bytes addAttr) public  returns(address callerAddr ){

        User memory myStruct;
        myStruct.userAddress = msg.sender;
        myStruct.idAttribute = idAttr;
        myStruct.addressAttributes = addAttr;
        // log0(itemnew);
        users[msg.sender] = myStruct;
        itemCount++;
        return msg.sender;
    }

    function getInfo() public view returns(address userAddress,bytes idAttribute, bytes addressAttributes) {
        return (users[msg.sender].userAddress, users[msg.sender].idAttribute, users[msg.sender].addressAttributes);
    }

    function getIdAttr() public view returns(bytes idAttribute) {
        return users[msg.sender].idAttribute;
    }

    function countItemList() public view returns(uint count) {
        return itemCount;
    }

}