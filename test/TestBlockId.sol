pragma solidity ^ 0.4 .17;


import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BlockId.sol";



contract TestBlockId {
  string[256] idAttr = 'vitor viana';
  string[256] idAdress = 'rua de cima e tal e coiso';

  
  BlockId users = BlockId(DeployedAddresses.BlockId());

  // Testing the adopt() function
  function testIfEmptyUsers() public {

    uint returnCount = users.countItemList();
    uint expected = 0;

    Assert.equal(returnCount, expected, "Should add 1 item");
  }

  function testIfAdded() public {

    users.addInfo(idAttr, idAdress);
    uint returnCount = users.countItemList();
    uint expected = 1;


    Assert.equal(returnCount, expected, "Should add 1 item");
  }

  function testIfNotEmpty() public {

    uint returnCount = users.countItemList();
    uint expected = 0;


    Assert.notEqual(returnCount, expected, "shoulf be diff");
  }



  function testIdAttr() public 
  {

    string[256] n  = users.getIdAttr();


    Assert.equal(idAttr, n, "id attr should be the same!");
  }
  



}