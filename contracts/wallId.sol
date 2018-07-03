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
        bytes pUrl;
    }
    
  
    uint public newCount = 0;
    mapping(address => IdtData) public mData;
    
    
    /*
        Event to request Payment Tokens
    */
    event RequestPayment(
        address indexed _wallId,
        bytes  indexed idt,
        bytes32   opid
    );
    
     /*
        Event to request data from providers
    */
    event RequestVerifyId(
        address indexed _wallId,
        bytes  indexed idt,
        bytes32   opid,
        bytes32   sdkey
    );


    
    // new function for smartcontract
    function addInfo(bytes identityId, bytes idt, bytes idtName, bytes pWalletAddress, bytes pName, bytes pUrl) public returns (address callerAdd)
    {
        
    
        newCount++;
       
        //set entry for idt (card)
        UserData memory uData;   
        uData.isValid = true;
        uData.userAddress = msg.sender;
        uData.identityId = identityId;
        uData.idt = idt;
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
    function getIdtData(bytes idt,  bytes32 opid) public view returns(bytes identityId,bytes pWalletAddress, bytes ridt, bytes pName, bytes pUrl) {
        IdtData storage data = mData[msg.sender];
        UserData storage uData = data.idts[idt];
        
        /*
            emit event when request data
         **/
        emit RequestPayment(uData.userAddress, uData.idt, opid);
        
        return (uData.identityId, uData.pWalletAddress, uData.idt, uData.pName, uData.pUrl);
    }
    
    function countItemList() public view returns(uint count) {
        return newCount;
    }
    
    /*
        RequestPayment -> acceptedToken
        After RequestPayment as emitted should be called acceptToken
    */
    function acceptedToken(address tokenAdress ) public view returns(uint count) {
        return newCount;
    }
    
     /*
        RequestVerifyId -> acceptedUserData
        After RequestPayment as emitted should be called acceptToken
    */
    function acceptedUserData(address tokenAdress ) public view returns(uint count) {
        return newCount;
    }
    
    


}