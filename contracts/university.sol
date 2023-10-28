// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
contract  University{
    struct College{
        string name;
         address cAdmin;
        address collegeAddress;
        uint256 cRegNo;
        uint256 noOfStudents;
        bool blockToAddStudent;
    }
    struct Student{
        address collegeAddress;
        string sName;
        uint256 pNo;
        string courseName;

    }
    address public owner;
    mapping(address=>College) colleges;
    mapping(string=>Student) students;

    constructor(){
        owner=msg.sender;
    }


// Adding a new College
//only owner can add a new college
    function addNewCollege(string memory _name,address _collegeAddress, address _cAdmin,uint256 _cRegNo)public  onlyOwner { 
        require(_collegeAddress!=address(0),"Not a valid address"); 
    require(_cAdmin!=colleges[_collegeAddress].cAdmin,"Already exists");
    College storage newCollege=colleges[_collegeAddress];
    newCollege.name=_name;
    newCollege.cAdmin=_cAdmin;
    newCollege.collegeAddress=_collegeAddress;
    newCollege.cRegNo=_cRegNo;
    newCollege.noOfStudents=0;
}

//add student details to the given college addtress
//check if college is blocked from adding student
//only admin can add a student
function addNewStudentToCollege(address _collegeAddress,string memory _sName,uint256 _pNo,string memory _courseName)public validCollegeAddress(_collegeAddress) {
    require(colleges[_collegeAddress].blockToAddStudent!=true,"Not permitted");
    require(msg.sender==colleges[_collegeAddress].cAdmin,"Only Admin is allowed");
    Student storage newStudent=students[_sName];
    newStudent.collegeAddress=_collegeAddress;
    newStudent.sName=_sName;
    newStudent.pNo=_pNo;
    newStudent.courseName=_courseName;
    colleges[_collegeAddress].noOfStudents++;
}

//block a college from adding new student
function blockToAddStudent(address _collegeAddress) public onlyOwner validCollegeAddress(_collegeAddress){
    colleges[_collegeAddress].blockToAddStudent=true;
}

//allow a college to add student
function unblockToAddStudent(address _collegeAddress)public onlyOwner validCollegeAddress(_collegeAddress) {
    colleges[_collegeAddress].blockToAddStudent=false;
}

//change student course details
//only admin can add student details
function changeStudentCourse(address _collegeAddress, string memory _sName,string memory _courseName)public validCollegeAddress(_collegeAddress){
        require(msg.sender==colleges[_collegeAddress].cAdmin,"Only Admin is allowed");
        require(students[_sName].collegeAddress==_collegeAddress,"Enter a valid college address and student name"); 
        students[_sName].courseName=_courseName;
}


//get the number of students for given colleg address
function getNoOfStudentsForCollege(address _collegeAddress)public view validCollegeAddress(_collegeAddress) returns(uint256){
    return colleges[_collegeAddress].noOfStudents;
}

//student details
function getStudentsDetails(string memory _sName)public view returns(Student memory){
    return students[_sName];
}

//college details
function viewCollegeDetails(address _collegeAddress)public view  validCollegeAddress(_collegeAddress) returns(College memory){
    return colleges[_collegeAddress];
}



modifier onlyOwner{
    require(msg.sender==owner,"only owner can call this function");
    _;
}

//check if the address is valid college address
modifier validCollegeAddress(address _collegeAddress){
 //require(_collegeAddress!=address(0),"Enter a valid college address");
 require(_collegeAddress==colleges[_collegeAddress].collegeAddress,"College address doenot exists");
 _;
}
}