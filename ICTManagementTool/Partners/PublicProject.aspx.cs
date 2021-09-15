using ICTManagementTool.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICTManagementTool.Helpers;

namespace ICTManagementTool.Partners
{
    public partial class PublicProject : System.Web.UI.Page
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            int dummyID = -1;

            var dbLookup = (from p in db.AspNetUsers
                            where p.UserName.Equals("DummyAccount")
                            select new
                            {
                                p
                            }
            ).ToList();

            if (0 == dbLookup.Count)
            {
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
                var user = new ApplicationUser() { UserName = "DummyAccount", Email = "dummy@example.com", dateCreated = System.DateTime.Now, firstName = "Dummy", lastName = "Account" };
                IdentityResult result = manager.Create(user, "password123");
                if (result.Succeeded)
                {
                    //doesnt work but i wish it did
                    //dummyID = user.personID;
                    //System.Diagnostics.Debug.WriteLine(user.personID); // - always prints 0

                    dummyID = (from p in db.AspNetUsers
                               where p.UserName.Equals("DummyAccount")
                               select new
                               {
                                   p
                               }
                    ).ToList().FirstOrDefault().p.personID;
                }
                else
                {
                    //do something regarding error
                    System.Diagnostics.Debug.WriteLine(result.Errors.FirstOrDefault());
                }
            }
            else
            {
                dummyID = dbLookup.FirstOrDefault().p.personID;
            }

            if (-1 != dummyID)
            {
                //create project
                var proj = db.Projects.Add(new Models.Projects
                {
                    //TODO: fix the default value in the database so I don't have to do this every time
                    Id = Guid.NewGuid().ToString(),
                    projectCreatorID = dummyID,
                    projectTitle = InputProjName.Value,
                    projectScope = InputDesc.Text,
                    //TODO: fix project status
                    projectStatus = Helpers.ProjectHelper.getProjectStatusIdFromName("Expression of Interest"),
                    projectStatusComment = "Email: " + InputEmail.Text + " Phone:" + InputPhone.Text,
                    honoursUndergrad = "u",
                    dateCreated = DateTime.Now
                }
                );
                db.SaveChanges();

                string[] to = { InputEmail.Text };

                string body = "Thank you for expressing interest in a ICT Project for the University of South Australia. <br /><br /> To complete your project application, please follow the following link:<br />";

                body += "<a href=" + Request.Url.Scheme + "://" + Request.Url.Authority + Request.ApplicationPath.TrimEnd('/') + "/" + "Partners/Project?Id=" + proj.Id + ">Complete Application</a>";

                EmailHelper.sendEmail(to: to, subject: "University of South Australia - ICT Project EOI", body: body, isBodyHtml: true);

                Page.ClientScript.RegisterStartupScript(this.GetType(), "CallMyFunction", "showSuccess()", true);


            }
            else
            {
                System.Diagnostics.Debug.WriteLine("Unsuccessful. Should never reach here.");
            }





        }
    }
}