using ICTManagementTool.Helpers;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool.Allocation
{
    public partial class ProjectAllocations : System.Web.UI.Page
    {
        Models.ICTProjectsEntities ictp = new Models.ICTProjectsEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            //checks if there is someone logged in
            if (User.Identity.GetUserId() == null)
            {
                //redirects the page to the login screen
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);
            }
            else
            {
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Admin"))
                {
                    //redirects the page to the login screen
                    Session["errorMessage"] = "You do not have access to the requested page.";
                    Response.Redirect("~/", false);
                }

                if (!IsPostBack)
                {
                    //this block of code just populates the year/semester drop down lists on the page
                    //the year options are the current year, +1, +2, -1 and -2
                    var currentDate = System.DateTime.Now;
                    for (int i = -2; i <= 2; i++)
                    {
                        var li = new ListItem(currentDate.AddYears(i).Year.ToString());
                        if (i == 0) li.Selected = true;
                        DDLYear.Items.Add(li);
                    }
                    DDLYear.DataBind();

                    var sp2 = new ListItem("SP2", "sp2");
                    var sp5 = new ListItem("SP5", "sp5");



                    DDLSemester.Items.Add(sp2);
                    DDLSemester.Items.Add(sp5);

                    DDLSemester.ClearSelection();
                    if (currentDate.Month > 3)
                    {
                        foreach (ListItem li in DDLSemester.Items)
                        {
                            if (sp5.Equals(li)) { li.Selected = true; }
                        }
                    }
                    //havent tested whether this block of code works
                    if (currentDate.Month < 3) { sp2.Selected = true; }
                    else { sp5.Selected = true; }
                }
            }

        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression
        public IQueryable<ProjectDetail> RProjects_GetData()
        {
            var sql = from p in ictp.Projects
                      join pp in ictp.PriorityProjects
                      on p.projectID equals pp.projectID into gj
                      from priority in gj.DefaultIfEmpty()
                      select new ProjectDetail
                      {
                          projects = p,
                          priorityProject = priority
                      };

            return sql;
        }

        public IEnumerable<ICTManagementTool.Models.AspNetUsers> RPeople_GetData()
        {
            return ictp.AspNetUsers;
        }

        protected void RProjects_PreRender(object sender, EventArgs e)
        {
            //if (GVProjects.Rows.Count > 0)
            //{
            //    GVProjects.HeaderRow.TableSection = TableRowSection.TableHeader;
            //}
        }

        protected void RProjects_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            var item = e.Item.DataItem as ProjectDetail;
        }

        protected void BProjectCodes_Click(object sender, EventArgs e)
        {
            try
            {
                int year = Convert.ToInt32(DDLYear.SelectedValue);
                string sem = DDLSemester.SelectedValue;

                //var codeCount = (from p in ictp.Projects
                //                 where p.projectSemester == sem
                //                && p.projectYear == year
                //                && !string.IsNullOrEmpty(p.projectCode)
                //                 select p).Count();

                // get a list of all allocated projects
                var projects = (from p in ictp.Projects
                                join pp in ictp.ProjectPeopleAllocations
                                on p.projectID equals pp.projectID
                                where p.projectSemester == sem
                                && p.projectYear == year
                                && p.projectStatus == 5 // allocated
                                join s in ictp.Students
                                on pp.personID equals s.studentID
                                orderby p.honoursUndergrad == "h"
                                select p.projectID)
                                .GroupBy(p => p)
                                .Select(p => p.Key)
                                .ToList();


                // set the project code to yr-sem-
                //for (int i = 1; i <= projects.Count; i++)
                //{
                //    var p = ictp.Projects.Find(projects[i]);
                //    if (string.IsNullOrWhiteSpace(p.projectCode))
                //    {
                //        for (int code = 1; code <= projects.Count; code++)
                //        {
                //            var projectCode = (year + "-" + sem + "-" + (code).ToString("D2")).ToUpper();
                //            if (ictp.Projects.Where(p2 => p2.projectCode == projectCode).Count() == 0)
                //            {
                //                p.projectCode = projectCode;
                //                ictp.SaveChanges();
                //            }
                //        }
                //    }
                //}

                var projectCodes = (from x in ictp.Projects where projects.Contains(x.projectID) select x.projectCode).ToList();

                for (int i = 0; i < projects.Count; i++)
                {
                    var p = ictp.Projects.Find(projects[i]);

                    System.Diagnostics.Debug.WriteLine("Project: " + projects[i] + " --> " + p.projectCode);

                    if (string.IsNullOrWhiteSpace(p.projectCode))
                    {
                       
                        for (int code = 1; code <= projects.Count; code++)
                        {
                           
                            var projectCode = (year + "-" + sem + "-" + (code).ToString("D2")).ToUpper();
                            if (!projectCodes.Contains(projectCode))
                            {
                                p.projectCode = projectCode;
                                ictp.SaveChanges();
                                projectCodes.Add(projectCode);
                                break;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                //TODO
                throw ex;
            }
        }

        protected void BRemoveProjectCodes_Click(object sender, EventArgs e)
        {
            try
            {
                int year = Convert.ToInt32(DDLYear.SelectedValue);
                string sem = DDLSemester.SelectedValue;

                // get a list of all allocated projects
                var projects = (from p in ictp.Projects
                                where
                                p.projectSemester == sem
                                && p.projectYear == year
                                && !String.IsNullOrEmpty(p.projectCode)
                                select p.projectID
                                )
                                .ToList();



                // set the project code to yr-sem-
                for (int i = 0; i < projects.Count; i++)
                {
                    var p = ictp.Projects.Find(projects[i]);
                    p.projectCode = null;
                    ictp.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                //TODO
                throw ex;
            }
        }

    }


}
