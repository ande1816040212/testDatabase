using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Web.ModelBinding;
using System.Data.SqlClient;
using System.Data;
using Microsoft.AspNet.Identity;
using System.Web.Http;
using System.Web.Http.Description;
using ICTManagementTool.Models;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ICTManagementTool.Helpers;
using Microsoft.AspNet.Identity.Owin;

namespace ICTManagementTool.Partners
{
    public partial class Project : System.Web.UI.Page
    {


        DropDownList DDLSemester { get { return FVProject.FindControl("DDLSemester") as DropDownList; } }
        DropDownList DDLDuration { get { return FVProject.FindControl("DDLDuration") as DropDownList; } }
        DropDownList DDLTasks { get { return FVProject.FindControl("DDLTasks") as DropDownList; } }
        Button TBHours { get { return FVProject.FindControl("TBHours") as Button; } }

        Repeater RMethodsApplied { get { return FVProject.FindControl("RMethodsApplied") as Repeater; } }

        string duration = null;
        string semester = null;

        int projectID = 0;

        public int projectIdForAngular = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            IQueryable<ICTManagementTool.Models.AspNetUsers> ab = new Models.ICTProjectsEntities().AspNetUsers;
            string UserId = System.Web.HttpContext.Current.User.Identity.GetUserId();


