-------Q1---------------
Create table Students(

   StudentID int not null,
   Name nvarchar(50),
   Address nvarchar(200),
   Gender char(1)
   Primary key (StudentID)

)
Create table Teachers(

   TeacherID int not null,
   Name nvarchar(50),
   Gender char(1),
   Address nvarchar(200),
   Primary key (TeacherID)
)
Create table Classes(
  
  ClassID int not null,
  year int,
  Semester char(10),
  NoCredits int,
  courseID char(6),
  GroupID char(6),
  TeacherID int references Teachers(TeacherID),
  Primary key (ClassID,TeacherID)

)
Create table Attend(

   Slot int not null,
   Date date not null,
   Attend bit,
   TeacherID int,
   ClassID int,
   StudentID int references Students(StudentID),
   Foreign key (ClassID,TeacherID) references Classes(ClassID,TeacherID),
   Primary key (TeacherID,ClassID,Slot,Date,StudentID)

)
--------Q2.2----------
Insert into Teachers (TeacherID,Name,Address,Gender) Values (1,'Bui Chien','Cau Giay - Ha Noi','M');
Insert into Students (StudentID,Name,Address,Gender) Values (1,'Nguyen Hang','Cau Giay - Ha Noi','F');
Insert into Classes (ClassID,GroupID,courseID,year,Semester,NoCredits,TeacherID) Values (1,'SE1316','DBI202',2019,'S',3,1);
Insert into Attend (Slot,Date,ClassID,TeacherID,StudentID,Attend) Values (1,'2019-03-15',1,1,1,1);
