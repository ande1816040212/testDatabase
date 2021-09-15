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
    public class ProjectStatusController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ProjectStatus
        public object GetProjectStatus()
        {
            return (from ps in db.ProjectStatus
                    select new 
                    {
                        statusId = ps.ProjectStatusId,
                        statusName = ps.StatusName
                    }).ToList();
        }

        // GET: api/ProjectStatus/5
        [ResponseType(typeof(ProjectStatus))]
        public IHttpActionResult GetProjectStatus(int id)
        {
            ProjectStatus projectStatus = db.ProjectStatus.Find(id);
            if (projectStatus == null)
            {
                return NotFound();
            }

            return Ok(projectStatus);
        }

        // PUT: api/ProjectStatus/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjectStatus(int id, ProjectStatus projectStatus)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != projectStatus.ProjectStatusId)
            {
                return BadRequest();
            }

            db.Entry(projectStatus).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProjectStatusExists(id))
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

        // POST: api/ProjectStatus
        [ResponseType(typeof(ProjectStatus))]
        public IHttpActionResult PostProjectStatus(ProjectStatus projectStatus)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.ProjectStatus.Add(projectStatus);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = projectStatus.ProjectStatusId }, projectStatus);
        }

        // DELETE: api/ProjectStatus/5
        [ResponseType(typeof(ProjectStatus))]
        public IHttpActionResult DeleteProjectStatus(int id)
        {
            ProjectStatus projectStatus = db.ProjectStatus.Find(id);
            if (projectStatus == null)
            {
                return NotFound();
            }

            db.ProjectStatus.Remove(projectStatus);
            db.SaveChanges();

            return Ok(projectStatus);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ProjectStatusExists(int id)
        {
            return db.ProjectStatus.Count(e => e.ProjectStatusId == id) > 0;
        }
    }
}