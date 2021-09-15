using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using ICTManagementTool.Models;
using ICTManagementTool.Helpers;

namespace ICTManagementTool.Account
{
    public partial class Register : Page
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        protected void CreateUser_Click(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser()
            {
                UserName = Username.Text,
                Email = Email.Text,
                dateCreated = System.DateTime.Now,
                firstName = TBFirstName.Text,
                lastName = TBLastName.Text,
                title = TBTitle.Text
            };
            IdentityResult result = manager.Create(user, Password.Text);
            if (result.Succeeded)
            {
                // Temp Fix to add all new reg to Client 30/01/2018
                var c = db.AspNetUsers.Find(user.Id);
                if (c != null)
                {
                    var client = new Clients();
                    client.clientID = c.personID;
                    db.Clients.Add(client);
                    db.SaveChanges();

                    UserRoleHelper.addUserToRole(user.Id, "Client");

                }
                // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                //string code = manager.GenerateEmailConfirmationToken(user.Id);
                //string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                //manager.SendEmail(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                if (string.IsNullOrWhiteSpace(Request.QueryString["ReturnUrl"]))
                {
                    //this sends them to the home page if there is no return url
                    Response.Redirect("~/");
                }
                else
                {
                    Response.Redirect(Request.QueryString["ReturnUrl"], false);
                }
            }
            else
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
            }
        }
    }
}