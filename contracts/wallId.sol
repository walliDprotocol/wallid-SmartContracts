pragma solidity ^0.4.0;
contract WalletId {

    struct IdtData 
    {
        bool isValid;   //used internally to check if is alredy setted
        mapping(bytes => UserData) idts;    
    }
    
    struct UserData {
        bool isValid;   //used internally to check if is alredy setted
        address userAddress;
        bytes identityId;
        bytes idt;
        bytes idtName;
        bytes pWalletId;
    }
    
  
    uint public newCount = 0;
    mapping(address => IdtData) public mData;
    
    
    // new function for smartcontract
    function addInfo(bytes identityId, bytes idt, bytes idtName, bytes pWalletId) public returns (address callerAdd)
    {
       
        //set entry for idt (card)
        UserData memory uData;   
        uData.isValid = true;
        uData.userAddress = msg.sender;
        uData.identityId = identityId;
        uData.idt = idt;
        uData.idtName = idtName;
        uData.pWalletId = pWalletId;
        
        
        IdtData storage data = mData[msg.sender];
        data.isValid = true;
        
        //settting data for user and for this card
        mData[msg.sender].isValid = true;
        mData[msg.sender].idts[idt] = uData;
        
        
        newCount++;
            
        return msg.sender;
    }
    
    function getIdtData(bytes idt) public view returns(bytes identityId,bytes pWalletId, bytes ridt ) {
        IdtData storage data = mData[msg.sender];
        UserData storage uData = data.idts[idt];
        
        return (uData.identityId, uData.pWalletId, uData.idt );
    }
    


}