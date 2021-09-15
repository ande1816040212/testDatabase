using ICTManagementTool.Helpers;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool.Partners
{
    public partial class ProjectManagement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.GetUserId() == null)
            {
                //redirects the page to the login screen
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);
            }
            else
            {
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Admin") && !UserRoleHelper.userInRole(User.Identity.GetUserId(), "Client"))
                {
                    //redirects the page to the login screen
                    Session["errorMessage"] = "You do not have access to the requested page.";
                    Response.Redirect("~/", false);
                }
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Admin"))
                {
                    adminStatus.Visible = false;
                }
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Client"))
                {
                    clientStatus.Visible = false;
                }
                //this block of code just populates the year/semester drop down lists on the page
                //the year options are the current year, +1, +2, -1 and -2
                var currentDate = System.DateTime.Now;
                for (int i = -2; i <= 2; i++)
                {
                    var li = new ListItem(currentDate.AddYears(i).Year.ToString());
                    DDLYear.Items.Add(li);
                }
                DDLYear.DataBind();

                var sp2 = new ListItem("SP2", "sp2");
                var sp5 = new ListItem("SP5", "sp5");

                DDLSemester.Items.Add(sp2);
                DDLSemester.Items.Add(sp5);


            }
        }
    }
}