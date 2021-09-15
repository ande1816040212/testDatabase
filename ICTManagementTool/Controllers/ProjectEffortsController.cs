using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ICTManagementTool.Controllers
{
    public class ProjectEffortsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ProjectEfforts
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/ProjectEfforts/5
        public object Get(int projectId)
        {
            List<object> returnList = new List<object>();

            var projectEffortsApplied = (from pea in db.ProjectEffortsApplied
                                         join pe in db.ProjectEfforts
                                         on pea.effortID equals pe.effortID
                                         where pea.projectID == projectId
                                         select new
                                         {
                                             pea.comment,
                                             effort = new { pe.effortID, pe.effortDescription},
                                             pea.hours
                                         });

            returnList.Add(projectEffortsApplied);


            var allProjectEfforts = from pe in db.ProjectEfforts
                                    orderby pe.effortRankValue descending, pe.effortDescription
                                    select new
                                    {
                                        pe.effortDescription,
                                        pe.effortID
                                    };
            returnList.Add(allProjectEfforts);


            var allClients = from c in db.Clients
                              join p in db.AspNetUsers
                              on c.clientID equals p.personID
                              orderby p.lastName, p.firstName ascending
                              select new
                              {
                                  c.clientID,
                                  clientName = p.title + ". " + p.firstName + " " + p.lastName,
                                  c.companyName
                              };

            returnList.Add(allClients);

            var currentClientId = (from p in db.Projects
                                  where p.projectID == projectId
                                  select new
                                  {
                                      clientID = p.projectCreatorID
                                  }).FirstOrDefault();

            returnList.Add(currentClientId);

            return returnList;
        }

        // POST: api/ProjectEfforts
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/ProjectEfforts/5
        public void Put(int projectId, int clientId, ProjectEffortsApplied[] projectEfforts)
        {
            var projectEffortsToRemove = db.ProjectEffortsApplied.Where(p => p.projectID == projectId);

            foreach (var projectEffortToRemove in projectEffortsToRemove)
            {
                db.ProjectEffortsApplied.Remove(projectEffortToRemove);
            }
            db.SaveChanges();

            foreach (var a in projectEfforts)
            {
                db.ProjectEffortsApplied.Add(
                    new ProjectEffortsApplied
                    {
                        comment = a.comment,
                        hours = a.hours,
                        effortID = a.effortID,
                        projectID = projectId
                    });
                db.SaveChanges();


            }

            //change of project owner
            if (clientId != -1)
            {
                var project = db.Projects.Find(projectId);
                project.projectCreatorID = clientId;
                db.SaveChanges();
            }


        }

        // DELETE: api/ProjectEfforts/5
        public void Delete(int id)
        {
        }
    }
}
