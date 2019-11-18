pragma solidity >=0.4.22 <0.6.0;

/**
 *  Created Nov-19 
 *      by Vitor Viana - WalliD SA
 *
 *  Hybrid version of wallid 2.0 contract to fully support user data protection
 * 
 */
contract WalletIdHydrid 
{
    uint DriftPeriod = 9000;
    uint dataInsertions = 0;
    mapping(address => IdtData) _identities;
    
    struct  IdtData 
    {
        mapping(bytes1 => UserData)  idt_type;    
    }
    
    
    struct UserData {
        bytes32 [10] datablocks;
        bytes1 idt;
        bytes1 sid;
        uint opid;
        uint256 updateAt;
    }
    
    
   /**
    * params : 
    *    - idt -> type of identity (cc_pt, cc_tst)
    *    - idx -> data block idx
    *    - dBlock -> block of userdata
    *    - opid -> Operation id
    *    - sid  -> storeid
    */
  
   function addUserBlock(bytes1 idt, uint8 idx , bytes32 dBlock ,  uint opid, bytes1 sid ) public returns (uint8 code)
   {
       UserData memory  uData;
       uData.idt = idt;
       uData.sid = sid;
       uData.opid = opid;
       uData.datablocks[idx] = dBlock;
       uData.updateAt = now;
       
       //Initialize idt's list for WA
       IdtData storage iData = _identities[msg.sender];
       //add user information
       iData.idt_type[idt] = uData;
       
       //incr total datablocks
       dataInsertions = dataInsertions +1;
       
       return 1;
   }
   
   /**
    *   Params : 
    *       - idt -> type of identity (cc_pt)
    *   Out :
    *     - idt -> type of identity (cc_pt, cc_tst)
    *    - dBlock -> block of userdata
    *    - opid -> Operation id
    *    - sid  -> storeid
    * 
    * 
    *   https://medium.com/coinmonks/solidity-tutorial-returning-structs-from-public-functions-e78e48efb378
    * 
    **/
   function getUserBlock(bytes1 idt) public view returns (address, bytes32[10] memory, bytes1,  bytes1, uint)
   {
       //Testing out parameters
       /*
       bytes32[] memory arr = new bytes32[](10);
       address addr = msg.sender;
       bytes1  i = '1';
       bytes1  s = '1';
       uint8   o = 0;
       */
       
       //Getting all idt's for an wallet address
       IdtData  storage _idtDataTmp =  _identities[msg.sender];
       //Getting user idt_type data
       UserData storage uBlockData = _idtDataTmp.idt_type[idt];
    
       return (msg.sender, uBlockData.datablocks, uBlockData.idt,  uBlockData.sid, uBlockData.opid );
   }
   
   function decodeIdx (uint256 idxN, uint nounce) public view returns (uint) {
        uint ts = now * 1000;
        
        uint adj_ts = (ts - ts % DriftPeriod);
        
        uint idxOffset = adj_ts * (nounce - nounce % adj_ts);
        
        return idxN - idxOffset;
    }
   

    
}