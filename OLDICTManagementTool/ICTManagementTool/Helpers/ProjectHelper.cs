using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ICTManagementTool.Helpers
{
    public class ProjectHelper
    {

        //method to check for status with given name
        //if status doesn't exist, create a status with that name
        //returns id of the status
        public static int getProjectStatusIdFromName(string name)
        {
            IQueryable<ICTManagementTool.Models.ProjectStatus> projectStatus = new Models.ICTProjectsEntities().ProjectStatus;

            int projStatus = projectStatus.Where(ps => ps.StatusName == name).Select(ps => ps.ProjectStatusId).ToList().FirstOrDefault();
            if (0 == projStatus)
            {
                var status = new ICTManagementTool.Models.ProjectStatus();

                status.StatusName = name;
                
                var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                var newStatus = ictm.ProjectStatus.Add(status);
                ictm.SaveChanges();
                
                projStatus = newStatus.ProjectStatusId;
            }

            
            return projStatus;
        }

        public static string getProjectNameFromId(int id)
        {
            //finds the name of the given statusId
            //returns the name, or null if not found

            IQueryable<ICTManagementTool.Models.ProjectStatus> projectStatus = new Models.ICTProjectsEntities().ProjectStatus;

            return projectStatus.Where(ps => ps.ProjectStatusId == id).Select(ps => ps.StatusName).ToList().FirstOrDefault();
        }




    }
}