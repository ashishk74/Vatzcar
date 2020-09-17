// "SPDX-License-Identifier: UNLICENSED"

pragma solidity 0.5.16;

/**
 * @title Asset
 * @dev Asset storage & transfer
 
 Ashish Kumar, [09.09.20 23:10]
Create a blockchain contract for storing and sharing data and other parameter of an asset.

Main features as follows :
1. Data stored & shared should be immutable.
2. Asset ownership should be transferable.
3. Trail of ownership should be visible.
4. Asset data should be visible for a limited period to third party on demand.
5. Owner of asset can delegate ownership to a 'temporary owner'
*/
contract Asset {

  struct AssetDetail {
    uint256 assetNo;  
    string ownerName;
    address ownerAddr;
    string otherDetails;
    uint16 yearOfManufacture;
    uint8 ownerNo;  // increases by 1 everytime asset is transfered to a new owner. 
  }
  
  mapping(uint => AssetDetail) assets;  // mapping asset no to asset details.
  //uint256[] assetnos;   // array of asset nos.
  mapping(uint256 => mapping(uint256 => address)) owneraddr; // mapping asset no to owner no to owner address
  AssetDetail[] listofOwners;     // aray of asset details.
  //listofOwners[assetNo].ownerNo => No of owners that this asset has had
  
  uint256 assetNo = 0;
  uint8 ownerNo = 1;    // Initialized with 1 to sound similar to 'first owner'
  
  function createAsset(string memory _name,
                        address _addr,
                        string memory _otherDetails,
                        uint16 _yearOfManufacture) 
                        public returns(uint256){
    
    assets[assetNo] = AssetDetail(assetNo, _name, _addr, _otherDetails, _yearOfManufacture, ownerNo);
    owneraddr[assetNo][ownerNo] = _addr;
    listofOwners.push(AssetDetail({
        assetNo : assetNo,
        ownerName : _name,
        ownerAddr : _addr,
        otherDetails : _otherDetails,
        yearOfManufacture : _yearOfManufacture,
        ownerNo : 1
    }));
    
    listofOwners[assetNo].ownerNo = 1;
    listofOwners[assetNo].ownerAddr = _addr;    
    //trail[assetNo][_addr] = now;
    
    //owners[ownerNo][assetNo] ;
    assetNo ++;
    
    return (assetNo-1);
    
  }
  function transferAsset(string memory _newname,
                        address _newaddr,
                        uint256 _assetNo) public returns(bool success){
    require(msg.sender == assets[_assetNo].ownerAddr, "Only Owner can run this function");
    
    assets[_assetNo].ownerName = _newname;
    assets[_assetNo].ownerAddr = _newaddr;                     
    assets[_assetNo].ownerNo++;                     
    owneraddr[_assetNo][assets[_assetNo].ownerNo] = _newaddr;
    listofOwners.push(AssetDetail({
        assetNo : _assetNo,
        ownerName : _newname,
        ownerAddr : _newaddr,
        otherDetails : assets[_assetNo].otherDetails,
            yearOfManufacture : assets[_assetNo].yearOfManufacture,
        ownerNo : assets[_assetNo].ownerNo
    }));
    listofOwners[assetNo].ownerNo ++;
    listofOwners[assetNo].ownerAddr = _newaddr;    
   
    //trail[_assetNo][_newaddr] = now;
    //owners[assets[_assetNo].ownerNo][_assetNo];
    
    return true;
  }
  
  function viewTrail(uint256 _assetNo) public view returns(address[] memory){
       address[] memory newlist = new address[](assets[_assetNo].ownerNo);
      for(uint i = 0; i < assets[_assetNo].ownerNo; i ++)
      {
      newlist[i] = owneraddr[_assetNo][i+1];
      //listofOwners.push(owneraddr[_assetNo][ownerNo]);
      }
  
    return (newlist);
  }
  
  function getAssetOwnerName(uint256 _assetNo) public view returns(string memory){
      
      return assets[_assetNo].ownerName;
  } 
  
  mapping(uint256 => address) thirdparty;
  mapping(uint256 => mapping(address => uint256)) timeallowed;
  function giveViewAccess(uint256 _assetNo, address _to, uint256 _timeinseconds) public {
      require(assets[_assetNo].ownerAddr == msg.sender || delegate[_assetNo][assets[_assetNo].ownerAddr] == msg.sender, " You are not owner/delegated owner of this asset thus cannot give view access to third party");
      thirdparty[_assetNo] = _to;
      timeallowed[_assetNo][_to] = (block.timestamp + _timeinseconds);
  } 
  
  function viewAssetDetail(uint256 _assetNo) public view returns(string memory){
      require(thirdparty[_assetNo] == msg.sender, "You do not have Access to view Asset Details");
      require(timeallowed[_assetNo][msg.sender] > block.timestamp, "Your time is Up" );
       return getAssetOwnerName(_assetNo);
      
  }
  
  mapping (uint256 => mapping(address => address)) delegate;    // mapping Asset no to Owner address to delegate Owner address
  function delegateOwner(uint256 _assetNo, address _to) public returns(address){
      delegate[_assetNo][msg.sender] = _to;
      
      return _to;
      
  }
  
  
  mapping(uint256 => mapping(address => uint256)) trail; // mapping Asset No to Owner to DateofTransfer
  uint256[][] public owners;  // array of owner no to asset no.

}