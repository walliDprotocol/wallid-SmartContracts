pragma solidity >=0.4.25 <0.6.0;

/**
 *  Created Nov-19 
 *      by Vitor Viana - WalliD SA
 *
 *  Hybrid version of wallid 2.0 contract to fully support user data protection
 * 
 */
contract WalletIdHydrid 
{
    uint256 constant DriftPeriod = 180000;
    uint256  dataInsertions = 0;
    //user data mapping idxN -> idt -> data
    mapping(uint256 => IdtData)  _identities;
    string _texto;
  
    struct  IdtData 
    {
        mapping(bytes32 => UserData)  idt_type;    
    }
    
    struct UserData {
        uint256 updateAt;
        bytes32 idt;
        bytes32 sid;
        bytes [10] dBlocks;
    }
    
    /**
    * params : 
    *    - idt -> type of identity (cc_pt, cc_tst)
    *    - idx -> data block idx
    *    - dBlock -> block of userdata
    *    - opid -> Operation i
    * 
    * d
    *    - sid  -> storeid
    */
  
   function addUserBlock(uint256  uIdx, bytes32 idt, uint8 idx , bytes calldata dblock , bytes32 sid ) external returns (uint256 sucess, bytes32 code)
   {
       UserData memory  uData;
       uData.idt = idt;
       uData.sid = sid;
       uData.dBlocks[idx] = dblock;
       
       //Initialize idt's list for WA 
       IdtData storage iData = _identities[uIdx];
       //add user information
       iData.idt_type[idt] = uData;
       
       //incr total datablocks
       dataInsertions = dataInsertions + 1;
       
       return (1 , 'Data was sucessful updated' );
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
   function getUserBlock(uint256 uIdx, bytes32 idt, uint8 idx) external view returns (uint256 sucess, bytes memory uBlock, uint256 o_uIdx, bytes32 o_sid,  bytes32 o_idt)
   {
    
       //Getting all idt's for an wallet address
       IdtData  storage _idtDataTmp =  _identities[uIdx];
       //Getting user idt_type data
       UserData storage uBlockData = _idtDataTmp.idt_type[idt];
       
       //checking idx are in range
       if(idx > 9 && idx < 0)
       {
           return (0, bytes(''), uIdx, uBlockData.sid, uBlockData.idt);
       }
    
        return (1, uBlockData.dBlocks[idx],   uIdx, uBlockData.sid, uBlockData.idt);
   }
   
   
   function decodeIdx (uint256 idxN, uint nounce) public view returns (uint) {
        uint ts = now * 1000;
        
        uint adj_ts = (ts - ts % DriftPeriod);
        
        uint idxOffset = adj_ts * (nounce - nounce % adj_ts);
        
        return idxN - idxOffset;
    }
    
   
    function totalInsertions()  public view returns (uint s){
       
     return dataInsertions;
    }
    
    
}