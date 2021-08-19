using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace ICTManagementTool.Controllers
{
    public class ProjectDocumentsController : ApiController
    {

        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/ProjectDocuments
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/ProjectDocuments/5
        public object Get(int projectId)
        {

            var projectDocuments = (from pd in db.ProjectDocuments
                                    where pd.projectID == projectId
                                    && pd.documentSource == "client"
                                    select pd).ToList();

            var additionalDocuments = (from pd in db.ProjectDocuments
                                       where pd.projectID == projectId
                                       && pd.documentSource == "additional"
                                       select pd).ToList();

            List<long> projectDocumentsSizes = new List<long>();

            var pdDetail = projectDocuments.Select(p =>
            new
            {
                p.documentTitle,
                p.documentSource,
                filePath = p.filePath.Replace("~", string.Empty),
                p.projectDocumentID,
                size = new FileInfo(HttpContext.Current.Server.MapPath(p.filePath)).Length
            }).ToList();

            var adDetail = additionalDocuments.Select(p =>
            new
            {
                p.documentTitle,
                p.documentSource,
                filePath = p.filePath.Replace("~", string.Empty),
                p.projectDocumentID,
                size = new FileInfo(HttpContext.Current.Server.MapPath(p.filePath)).Length
            }).ToList();

           
            List<object> returnList = new List<object>();
            returnList.Add(pdDetail);
            returnList.Add(adDetail);

            return returnList;
        }

        // POST: api/ProjectDocuments
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/ProjectDocuments/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/ProjectDocuments/5
        public void Delete(int projectId, string documentTitle)
        {
            var entry = db.ProjectDocuments.Where(x => x.projectID == projectId && x.documentTitle == documentTitle).FirstOrDefault();
            if (entry != null)
            {
                //removes file from disk
                string path = @"~\ProjectFiles\" + entry.projectID + @"\";
                if (!"client".Equals(entry.documentSource)) { path += @"\" + entry.documentSource + @"\"; }
                path += entry.documentTitle;

                string filePath = HttpContext.Current.Server.MapPath(path);
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }


                //removes file from database
                db.ProjectDocuments.Remove(entry);
                db.SaveChanges();



            }
        }
    }
}
