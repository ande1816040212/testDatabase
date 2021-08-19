using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ICTManagementTool.Allocation
{
    public class ClientProjectDetail
    {
        public Student[] students { get; set; }
        public Models.AspNetUsers[] staff { get; set; }
        public Models.AspNetUsers client { get; set; }
        public Models.Projects project { get; set; }
        public string projectStatus { get; set; }
        

        public class Student
        {
            public string firstName { get; set; } 
            public string lastName { get; set; }
            public string email { get; set; }
        }
    }
}