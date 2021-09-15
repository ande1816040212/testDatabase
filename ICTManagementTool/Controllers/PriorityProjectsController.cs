using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using ICTManagementTool.Models;
using Microsoft.AspNet.Identity;

namespace ICTManagementTool.Controllers
{
    public class PriorityProjectsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();


        public object GetPriorityProjects(int year, string sem)
        {

            var projects = (from p in db.Projects
                            where p.projectYear == year
                            && p.projectSemester.ToLower() == sem.ToLower()
                            select new
                            {
                                Id = p.Id,
                                projectId = p.projectID,
                                projectTitle = p.projectTitle,
                                dateCreated = p.dateCreated,
                                projectStatus = p.projectStatus,
                                projectSequenceNo = p.projectSequenceNo,
                                p.projectYear,
                                p.projectSemester,
                                recentPriority = (from pp in db.PriorityProjects
                                                  where pp.projectID == p.projectID
                                                  orderby pp.dateCreated descending
                                                  select new
                                                  {
                                                      pp.priorityLevel,
                                                      pp.priorityReason

                                                  }).FirstOrDefault(),
                            }).OrderBy(p => p.projectSequenceNo)
                          .ToList();

            return projects;
        }


        // PUT: api/PriorityProjects/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjects(Projects[] projects)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {

                for (int i = 0; i < projects.Length; i++)
                {
                    Projects a = db.Projects.Find(projects[i].projectID);
                    if (a != null)
                    {
                        a.projectSequenceNo = i + 1;
                    }
                }
                db.SaveChanges();


            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e);
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // PUT: api/PriorityProjects/5
        [ResponseType(typeof(void))]
        public void PutProjects(int projectId, string priorityLevel, string priorityReason)
        {

            if (!ModelState.IsValid)
            {
                return;
            }

            try
            {
                //reason for checking this is because you cant send a null object from the webpage
                //so it automatically converts the null object to a string "null" or "undefined"
                if (priorityReason == "undefined" | priorityReason == "null")
                {
                    priorityReason = null;
                }

                var mostRecentEntry = (from pp in db.PriorityProjects
                                       where pp.projectID == projectId
                                       orderby pp.dateCreated descending
                                       select pp).FirstOrDefault();

                //checks if the entry that is going to be inserted isnt the same as the most recent entry for that 
                if (mostRecentEntry != null)
                {
                    if (mostRecentEntry.priorityReason == priorityReason && mostRecentEntry.priorityLevel == priorityLevel)
                    {
                        return;
                    }
                    else
                    {
                        mostRecentEntry.priorityLevel = priorityLevel;
                        mostRecentEntry.priorityReason = priorityReason;
                        //mostRecentEntry.dateCreated = System.DateTime.Now;
                        mostRecentEntry.priorityCreatorID = db.AspNetUsers.Find(RequestContext.Principal.Identity.GetUserId()).personID;
                        db.Entry(mostRecentEntry).State = EntityState.Modified;
                        db.SaveChanges();
                    }
                }
                else
                {
                    var toInsert = new Models.PriorityProjects
                    {
                        priorityLevel = priorityLevel,
                        projectID = projectId,
                        priorityReason = priorityReason,
                        dateCreated = DateTime.Now,
                        priorityCreatorID = db.AspNetUsers.Find(RequestContext.Principal.Identity.GetUserId()).personID,
                    };
                    db.PriorityProjects.Add(toInsert);

                    db.SaveChanges();
                }


            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e);
            }

            return;
        }


        //POST: api/PriorityProjects
        //[ResponseType(typeof(PriorityProjects))]
        public IHttpActionResult PostProjects(Models.PriorityProjects project)
        {

            return null;
        }

        // DELETE: api/PriorityProjects/5
        [ResponseType(typeof(Projects))]
        public IHttpActionResult DeleteProjects(int id)
        {
            return null;
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

    }


}