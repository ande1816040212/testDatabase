using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Data.Entity;
using Microsoft.AspNet.Identity;
using ICTManagementTool.Helpers;


namespace ICTManagementTool.Controllers
{
    public class ProjectManagementController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

            // GET api/<controller>
        public object Get()
        {
            List<object> returnList = new List<object>();

            var userId = User.Identity.GetUserId();
            var personId = db.AspNetUsers.Find(userId).personID;
            

            if (UserRoleHelper.userInRole(userId, "Admin"))
            {
                var projects = (from p in db.Projects
                                select new
                                {
                                    Id = p.Id,
                                    projectId = p.projectID,
                                    projectTitle = p.projectTitle,
                                    dateCreated = p.dateCreated,
                                    projectStatus = p.projectStatus,
                                    projectYear = p.projectYear,
                                    projectSemester = p.projectSemester

                                })
                          .ToList();
                returnList.Add(projects);

            }
            else
            {
                var projects = (from p in db.Projects
                                where p.projectCreatorID == personId
                                select new
                                {
                                    Id = p.Id,
                                    projectId = p.projectID,
                                    projectTitle = p.projectTitle,
                                    dateCreated = p.dateCreated,
                                    projectStatus = p.projectStatus,
                                    projectYear = p.projectYear,
                                    projectSemester = p.projectSemester

                                })
                          .ToList();
                returnList.Add(projects);

            }





            var statusList = (from s in db.ProjectStatus
                              select new
                              {
                                  statusId = s.ProjectStatusId,
                                  statusName = s.StatusName
                              }
                

                ).ToList();

            returnList.Add(statusList);

            return returnList;
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, int projectId, int statusId)
        {
            db.Projects.Find(projectId).projectStatus = statusId;
            db.SaveChanges();
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}