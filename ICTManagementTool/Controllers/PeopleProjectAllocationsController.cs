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
using Microsoft.AspNet.Identity.Owin;

namespace ICTManagementTool.Controllers
{
    public class PeopleProjectAllocationsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/PeopleProjectAllocations
        public object GetProjectPeopleAllocations(int year, string sem)
        {
            if (sem == null)
            {
                sem = System.DateTime.Now.Month < 4 ? "sp2" : "sp5";
            }

            List<object> returnArray = new List<object>();

            /* NOTES
             * Need to very wary of how much data we send back
             * For example, do not need to include students that have a value in 'dateEnded'
             */


            var students = (from s in db.Students
                            join au in db.AspNetUsers
                            on s.studentID equals au.personID
                            join p in db.Plans
                            on s.planId equals p.planId
                            // join ppa in db.ProjectPeopleAllocations
                            // on au.personID equals ppa.personID
                            // into a
                            //join pj in db.Projects
                            //on ppa.projectID equals pj.projectID
                            // into leftJoin
                            // from a in leftJoin.DefaultIfEmpty()
                            select new
                            {
                                //defining all of these properties does two things:
                                //1. reduces the size of the object that we return
                                //2. removes the need to access the variables using s.* in angularjs
                                //   basically; flattens the object.
                                s.studentID,
                                s.gpa,
                                s.dateEnded,
                                s.semester,
                                s.uniStudentID,
                                s.uniUserName,
                                s.year,
                                s.planId,
                                p.planCode,
                                p.planName,
                                p.projectDuration,
                                s.genderCode,
                                s.externalStudent,
                                s.international,
                                fullName = au.firstName + " " + au.lastName,
                                role = "student",
                                // test = a.Where(px => px.sem)
                                //allocated = a.Any(),
                                allocated =
                                (from pr in db.Projects
                                 join ppa in db.ProjectPeopleAllocations
                                 on pr.projectID equals ppa.projectID
                                 where pr.projectYear == year
                                 && pr.projectSemester == sem
                                 && ppa.personID == s.studentID
                                 && ppa.personRole == "student"
                                 select p).Count() > 0,
                    

                                //all courses that the student has taken
                                courses = (from sc in db.StudentCourses
                                           join c in db.Course
                                           on sc.courseID equals c.courseID
                                           where sc.studentID == s.studentID
                                           select new
                                           {
                                               c.courseID,
                                               c.courseName,
                                               sc.grade,
                                               //this line creates a numeric representation of the grade ie. HD=7 etc
                                               courseScore = sc.grade == "HD" ? 7 : (sc.grade == "D" ? 6 : (sc.grade == "C" ? 5 : (sc.grade == "P1" ? 4 : (sc.grade == "P2" ? 3 : (sc.grade == "F1" ? 2 : (sc.grade == "F2" ? 1 : 0))))))
                                           }),

                            }
                            )
                            .Where(p => p.year == year)
                            .Where(p => p.semester.ToLower() == sem.ToLower())
                            .ToList();

            var staff = (from s in db.Staff
                         join au in db.AspNetUsers
                         on s.staffID equals au.personID
                         //join ppa in db.ProjectPeopleAllocations
                         //on au.personID equals ppa.personID
                         //into a
                         select new
                         {
                             s.dateEnded,
                             s.staffID,
                             s.uniStaffID,
                             s.username,
                             fullName = au.firstName + " " + au.lastName,
                             role = "staff",
                             //allocated = a.Any(),
                             //allocatedCount = a.Count()
                             allocated = (from ppa in db.ProjectPeopleAllocations
                                          join p in db.Projects
                                          on ppa.projectID equals p.projectID
                                          where ppa.personID == s.staffID
                                          && p.projectYear == year
                                          && p.projectSemester == sem
                                          select ppa).Any(),
                             allocatedCount = (from ppa in db.ProjectPeopleAllocations
                                               join p in db.Projects
                                               on ppa.projectID equals p.projectID
                                               where ppa.personID == s.staffID
                                               && p.projectYear == year
                                               && p.projectSemester == sem
                                               select ppa).Count()
                         }
                         )
                         .ToList();

            var plans = (from p in db.Plans
                         select new
                         {
                             p.planName,
                             p.planId,
                             p.planCode,
                             p.PlanCourses,
                             courses = (from pc in db.PlanCourses
                                        join c in db.Course
                                        on pc.courseId equals c.courseID
                                        where pc.planId == p.planId
                                        select new
                                        {
                                            c.courseAbbreviation,
                                            c.courseID,
                                            c.courseName
                                        }
                                        )
                                        .ToList(),
                         }
                        )
                        .ToList();

            returnArray.Add(students);
            returnArray.Add(staff);
            returnArray.Add(plans);

            return returnArray;
        }

        // GET: api/PeopleProjectAllocations/5
        [ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult GetProjectPeopleAllocations(int id)
        {
            ProjectPeopleAllocations projectPeopleAllocations = db.ProjectPeopleAllocations.Find(id);
            if (projectPeopleAllocations == null)
            {
                return NotFound();
            }

            return Ok(projectPeopleAllocations);
        }

        // PUT: api/PeopleProjectAllocations/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjectPeopleAllocations(string id, int personId, int projectId, string role)
        {

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var a = new ProjectPeopleAllocations
            {
                projectID = projectId,
                personID = personId,
                personRole = role,
                creatorID = db.AspNetUsers.Find(RequestContext.Principal.Identity.GetUserId()).personID,
                dateCreated = DateTime.Now
            };

            db.ProjectPeopleAllocations.Add(a);

            var comment = new PeopleComments
            {
                personID = personId,
                commentDate = DateTime.Now,
                commentPersonID = db.AspNetUsers.Find(RequestContext.Principal.Identity.GetUserId()).personID,
                comment = "Added to project: " + projectId + " - " + db.Projects.Find(projectId).projectTitle

            };

            db.PeopleComments.Add(comment);


            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                throw;
            }

            return CreatedAtRoute("DefaultApi", new { id = a.projectID }, a);
        }

        // POST IS NOT USED
        // POST: api/PeopleProjectAllocations
        [ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult PostProjectPeopleAllocations(string id, int personId, int projectId, string role)
        {

            return null;
        }

        // DELETE: api/PeopleProjectAllocations/5
        [ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult DeleteProjectPeopleAllocations(int userId, string projectId)
        {
            ProjectPeopleAllocations allocation = db.ProjectPeopleAllocations.Where(al => al.personID == userId && al.projectID.ToString() == projectId).FirstOrDefault();
            if (allocation == null)
            {
                return NotFound();
            }

            db.ProjectPeopleAllocations.Remove(allocation);

            var comment = new PeopleComments
            {
                personID = userId,
                commentDate = DateTime.Now,
                commentPersonID = db.AspNetUsers.Find(RequestContext.Principal.Identity.GetUserId()).personID,
                //TODO:
                //put project name instead of projectId
                //maybe a link
                comment = "Removed from project with projectId:" + projectId

            };

            db.PeopleComments.Add(comment);

            db.SaveChanges();

            return Ok(allocation);
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