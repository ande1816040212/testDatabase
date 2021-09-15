﻿using ICTManagementTool.Helpers;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool.Admin
{
    public partial class Students : System.Web.UI.Page
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
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Admin"))
                {
                    //redirects the page to the login screen
                    Session["errorMessage"] = "You do not have access to the requested page.";
                    Response.Redirect("~/", false);
                }
            }

            
        }

        protected void GVStudents_PreRender(object sender, EventArgs e)
        {
            
        }

        public IQueryable<ICTManagementTool.Models.Students> GVStudents_GetData()
        {
            return new Models.ICTProjectsEntities().Students;

        }
    }
}