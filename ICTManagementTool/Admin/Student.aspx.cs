using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.ModelBinding;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICTManagementTool.Models;
using Microsoft.AspNet.Identity;

namespace ICTManagementTool.Admin
{
    public partial class Student : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            //checks if there is someone logged in
            if (null == Context.GetOwinContext().Authentication.User.Identity.GetUserId())
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);
            }
            else
            {

                int studentID;

                if (Int32.TryParse(Request.QueryString["studentID"], out studentID))
                {
                    if (0 == studentID)
                    {
                        Response.Redirect("Students");
                    }
                }
                using (var db = new ICTProjectsEntities())
                {

                    var commentDetails = (from pc in db.PeopleComments
                                          join au in db.AspNetUsers
                                          on pc.commentPersonID equals au.personID
                                          where pc.personID == studentID
                                          select new CommentsDetail
                                          {
                                              comments = pc,
                                              personName = au.firstName + " " + au.lastName
                                          }).ToList();
                    
                    RepeaterComments.DataSource = commentDetails;
                    RepeaterComments.DataBind();
                    if (RepeaterComments.Items.Count == 0)
                    {
                        RepeaterComments.Visible = false;
                        LabelNoComments.Visible = true;
                    }
                }
            }


        }

        protected void FVStudent_PreRender(object sender, EventArgs e)
        {



        }

        // The id parameter should match the DataKeyNames value set on the control
        // or be decorated with a value provider attribute, e.g. [QueryString]int id
        public ICTManagementTool.Models.Students FVStudent_GetItem([QueryString]int? studentID)
        {
            if (studentID.HasValue)
            {
                var model = new Models.ICTProjectsEntities().Students.Find(studentID);
                if (null == model)
                {
                    Response.Redirect("Students", false);
                    //stackoverflow said to add this, but it doesnt seem necersarry
                    //Context.ApplicationInstance.CompleteRequest();
                    return null;
                }
                else
                {
                    return new Models.ICTProjectsEntities().Students.Find(studentID);
                }
            }
            else
            {
                Response.Redirect("Students", false);
                //stackoverflow said to add this, but it doesnt seem necersarry
                //Context.ApplicationInstance.CompleteRequest();
                return null;
            }

        }
    }

    public class CommentsDetail
    {
        public Models.PeopleComments comments { get; set; }
        public string personName { get; set; }
    }
}