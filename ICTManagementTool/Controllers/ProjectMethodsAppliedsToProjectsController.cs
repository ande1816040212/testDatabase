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
    public class ProjectMethodsAppliedsToProjectsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ProjectMethodsAppliedsToProjects
        public IQueryable<ProjectMethodsApplied> GetProjectMethodsApplied()
        {
            return db.ProjectMethodsApplied;
        }


        // PUT: api/ProjectMethodsAppliedsToProjects/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjectMethodsApplied(int id, ProjectMethodsApplied projectMethodsApplied)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != projectMethodsApplied.projectID)
            {
                return BadRequest();
            }

            db.Entry(projectMethodsApplied).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProjectMethodsAppliedExists(id))
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

    

        // DELETE: api/ProjectMethodsAppliedsToProjects/5
        [ResponseType(typeof(ProjectMethodsApplied))]
        public IHttpActionResult DeleteProjectMethodsApplied(int id)
        {
            ProjectMethodsApplied projectMethodsApplied = db.ProjectMethodsApplied.Find(id);
            if (projectMethodsApplied == null)
            {
                return NotFound();
            }

            db.ProjectMethodsApplied.Remove(projectMethodsApplied);
            db.SaveChanges();

            return Ok(projectMethodsApplied);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ProjectMethodsAppliedExists(int id)
        {
            return db.ProjectMethodsApplied.Count(e => e.projectID == id) > 0;
        }
    }
}