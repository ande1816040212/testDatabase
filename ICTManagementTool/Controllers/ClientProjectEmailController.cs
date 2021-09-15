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
    public class ClientProjectEmailController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ClientProjectEmail
        public IQueryable<Projects> GetProjects()
        {
            return db.Projects;
        }

        // GET: api/ClientProjectEmail/5
        [ResponseType(typeof(Projects))]
        public IHttpActionResult GetProjects(int id)
        {
            Projects projects = db.Projects.Find(id);
            if (projects == null)
            {
                return NotFound();
            }

            return Ok(projects);
        }

        // PUT: api/ClientProjectEmail/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutProjects(int id, bool emailed)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var projects = db.Projects.Find(id);
            if(emailed) { projects.clientEmailSentDate = System.DateTime.Now; }
            else { projects.clientEmailSentDate = null; }

            db.Entry(projects).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProjectsExists(id))
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


        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool ProjectsExists(int id)
        {
            return db.Projects.Count(e => e.projectID == id) > 0;
        }
    }
}