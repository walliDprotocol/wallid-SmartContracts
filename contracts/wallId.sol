pragma solidity ^0.4.0;
contract WalletId {


//events
//https://ethereum.stackexchange.com/questions/15353/how-to-listen-for-contract-events-in-javascript-tests

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
        bytes pWalletAddress;
        bytes pName;
        bytes sdkey;
        bytes pUrl;
        uint opid;
    }
    
  
    uint public newCount = 0;
    mapping(address => IdtData) public mData;
    
    
    /*
        Event to request Payment Tokens
    */
    event RequestPayment(
        address  _wallId,
        bytes   idt,
        uint   opid
    );
    
    /*
        Event to request data from providers
    */
    event RequestVerifyId(
        address indexed _wallId,
        bytes  indexed idt,
        uint   opid,
        bytes   sdkey
    );
    
     /*
        Event to send data to browser!
    */
    event EventDataId(
        address indexed _wallId,
        bytes  indexed idt,
        uint   opid,
        bytes   identityId,
        bytes   veridyId
    );


    
    // new function for smartcontract
    function addInfo(bytes identityId, bytes idt, bytes idtName, bytes pWalletAddress, bytes pName, bytes pUrl, uint opid, bytes sdkey) public returns (address callerAdd)
    {
        
    
        newCount++;
       
        //set entry for idt (card)
        UserData memory uData;   
        uData.isValid = true;
        uData.userAddress = msg.sender;
        uData.identityId = identityId;
        uData.idt = idt;
        uData.opid = opid;
        uData.sdkey = sdkey;
        
        uData.idtName = idtName;
        uData.pWalletAddress = pWalletAddress;
        uData.pName = pName ;
        uData.pUrl = pUrl;
    
        IdtData storage data = mData[msg.sender];
        data.isValid = true;
        
        //settting data for user and for this card
        mData[msg.sender].isValid = true;
        mData[msg.sender].idts[idt] = uData;
        
            
        return msg.sender;
    }
    
    /*
    
    
    */
    function getIdtData(bytes idt,  bytes opid) public view  returns(bytes ridentityId,bytes rpWalletId, bytes ridt, bytes ropid) {
       IdtData storage data = mData[msg.sender];
        UserData storage uData = data.idts[idt];
        
        return (uData.identityId, uData.pWalletAddress, uData.idt, opid);
    }
    
     function getIdtDataVerified(bytes idt,  uint opid) public  returns(bool ret) {
        IdtData storage data = mData[msg.sender];
        UserData storage uData = data.idts[idt];
        
        /*
            emit event when request data uData.idt
         **/
        emit RequestPayment(uData.userAddress, idt, opid);
        
        return true;
    }
    
    function countItemList() public view returns(uint count) {
        return newCount;
    }
    
    /*
        RequestPayment -> acceptedToken
        After RequestPayment as emitted should be called acceptToken
    */
    function acceptedToken(address userAddress, bytes idt, uint opid , bytes sdkey ) public  returns(bool ret) 
    {
        emit RequestVerifyId(userAddress, idt, opid, sdkey);
        return true;
    }
    
    /*
        RequestVerifyId -> acceptedUserData
        After RequestPayment as emitted should be called acceptToken
    */
    function acceptedUserData(address userAddress, bytes idt, uint opid , bytes identityId, bytes verifyId ) public  returns(bool ret) {
        emit EventDataId(userAddress, idt, opid, identityId,verifyId );
        return true;
    }
    
  
   


}