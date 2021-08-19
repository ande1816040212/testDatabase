using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool.Allocation
{
    public partial class ProjectClientEmail : System.Web.UI.Page
    {
        Models.ICTProjectsEntities ictp = new Models.ICTProjectsEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            int year = System.DateTime.Now.Year;
            int month = System.DateTime.Now.Month;
            string sem = month <= 3 ? "SP2" : "SP5";
            List<ClientProjectDetail> projectDetail = new List<ClientProjectDetail>();

            var projects = (from p in ictp.Projects
                            where p.projectYear == year
                            && p.projectSemester == sem
                            join ppa in ictp.ProjectPeopleAllocations
                            on p.projectID equals ppa.projectID
                            join s in ictp.Students
                            on ppa.personID equals s.studentID
                            select p)
                            .GroupBy(p => p.projectID)
                            .Select(p => p.FirstOrDefault())
                            .ToList();

            foreach (var p in projects)
            {
                var pd = new ClientProjectDetail();
                pd.project = p;

                var studentList = (from s in ictp.Students
                                   join pp in ictp.ProjectPeopleAllocations
                                   on s.studentID equals pp.personID
                                   where pp.projectID == p.projectID
                                   join u in ictp.AspNetUsers
                                   on s.studentID equals u.personID
                                   select new ClientProjectDetail.Student
                                   {
                                       firstName = u.firstName,
                                       lastName = u.lastName,
                                       email = s.studentEmail

                                   }
               ).ToArray();

                pd.students = studentList;

                var staffList = (from pp in ictp.ProjectPeopleAllocations
                                 where pp.projectID == p.projectID
                                 && pp.personRole == "staff"
                                 join u in ictp.AspNetUsers
                                 on pp.personID equals u.personID
                                 select u
           ).ToArray();

                pd.staff = staffList;

                var clientDetail = (from u in ictp.AspNetUsers
                                    where u.personID == p.projectCreatorID
                                    select u).FirstOrDefault();

                pd.client = clientDetail;
                pd.projectStatus = (from ps in ictp.ProjectStatus
                                    where ps.ProjectStatusId == p.projectStatus
                                    select ps.StatusName).FirstOrDefault();

                projectDetail.Add(pd);

            }

            projectDetail
                  .OrderBy(p => p.client.lastName)
                  .ThenBy(p => p.client.firstName)
                  .ThenBy(p => p.project.projectTitle);

            RProjects.DataSource = projectDetail;
            RProjects.DataBind();
        }

        protected void RProjects_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            var detail = e.Item.DataItem as ClientProjectDetail;
            var RStaff = e.Item.FindControl("RStaff") as Repeater;
            var RStudents = e.Item.FindControl("RStudents") as Repeater;

            RStaff.DataSource = detail.staff;
            RStudents.DataSource = detail.students;
            RStaff.DataBind();
            RStudents.DataBind();
        }
    }
}