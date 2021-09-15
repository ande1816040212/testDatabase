using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using ICTManagementTool.Models;
using System.Web.Security;

namespace ICTManagementTool.Account
{
    public partial class Login : Page
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register";
            // Enable this once you have account confirmation enabled for password reset functionality
            //ForgotPasswordHyperLink.NavigateUrl = "Forgot";
            OpenAuthLogin.ReturnUrl = Request.QueryString["ReturnUrl"];
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);
            if (!String.IsNullOrEmpty(returnUrl))
            {
                RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            }
        }

        protected void LogIn(object sender, EventArgs e)
        {
            if (IsValid)
            {
                // Validate the user password
                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                // This doen't count login failures towards account lockout
                // To enable password failures to trigger lockout, change to shouldLockout: true
                var result = signinManager.PasswordSignIn(UserName.Text, Password.Text, RememberMe.Checked, shouldLockout: false);

                switch (result)
                {
                    case SignInStatus.Success:
                        //really dodgy way to find if the newly logged in person has been accepted
                        if (!db.AspNetUsers.Find(signinManager.UserManager.FindByName(UserName.Text).Id).AccountAccepted)
                        {
                            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
                            Session["errorMessage"] = "Your account has not yet been accepted by the University. <br /> Please contact Douglas Kelly to request to be accepted.";
                            Response.Redirect("~/", false);
                        }
                        else if (string.IsNullOrWhiteSpace(Request.QueryString["ReturnUrl"]))
                        {
                            //this sends them to the home page if there is no return url
                            Response.Redirect("~/", false);
                        }
                        else
                        {
                            Response.Redirect(Request.QueryString["ReturnUrl"], false);
                        }
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
    }
}