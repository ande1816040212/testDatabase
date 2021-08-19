using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ICTManagementTool.Controllers
{
    public class EffortManagementController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/EffortManagement
        public object Get()
        {
            var efforts = (from e in db.ProjectEfforts
                           orderby e.effortRankValue descending, e.effortDescription
                           select
                           new
                           {
                               e.effortDescription,
                               e.effortID,
                               e.effortRankValue
                           });

            return efforts;
        }

        // GET: api/EffortManagement/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/EffortManagement
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/EffortManagement/5
        public object Put(int id, string effortDescription, int effortRankValue)
        {
            if (effortDescription != "" && effortDescription != null)
            {
                db.ProjectEfforts.Add(new ProjectEfforts { effortDescription = effortDescription, effortRankValue = effortRankValue });
                db.SaveChanges();
            }

            var efforts = (from e in db.ProjectEfforts
                           orderby e.effortRankValue descending, e.effortDescription
                           select
                           new
                           {
                               e.effortDescription,
                               e.effortID,
                               e.effortRankValue
                           });

            return efforts;

        }

        // PUT: api/EffortManagement/5
        public object Put(int id, int effortId, int effortRankValue)
        {
            db.ProjectEfforts.Find(effortId).effortRankValue = effortRankValue;
            db.SaveChanges();

            var efforts = (from e in db.ProjectEfforts
                           orderby e.effortRankValue descending, e.effortDescription
                           select
                           new
                           {
                               e.effortDescription,
                               e.effortID,
                               e.effortRankValue
                           });

            return efforts;
        }

        // DELETE: api/EffortManagement/5
        public void Delete(int id, int effortId)
        {
            db.ProjectEfforts.Remove(db.ProjectEfforts.Find(effortId));
            db.SaveChanges();
        }
    }
}
