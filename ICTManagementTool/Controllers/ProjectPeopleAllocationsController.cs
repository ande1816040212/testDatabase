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

namespace ICTManagementTool.Controllers
{
    public class ProjectPeopleAllocationsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ProjectPeopleAllocations
        public object GetProjectPeopleAllocations()
        {

            // NOTE a priority project may have multiple entries in the PriorityProjects table
            // this code should ideally get the last matching record (but it doesnt)
            // hence can end up with duplicates showing.
            var projects = (from p in db.Projects
                            join ppa in db.ProjectPeopleAllocations
                            on p.projectID equals ppa.projectID into gj1
                            join pp in db.PriorityProjects
                            on p.projectID equals pp.projectID into gj2
                            from allPriorityProjects in gj2.DefaultIfEmpty()
                            select new
                            {
                                p.Id,
                                p.projectID,
                                p.projectTitle,
                                projectSequenceNumber = p.projectSequenceNo,
                                priorityProjects = allPriorityProjects,
                                p.projectYear,
                                p.projectSemester,
                                p.projectStatus,
                                p.projectDuration,
                                p.honoursUndergrad,
                                p.scholarshipAmt,
                                p.scholarshipDetail,
                                p.austCitizenOnly,
                                p.studentsReq,
                                p.projectCode,
                                //clientEmailSentDate = p.clientEmailSentDate.HasValue ? p.clientEmailSentDate.Value.ToLongDateString() + " " + p.clientEmailSentDate.Value.ToShortTimeString() : string.Empty,
                                //staffEmailSentDate = p.staffEmailSentDate.HasValue ? p.staffEmailSentDate.Value.ToLongDateString() + " " + p.clientEmailSentDate.Value.ToShortTimeString() : string.Empty,
                                //studentEmailSentDate = p.studentEmailSentDate.HasValue ? p.studentEmailSentDate.Value.ToLongDateString() + " " + p.clientEmailSentDate.Value.ToShortTimeString() : string.Empty,
                                p.clientEmailSentDate,
                                p.staffEmailSentDate,
                                p.studentEmailSentDate,
                                statusName = (from ps in db.ProjectStatus
                                              where ps.ProjectStatusId == p.projectStatus
                                              select ps.StatusName).FirstOrDefault(),

                                companyName = (from c in db.Clients
                                               join p2 in db.Projects
                                               on c.clientID equals p2.projectCreatorID
                                               where p2.projectID == p.projectID
                                                             && !string.IsNullOrEmpty(c.companyName)
                                               select c.companyName).FirstOrDefault(),

                                staff = (from ppa in db.ProjectPeopleAllocations
                                         where ppa.projectID == p.projectID
                                         && ppa.personRole == "staff"
                                         join ppl in db.AspNetUsers
                                         on ppa.personID equals ppl.personID
                                         join s in db.Staff
                                         on ppa.personID equals s.staffID
                                         orderby ppl.lastName, ppl.firstName
                                         select new
                                         {
                                             Id = ppl.Id,
                                             fullName = ppl.firstName + " " + ppl.lastName,
                                             personID = ppl.personID,
                                             staff = s,
                                             allocatedProjectCount = (from ppa in db.ProjectPeopleAllocations where ppa.personID == s.staffID select ppa).Count(),

                                         }).ToList(),

                                students = (from ppa in db.ProjectPeopleAllocations
                                            where ppa.projectID == p.projectID
                                            && ppa.personRole == "student"
                                            join ppl in db.AspNetUsers
                                            on ppa.personID equals ppl.personID
                                            join s in db.Students
                                            on ppa.personID equals s.studentID
                                            join p in db.Plans
                                            on s.planId equals p.planId
                                            orderby ppl.lastName, ppl.firstName
                                            select new
                                            {
                                                Id = ppl.Id,
                                                fullName = ppl.firstName + " " + ppl.lastName,
                                                personID = ppl.personID,
                                                student = s,
                                                p.planCode,
                                                p.projectDuration,
                                                s.genderCode,
                                                s.externalStudent,
                                                s.international,
                                                allocatedProjectCount = (from ppa in db.ProjectPeopleAllocations where ppa.personID == s.studentID select ppa).Count()

                                            }).ToList()

                            })
                            .OrderBy(p => p.projectStatus > 3) // ignore rejected, postpone, postgrad, UOA
                          .ThenBy(p => p.projectSequenceNumber)
                          .ToList();

            return projects;
        }

        // GET: api/ProjectPeopleAllocations/5
        [ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult GetProjectPeopleAllocation(int id)
        {
            ProjectPeopleAllocations projectPeopleAllocation = db.ProjectPeopleAllocations.Find(id);
            if (projectPeopleAllocation == null)
            {
                return NotFound();
            }

            return Ok(projectPeopleAllocation);
        }

        // PUT: api/ProjectPeopleAllocations/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjectPeopleAllocation(int id, ProjectPeopleAllocations projectPeopleAllocation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != projectPeopleAllocation.projectID)
            {
                return BadRequest();
            }

            db.Entry(projectPeopleAllocation).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProjectPeopleAllocationExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/ProjectPeopleAllocations
        [ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult PostProjectPeopleAllocation(ProjectPeopleAllocations projectPeopleAllocation)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ProjectPeopleAllocations.Add(projectPeopleAllocation);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (ProjectPeopleAllocationExists(projectPeopleAllocation.projectID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = projectPeopleAllocation.projectID }, projectPeopleAllocation);
        }


        // Controller to match
        //[HttpGet]
        //[Route("")]
        //[Route("{pr}/{po}/{role}")]
        //[ResponseType(typeof(ProjectPeopleAllocations))]
        public IHttpActionResult DeleteProjectPeopleAllocation(int pr, int po, string role)
        {
            //not sure if this code is ever used
            ProjectPeopleAllocations projectPeopleAllocation = db.ProjectPeopleAllocations.Find(
                new
                {
                    projectID = pr,
                    personID = po,
                    personRole = role
                });

            if (projectPeopleAllocation == null)
            {
                return NotFound();
            }

            db.ProjectPeopleAllocations.Remove(projectPeopleAllocation);
            db.SaveChanges();

            return Ok(projectPeopleAllocation);
        }


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ProjectPeopleAllocationExists(int id)
        {
            return db.ProjectPeopleAllocations.Count(e => e.projectID == id) > 0;
        }
    }



}
