using ICTManagementTool.Helpers;
using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ICTManagementTool.Controllers
{
    public class RoleManagementController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();


        // GET: api/RoleManagement
        public object Get()
        {
            List<object> returnList = new List<object>();

            var users = (from u in db.AspNetUsers
                         select new
                         {
                             u.firstName,
                             u.lastName,
                             fullName = u.firstName + " " + u.lastName,
                             u.Id,
                             u.AspNetRoles

                         }
                            ).OrderBy(p => p.lastName)
                            .ThenBy(p => p.firstName)
                            .ToList();
            returnList.Add(users);

            var roles = (from r in db.AspNetRoles
                         select new
                         {

                             r.Id,
                             r.Name
                         }
                            )
                            .OrderBy(p => p.Name)
                            .ToList();
            returnList.Add(roles);

            return returnList;
        }

        // GET: api/RoleManagement/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/RoleManagement
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/RoleManagement/5
        public void Put(int id, string userId, string roleName)
        {
            //a bit dodgy, but the id allows us to know whether we are adding a user to a role, or creating a new role
            if (id == 1)
            {
                UserRoleHelper.addUserToRole(userId, roleName);
                if ("client".Equals(roleName.ToLower()))
                {
                    var c = db.AspNetUsers.Find(userId);
                    if (c != null)
                    {
                        var client = new Clients();
                        client.clientID = c.personID;
                        db.Clients.Add(client);

                        db.SaveChanges();
                    }
                }
                else if ("staff".Equals(roleName.ToLower()))
                {
                    var s = db.AspNetUsers.Find(userId);
                    if (s != null)
                    {
                        var staff = new Staff();
                        staff.staffID = s.personID;
                        db.Staff.Add(staff);

                        db.SaveChanges();
                    }
                }
            }
            else if (id == 2)
            {
                UserRoleHelper.addRole(roleName);
            }
            else { }

        }

        // DELETE: api/RoleManagement/5
        public void Delete(string userId, string roleName)
        {
            UserRoleHelper.removeUserFromRole(userId, roleName);
            if ("client".Equals(roleName.ToLower()))
            {
                var c = db.AspNetUsers.Find(userId);

                if (null != c)
                {
                    var client = db.Clients.Find(c.personID);
                    db.Clients.Remove(client);
                    db.SaveChanges();
                }
            }
            else if ("staff".Equals(roleName.ToLower()))
            {
                var s = db.AspNetUsers.Find(userId);

                if (null != s)
                {
                    var staff = db.Staff.Find(s.personID);
                    db.Staff.Remove(staff);
                    db.SaveChanges();
                }
            }

        }
    }
}
