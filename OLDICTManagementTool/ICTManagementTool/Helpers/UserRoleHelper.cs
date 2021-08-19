using ICTManagementTool.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ICTManagementTool.Helpers
{
    public class UserRoleHelper
    {
        //the main reason this helper exists is due to the way that we are required to add users to roles
        //there is no way to access AspNetUserRoles using models, so we are required to do it this way
        //a lot of help from here
        //http://johnatten.com/2013/11/11/extending-identity-accounts-and-implementing-role-based-authentication-in-asp-net-mvc-5/
        
        public static bool addUserToRole(string userId, string roleName)
        {
            //this method firstly checks if the role with the given name exists
            //if it does not, it automatically adds a new role with that name
            //      this could be changed to just reject the given user/role
            //
            //then it adds the person to the role with the given name

            var rm = new RoleManager<IdentityRole>(
                new RoleStore<IdentityRole>(new ApplicationDbContext()));
            if (!rm.RoleExists(roleName))
            {
                addRole(roleName);
            }

            var um = new UserManager<ApplicationUser>(
                new UserStore<ApplicationUser>(new ApplicationDbContext()));
            var idResult = um.AddToRole(userId, roleName);
            return idResult.Succeeded;
        }

        public static bool removeUserFromRole(string userId, string roleName)
        {
            //removes the given user from the given role
            var um = new UserManager<ApplicationUser>(
                new UserStore<ApplicationUser>(new ApplicationDbContext()));

            var idResult = um.RemoveFromRole(userId, roleName);

            return idResult.Succeeded;
        }

        public static bool userInRole(string userId, string roleName)
        {
            //checks if the given user is in the given role
            var um = new UserManager<ApplicationUser>(
                new UserStore<ApplicationUser>(new ApplicationDbContext()));
            return um.IsInRole(userId, roleName);
        }

        public static void addRole(string roleName)
        {
            //creates a new role
            var rm = new RoleManager<IdentityRole>(
                new RoleStore<IdentityRole>(new ApplicationDbContext()));
            rm.Create(new IdentityRole(roleName));

        }
        

    }
}