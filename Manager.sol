pragma solidity 0.5.1;
import "./Course.sol";

contract Manager {
    //Address of the school administrator
    address admin;
    
    mapping (address => int) student;
    mapping (address => bool) isStudent;
    mapping (int => bool) isCourse;
    mapping (int => Course) course;
    
    int rollCount = 19111000;
    
    //Constructor
    constructor () public{
        
        admin=msg.sender;
    }
    
    
    function kill() public{
        //The admin has the right to kill the contract at any time.
        //Take care that no one else is able to kill the contract
        require(
            msg.sender==admin,
            "Caller must be admin"
        );
        selfdestruct(msg.sender);

    }
    
    function addStudent( ) public {
        //Anyone on the network can become a student if not one already
        //Remember to assign the new student a unique roll number
       require(
            !isStudent[msg.sender],
            "The student already exist."
        );
        rollCount ++;
        student[msg.sender] = rollCount;
        isStudent[msg.sender]=true;
        
        
        
        

    }
    
    function addCourse(int courseNo, address instructor) public{
	    //Add a new course with course number as courseNo, and instructor at address instructor
        //Note that only the admin can add a new course. Also, don't create a new course if course already exists
        require(
           msg.sender == admin,
            "Only Admin can add course."
        );
        require(
            !isCourse[courseNo],
            "The course already exist."
        );
        Course newCourse = new Course(courseNo,instructor,msg.sender);
        course[courseNo]= newCourse;
        isCourse[courseNo]=true;
        
    }
    
    function regCourse(int courseNo) public {
        //Register the student in the course if he is a student on roll and the courseNo is valid
        require(
            isStudent[msg.sender],
            "The student does not exist."
        );
        require(
            isCourse[courseNo],
            "Course does not exist."
        );
        course[courseNo].enroll(student[msg.sender]);
        //return course[courseNo].isEnroll(student[msg.sender]);
            
        

    }
    
    function getMyMarks(int courseNo) public view returns(int, int, int) {
        //Check the courseNo for validity
        //Should only work for valid students of that course
	    //Returns a tuple (midsem, endsem, attendance)
	    require(
            isStudent[msg.sender],
            "The student does not exist."
        );
        require(
            isCourse[courseNo],
            "Course does not exist."
        );
	   int rollNo=student[msg.sender];
	   Course currentCourse=course[courseNo];
	   require(
            currentCourse.isEnroll(rollNo),
            "Course is not registered for the student."
        );
       int midsem=currentCourse.getMidsemMarks(rollNo);
	   int endsem=currentCourse.getEndsemMarks(rollNo);
	   int attendance=currentCourse.getAttendance(rollNo);
	   return (midsem,endsem,attendance);


    }
    
    function getMyRollNo() public view returns(int) {
        //Utility function to help a student if he/she forgets the roll number
        //Should only work for valid students
	    //Returns roll number as int
	     require(
            isStudent[msg.sender],
            "The student does not exist."
        );
	    return student[msg.sender];
	 

    }
    
}

