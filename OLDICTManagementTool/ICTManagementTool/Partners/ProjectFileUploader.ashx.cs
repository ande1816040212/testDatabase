using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace ICTManagementTool.Partners
{
    /// <summary>
    /// Summary description for ProjectFileUploader
    /// </summary>
    public class ProjectFileUploader : IHttpHandler
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        //https://codepedia.info/using-dropzone-js-file-image-upload-in-asp-net-webform-c/
        public void ProcessRequest(HttpContext context)
        {
            string projectIdString = context.Request.QueryString["projectId"];
            string docSource = context.Request.QueryString["docSource"];

            if (string.IsNullOrEmpty(docSource)) { docSource = "client"; }
            //checks if the string is empty or null
            if (!String.IsNullOrEmpty(projectIdString))
            {

                int projectId;
                //trys to convert the given projectId to an int
                if (int.TryParse(projectIdString, out projectId))
                {
                    string relPath = "~/ProjectFiles/" + projectId + "/" + (("client" != docSource) ? docSource + "/" : string.Empty);
                    string dirFullPath = HttpContext.Current.Server.MapPath(relPath);

                    //not sure if this first create directory is needed
                    //if the directory already exists, it doesn't do anything
                    //so no harm having it in
                    System.IO.Directory.CreateDirectory(dirFullPath);


                    context.Response.ContentType = "text/plain";


                    string[] files;
                    files = System.IO.Directory.GetFiles(dirFullPath);

                    string fileName = "";

                    foreach (string s in context.Request.Files)
                    {
                        HttpPostedFile file = context.Request.Files[s];

                        string fileExtension = file.ContentType;

                        fileName = file.FileName;

                        if (!string.IsNullOrEmpty(fileName))
                        {
                            //This commented out block handles overriding

                            if (System.IO.File.Exists(dirFullPath + "\\" + fileName))
                            {
                                //overrides documents with the same name
                                //could either not save
                                //or change the name by appending a number
                                file.SaveAs(dirFullPath + "\\" + fileName);

                            }
                            else
                            {
                                file.SaveAs(dirFullPath + "\\" + fileName);

                                //only need to add to database when it doesnt override
                                ProjectDocuments toAdd = new Models.ProjectDocuments
                                {
                                    projectID = projectId,
                                    documentLink = fileName,
                                    documentTitle = fileName,
                                    documentSource = docSource,
                                    filePath = relPath + fileName
                                };
                                db.ProjectDocuments.Add(toAdd);
                                db.SaveChanges();
                            }





                        }
                    }
                    context.Response.Write(fileName);

                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}