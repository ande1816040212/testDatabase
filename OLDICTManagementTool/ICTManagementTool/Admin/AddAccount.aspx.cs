using System;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using ICTManagementTool.Models;
using System.Web.UI.WebControls;
using ICTManagementTool.Helpers;

namespace ICTManagementTool.Admin
{
    public partial class AddAccount : System.Web.UI.Page
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();
        int year = System.DateTime.Now.Year;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);

            DDLPlans.DataSource = db.Plans.ToArray();
            DDLPlans.DataTextField = "planName";
            DDLPlans.DataValueField = "planId";
            DDLPlans.DataBind();


        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //checks if there is someone logged in
            if (null == Context.GetOwinContext().Authentication.User.Identity.GetUserId())
            {
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
            }


        }

        protected void AddAccount_Click(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var user = new ApplicationUser()
            {
                UserName = TBUsername.Text,
                Email = TBEmail.Text,
                title = TBTitle.Text,
                firstName = TBFirstName.Text,
                lastName = TBLastName.Text,
                dateCreated = System.DateTime.Now,
                PhoneNumber = TBPhoneNumber.Text
            };
            IdentityResult result = manager.Create(user, "aaaaa1");

            if (result.Succeeded)
            {
                if ("student".Equals(DDLUserType.SelectedValue)) { addStudent(user); }
                else if ("staff".Equals(DDLUserType.SelectedValue)) { addStaff(user); }
                else if ("client".Equals(DDLUserType.SelectedValue)) { addClient(user); }
                else { throw new Exception("Cannot determine account type!"); }
                DDLUserType.ClearSelection();
            }
        }

        protected void addStudent(ApplicationUser user)
        {
            var student = new ICTManagementTool.Models.Students();

            using (var db = new ICTProjectsEntities())
            {
                var s = db.AspNetUsers.Find(user.Id);
                student.studentID = s.personID;
            }

            student.uniUserName = user.UserName;
            student.uniStudentID = TBStudentID.Text;
            student.planId = int.Parse(DDLPlans.SelectedValue);


            decimal gpaOutput = 0;
            if (decimal.TryParse(TBGPA.Text, out gpaOutput))
            {
                student.gpa = gpaOutput;
            }

            student.year = year;

            string sem = (System.DateTime.Now.Month < 5) ? "SP2" : "SP5";
            student.semester = sem;

            var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
            ictm.Students.Add(student);
            ictm.SaveChanges();

            UserRoleHelper.addUserToRole(user.Id, "Student");
        }

        protected void addStaff(ApplicationUser user)
        {
            var staff = new ICTManagementTool.Models.Staff();

            using (var db = new ICTProjectsEntities())
            {
                var s = db.AspNetUsers.Find(user.Id);
                staff.staffID = s.personID;
            }

            staff.username = user.UserName;
            staff.uniStaffID = TBStudentID.Text;

            var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
            ictm.Staff.Add(staff);
            ictm.SaveChanges();

            UserRoleHelper.addUserToRole(user.Id, "Staff");
        }

        protected void addClient(ApplicationUser user)
        {
            var client = new ICTManagementTool.Models.Clients();

            using (var db = new ICTProjectsEntities())
            {
                var s = db.AspNetUsers.Find(user.Id);
                client.clientID = s.personID;
            }

            client.companyName = TBCompany.Text;

            var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
            ictm.Clients.Add(client);
            ictm.SaveChanges();

            UserRoleHelper.addUserToRole(user.Id, "Client");
        }


    }
}