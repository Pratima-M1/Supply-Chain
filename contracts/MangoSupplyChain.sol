// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
contract MangoSupplyChain{
    struct Producer{
        uint productId;
        string productDescription;
        string producerName;
        string producerAddress;
        uint harvestDate;
        Distributor distributor;
        Retailor retailor;
    }
    struct Distributor{
        string distributorName;
        string distributorAddress;
        uint prodToDistDate;
    }
    struct Retailor{
        string retailorName;
        string retailorAddress;
        uint distToRetaDate;
    }
    mapping(uint=>Producer) producers;
    mapping(string=>Distributor)distributors;
    mapping(string=>Retailor) retailors;


///event ProducerSupply(uint productId,string productDescription,string producerName,string producerAddress,uint harvestDate);
//event ProducerToDistributorSupply(uint productId,string distributorName,string distributorAddress,uint prodToDistDate);
//event DistributorToRetailorSupply(uint productId,string retailorName,string retailorAddress,uint transactionDateDR);
event Supply(string msg);

function addMangoToProducerLedger(uint _productId,string memory _productDescription,string memory _producerName,string memory _producerAddress,uint _harvestDate)public{
    Producer storage newProducer=producers[_productId];
    newProducer.productId=_productId;
    newProducer.producerAddress=_producerAddress;
    newProducer.harvestDate=_harvestDate;
    newProducer.producerName=_producerName;
    newProducer.productDescription=_productDescription;
    //emit ProducerSupply(_productId,_productDescription,_producerName,_producerAddress,_harvestDate);
    emit Supply("successfully added Mango Asset");
}

function viewMangoDetails(uint _productId)public view returns(Producer memory){
return producers[_productId];
}

function tranasferMangoToDistributorLedger(uint _productId,uint _prodToDistDate,string memory _disitributorName,string memory _disitributorAddress)public{
 Distributor storage newDistributor=distributors[_disitributorName];
 newDistributor.distributorName=_disitributorName;
 newDistributor.distributorAddress=_disitributorAddress;
 newDistributor.prodToDistDate=_prodToDistDate;
 producers[_productId].distributor=newDistributor;
// emit ProducerToDistributorSupply(_productId,_disitributorName,_disitributorAddress, _prodToDistDate);
emit Supply("Successfully upadated distributor details");
}
function transferMangoToRetailor(uint _productId,string memory _retailorName,string memory _retailorAddress,uint _distToRetaDate)public{
    Retailor storage newRetailor=retailors[_retailorName];
    newRetailor.retailorName=_retailorName;
    newRetailor.retailorAddress=_retailorAddress;
    newRetailor.distToRetaDate=_distToRetaDate;
    producers[_productId].retailor=newRetailor;
   // emit DistributorToRetailorSupply(_productId,_retailorName,_retailorAddress,_distToRetaDate);
   emit Supply("Successfully upadated retailor details");
}
}