            if (string.IsNullOrEmpty(Request.QueryString["Id"]))
            {
                //if no one is logged in
                if (User.Identity.GetUserId() == null)
                {
                    //redirect to login page
                    Response.Redirect("/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);

                    //Old code to allow users to login using modal javascript
                    //Page.ClientScript.RegisterStartupScript(this.GetType(), "ModalPopup", "initialLogInModal()", true);

                }
                else
                {
                    FVProject.ChangeMode(FormViewMode.Insert);
                    LAction.Text = "Create";
                }

            }
            else
            {

                var db = new Models.ICTProjectsEntities();
                string id = Request.QueryString["Id"].ToString();
                var project = db.Projects.Where(p => p.Id == id).ToList().FirstOrDefault();

                projectIdForAngular = project.projectID;

                #region projectOwnership
                //allocation of project to new owner

                //if the dummy account is logged in or the project doesnt exist
                if ("DummyAccount" == User.Identity.GetUserName() || null == project)
                {
                    //redirect to projects page
                    Response.Redirect("~/Partners/ProjectManagement.aspx", false);
                }

                //if no one is logged in
                if (User.Identity.GetUserId() == null)
                {
                    //redirect to login page
                    Response.Redirect("/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);

                    //Old code to allow users to login using modal javascript
                    //Page.ClientScript.RegisterStartupScript(this.GetType(), "ModalPopup", "initialLogInModal()", true);
                    
                }
                else
                {
                    var dummyAccount = db.AspNetUsers.Where(d => d.UserName == "DummyAccount").ToList().FirstOrDefault();
                    if (null != dummyAccount)
                    {
                        var loggedInUserId = User.Identity.GetUserId();
                        var loggedInUser = db.AspNetUsers.Where(u => u.Id == loggedInUserId).ToList().FirstOrDefault();

                        if (project.projectCreatorID == dummyAccount.personID)
                        {
                            //allocate project
                            //TODO: maybe change the project status
                            project.projectStatus = ProjectHelper.getProjectStatusIdFromName("Pending");
                            project.projectCreatorID = loggedInUser.personID;

                            db.SaveChanges();
                        }
                        else
                        {
                            //check if the current project belongs to the current user and isnt an admin
                            if(project.projectCreatorID != loggedInUser.personID && !UserRoleHelper.userInRole(loggedInUser.Id, "Admin"))
                            {
                                Session["errorMessage"] = "You do not have access to the requested page.";
                                Response.Redirect("~/", false);
                            }
                        }
                    }
                }

                #endregion

                LAction.Text = "Create";





            }


            // get values
            LAction.Text = "Selected";

            // if the FormView is in Edit/Insert mode, get DDL values and set
            if (!FVProject.CurrentMode.Equals(FormViewMode.ReadOnly))
            {
                if (DDLDuration != null) duration = Request.Form[DDLDuration.UniqueID];
                if (DDLSemester != null) semester = Request.Form[DDLSemester.UniqueID];
            }





        }

        public string getOwner(int id)
        {
            var db = new ICTProjectsEntities();
            var owner = db.AspNetUsers.Where(p => p.personID == id).FirstOrDefault();
            return owner.title + ". " + owner.firstName + " " + owner.lastName;
        }

        // The id parameter should match the DataKeyNames value set on the control
        // or be decorated with a value provider attribute, e.g. [QueryString]int id
        public ICTManagementTool.Models.Projects FVProject_GetItem([QueryString]string Id)
        {
            var db = new ICTProjectsEntities();
            //var pd = (from p in db.Projects
            //          join c in db.AspNetUsers
            //          on p.projectCreatorID equals c.personID
            //          where p.Id == Id
            //          select new
            //          {
            //              p,
            //              owernerName = c.firstName + ' ' + c.lastName
            //          }).FirstOrDefault();

            var proj = db.Projects.Where(p => p.Id == Id).Select(p => p).ToList().FirstOrDefault();

            if (null != proj)
            {
                return proj;
            }
            else
            {
                Response.Redirect("~/Partners/ProjectManagement.aspx", false);
                return null;
            }

        }

        public void FVProject_InsertItem()
        {
            var item = new ICTManagementTool.Models.Projects();
            TryUpdateModel(item);
            if (ModelState.IsValid)
            {
                var ictp = new Models.ICTProjectsEntities();

                int myID = 0;
                IQueryable<ICTManagementTool.Models.AspNetUsers> ab = new Models.ICTProjectsEntities().AspNetUsers;
                string UserId = System.Web.HttpContext.Current.User.Identity.GetUserId();

                foreach (var a in ab)
                {
                    if (a.Id == UserId)
                    {
                        myID = a.personID;
                    }

                }

                item.dateCreated = System.DateTime.Now;
                item.projectCreatorID = myID;
                item.projectSemesterCode = null;
                item.studentsReq = 1;
                item.honoursUndergrad = "u";
                item.projectSponsorAgreement = false;
                item.projectYear = System.DateTime.Now.Year;
                item.projectSemester = System.DateTime.Now.Month > 3 ? "SP5" : "SP2";

                item.projectStatus = ProjectHelper.getProjectStatusIdFromName("Pending");
                //the length of honoursUndergrade should be less than six
                //TODO
                item.honoursUndergrad = "u";

                //TODO: fix the default value in the database so I don't have to do this every time
                item.Id = Guid.NewGuid().ToString();

                var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                ictm.Projects.Add(item);
                ictm.SaveChanges();

                //if this true is changed to false, it doesnt redirect the user properly
                Response.Redirect(String.Format("/Partners/Project.aspx?Id={0}", item.Id), true);


            }
        }

        // The id parameter name should match the DataKeyNames value set on the control
        public void FVProject_UpdateItem([QueryString]string Id, [QueryString]string firstName)
        {

            var db = new ICTProjectsEntities();

            var proj = db.Projects.Where(p => p.Id == Id).Select(p => p).ToList().FirstOrDefault();
            if (null != proj)
            {
                projectID = proj.projectID;
            }
            else
            {
                Response.Redirect("~/Partners/ProjectManagement.aspx", false);
            }


            ICTManagementTool.Models.Projects item = db.Projects.Find(projectID);

            var user = new ICTManagementTool.Models.AspNetUsers();


            if (item == null)
            {
                // The item wasn't found
                ModelState.AddModelError("", String.Format("Item with id {0} was not found", projectID));
                return;
            }
            TryUpdateModel(item);
            if (ModelState.IsValid)
            {
                var CBHons = FVProject.FindControl("CBHonsProject") as CheckBox;

                // myDate = System.DateTime.Now;
                item.projectSemester = semester;
                item.projectDuration = Convert.ToInt32(duration);
                item.honoursUndergrad = CBHons.Checked ? "h" : "u"; // h = hons, u = undergrad


                saveMethodsApplied();
                db.SaveChanges();
            }

        }

        // The id parameter name should match the DataKeyNames value set on the control
        public void FVProject_DeleteItem(int? projectID)
        {
            var ictp = new Models.ICTProjectsEntities();
            var methodApplied = ictp.ProjectMethodsApplied
                     .Where(p => p.projectID == projectID).ToArray();

            if (methodApplied != null)
            {
                foreach (var a in methodApplied)
                {
                    ictp.ProjectMethodsApplied.Remove(a);
                }
            }

            ICTManagementTool.Models.Projects item = ictp.Projects.Find(projectID);
            ictp.Projects.Remove(item);


            ictp.SaveChanges();
            Response.Redirect("ProjectManagement.aspx");
        }

        protected void saveMethodsApplied()
        {
            // 1 get checked methods from the form
            var formMethodsApplied = new int[0];
            if (Request.Form["methodApplied"] != null)
            {
                formMethodsApplied = Request.Form["methodApplied"].Split(',').Select(int.Parse).ToArray();
            }

            using (var db = new ICTProjectsEntities())
            {

                // 2 get all methods
                var allMethods = db.ProjectMethods
                    .Select(p => p.methodID)
                    .ToArray();

                // 3 get db Methods applied
                var dbMethodsApplied = db.ProjectMethodsApplied
                    .Where(p => p.projectID == projectID)
                    .Select(p => p.methodID)
                    .ToArray();

                // 4. determine unused method
                // subtract all formMethodsApplied from allMethods.
                //var unUsedMethods = allMethods
                //    .Where(p => !formMethodsApplied.Contains(p))
                //    .ToArray();

                foreach (var m in allMethods)
                {
                    // if checked, but not saved in ProjectMethodsApplied table, insert new record
                    if (formMethodsApplied.Contains(m) && !dbMethodsApplied.Contains(m))
                    {
                        var pma = new ProjectMethodsApplied();
                        pma.comment = null;
                        pma.methodID = m;
                        pma.projectID = projectID;

                        db.ProjectMethodsApplied.Add(pma);
                    }
                    // else if not checked, and is saved in ProjectMethodsApplied table, remove old record
                    else if (!formMethodsApplied.Contains(m) && dbMethodsApplied.Contains(m))
                    {
                        // find the record and delete
                        var pma = db.ProjectMethodsApplied
                            .Where(p => p.projectID == projectID && p.methodID == m)
                            .FirstOrDefault();
                        db.ProjectMethodsApplied.Remove(pma);
                    }
                }
                db.SaveChanges();
            }
        }

        protected void FVProject_PreRender(object sender, EventArgs e)
        {

            if (FVProject.Row.RowType == DataControlRowType.DataRow)
            {
                //if the page has the projectownerdiv on it
                if (FVProject.Row.Cells[0].FindControl("ProjectOwnerDiv") != null)
                {
                    string userId = System.Web.HttpContext.Current.User.Identity.GetUserId();

                    //if the user is not an admin,
                    //hide the projectownerdiv
                    if (!UserRoleHelper.userInRole(userId, "Admin"))
                    {
                        FVProject.Row.Cells[0].FindControl("ProjectOwnerDiv").Visible = false;
                    }
                }
            }

            // if the repeater exists (FV edit, readonly modes)
            if (RMethodsApplied != null)
            {
                using (var db = new ICTProjectsEntities())
                {
                    // get a list of all methods, and where available, those selected
                    var methods = (from m in db.ProjectMethods
                                   join ma in db.ProjectMethodsApplied
                                   on m.methodID equals ma.methodID
                                   into gp1
                                   // note left join with projectID in where clause so as not to remove
                                   // all methods given they have no projectID!
                                   from all in gp1.Where(p => p.projectID == projectID).DefaultIfEmpty()
                                   select new ProjectMethodsAppliedDetail
                                   {
                                       methodID = m.methodID,
                                       methodDesc = m.methodDescription,
                                       // this val is important as it is used to determine if the selection
                                       // is checked or not.
                                       // if it's null, then the methodID is not in the ProjectMethodsApplied table
                                       // thus not checked.
                                       isChecked = all != null ? all.methodID > 0 : false
                                   })
                                   .OrderBy(p => p.methodDesc)
                                   .ToList();

                    RMethodsApplied.DataSource = methods;
                    RMethodsApplied.DataBind();

                }
            }

        }

        // method to specify if methodApplied CB is checked or not
        public string isChecked(bool val)
        {
            string attr = string.Empty;

            if (val)
            {
                attr = "checked=\"checked\"";
            }
            return attr;
        }

        //method to specify if methodApplied CB is unchecked
        //this is used to show/hide the correct methods on the view project page
        public string isUncheckedToHide(bool val)
        {
            string attr = string.Empty;

            if (!val)
            {
                attr = "hidden=\"true\"";
            }
            return attr;
        }

        //gets the status name of the given statusId
        public string statusNameFromId(int id)
        {
            using (var db = new ICTProjectsEntities())
            {
                var status = db.ProjectStatus.Find(id);
                if (status != null)
                {
                    return status.StatusName;
                }
                else
                {
                    return "No status";
                }
            }
        }

        //checks if the given input is empty
        //if not blank, returns itself
        //if blank, returns '-'
        public string isBlank(string stringToCheck)
        {
            if (stringToCheck == "" | stringToCheck == null)
            {
                return "-";
            }
            else
            {
                return stringToCheck;
            }
        }

        // custom class for the user interface (not needed)
        // without it you must use Eval("") // less safe
        public class ProjectMethodsAppliedDetail
        {
            public int methodID { get; set; }
            public string methodDesc { get; set; }
            public bool isChecked { get; set; }
            public int firstName { get; set; }
        }



        //OLD CODE FROM WHEN MODAL LOGIN WAS A THING
        /*
        // login method for modal login
        protected void LogIn(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // Validate the user password
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                // This doen't count login failures towards account lockout
                // To enable password failures to trigger lockout, change to shouldLockout: true
                //still need firstname & last name, will solve later
                var result = signinManager.PasswordSignIn(UserName.Text, Password.Text, RememberMe.Checked, shouldLockout: false);

                switch (result)
                {
                    case SignInStatus.Success:
                        Response.Redirect(Request.RawUrl);
                        break;
                    case SignInStatus.LockedOut:
                        Response.Redirect("/Account/Lockout");
                        break;
                    case SignInStatus.RequiresVerification:
                        Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                                        Request.QueryString["ReturnUrl"],
                                                        RememberMe.Checked),
                                          true);
                        break;
                    case SignInStatus.Failure:
                    default:
                        FailureText.Text = "Invalid login attempt";
                        ErrorMessage.Visible = true;
                        break;
                }
            }
        }

        protected void CreateUser_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("in the method createuser_click");
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = RegisterUsername.Text, Email = Email.Text, dateCreated = System.DateTime.Now };
            IdentityResult result = manager.Create(user, RegisterPassword.Text);
            if (result.Succeeded)
            {
                System.Diagnostics.Debug.WriteLine("success");
                // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                //string code = manager.GenerateEmailConfirmationToken(user.Id);
                //string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                //manager.SendEmail(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
            }
            else
            {
                RegisterErrorMessage.Text = result.Errors.FirstOrDefault();
                System.Diagnostics.Debug.WriteLine("im here");
                System.Diagnostics.Debug.WriteLine(result.Errors.FirstOrDefault());
            }
        }
        */


    }
}