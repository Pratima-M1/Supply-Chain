// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
contract  KYC{
     address public Admin;
    struct Bank{
        string bankName;
        address bankEthAddress;
        uint256 kycCount;
       /* string kycPrevilege;*/
        bool permitToAdd;
        bool toDoKYC;
    }
    
    struct Customer{
        string customerName;
         uint256 customerData;
        address customerBank;
        KYCStatus kycStatus;
        uint256 KYC;
       
    }

    enum KYCStatus{
       registered,
       underProcess,
       onHold,
       rejected,
       notAvailable,
       generated
    }
    
    mapping(address=>Bank) banks;
    
   mapping(string=>Customer) customers;
    constructor(){
        Admin=msg.sender;
    }

    function addNewBank(string memory _bankName,address _bankEthAddress)public onlyOwner {
        require(_bankEthAddress!=address(0),"Enter a valid bank address");
         Bank storage newBank= banks[_bankEthAddress];  
         newBank.bankName=_bankName;
         newBank.bankEthAddress=_bankEthAddress;
         newBank.kycCount=0;
         /*newBank.kycPrivilage=_kycPrivilage*/
         newBank.permitToAdd=false;
}

//only bank can call this function
function addNewCustomerToBank(string memory _customerName,uint256 _data/*,address _bankEthAddress*/)public{
   //how to check the msg.sender is valid bank address form bank
   //only bank can call this function
   require(banks[msg.sender].bankEthAddress!=address(0),"bank address doesnot exists");
  // address  _bankEthAddress=msg.sender;
    require(banks[msg.sender].permitToAdd!=false,"Bank is not allowed to customer");
    Customer storage newCustomer=customers[_customerName];
    newCustomer.customerName=_customerName;
    newCustomer.customerBank=msg.sender;
    newCustomer.customerData=_data;
    newCustomer.kycStatus=KYCStatus.notAvailable;
}

function blockBankToAddCustomer(address _bankEthAddress)public onlyOwner{
      banks[_bankEthAddress].permitToAdd=false;
}

function allowBankToAddCustomer(address _bankEthAddress)public onlyOwner{
      banks[_bankEthAddress].permitToAdd=true;
}

function blockBankFromKYC(address _bankEthAddress)public onlyOwner{
      banks[_bankEthAddress].toDoKYC=false;
}

function allowBankFromKYC(address _bankEthAddress)public onlyOwner{
      banks[_bankEthAddress].toDoKYC=true;
}

function checkKYCStatus(string memory _customerName)public view returns(KYCStatus){
    return customers[_customerName].kycStatus;
}

function viewCustomerDetails(string memory _customerName)public view returns(Customer memory){
    return customers[_customerName];
}

function addNewCustomerRequestForKYC(string memory _customerName)public{
        require(customers[_customerName].kycStatus==KYCStatus.notAvailable,"Please check the KYC Status");
        customers[_customerName].kycStatus=KYCStatus.registered;
}

function performKYCOfTheCustomer(string memory _customerName)public{
     //how to check the msg.sender is valid bank address form bank
     //only bank can call this function
   require(banks[msg.sender].bankEthAddress!=address(0),"bank address doesnot exists");
  // address  _bankEthAddress=msg.sender;
    require(banks[msg.sender].permitToAdd!=false,"Bank is not allowed to perform the KYC of the customer");
    Customer storage updateCustomer=customers[_customerName];
    require(updateCustomer.kycStatus==KYCStatus.registered,"customer has not requested for the KYC");
    //perform kyc
     updateCustomer.KYC= (uint(keccak256(abi.encodePacked(_customerName,updateCustomer.customerData,updateCustomer.customerBank))))%10**10;
updateCustomer.kycStatus=KYCStatus.generated;
}

modifier onlyOwner{
    require(msg.sender==Admin,"only Admin can call this function");
    _;
}
}