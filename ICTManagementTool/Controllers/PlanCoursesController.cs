using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ICTManagementTool.Models;
using System.Data.Entity.Infrastructure;


namespace ICTManagementTool.Controllers
{
    public class PlanCoursesController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/PlanCourses
        public object Get()
        {
            List<object> returnList = new List<object>();

            var plans = (from p in db.Plans
                         select new
                         {
                             p.durationYears,
                             p.planCode,
                             p.planId,
                             p.planName,
                             PlanCourses = (
                             from pc in db.PlanCourses
                             join c in db.Course
                             on pc.courseId equals c.courseID
                             where pc.planId == p.planId
                             select new
                             {
                                 pc.courseId,
                                 pc.planId,
                                 c.courseName
                             }
                             )



                         }).ToList();



            var courses = (from c in db.Course
                           select new
                           {
                               c.courseCode,
                               courseId = c.courseID,
                               c.courseName

                           });

            returnList.Add(plans);
            returnList.Add(courses);


            return returnList;
        }

        // GET: api/PlanCourses/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/PlanCourses
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/PlanCourses/5
        public void Put(string id, int planId, string courseId)
        {

            if (null == db.PlanCourses.Find(planId, courseId))
            {
                var a = new PlanCourses
                {
                    courseId = courseId,
                    planId = planId
                };

                db.PlanCourses.Add(a);

                try
                {
                    db.SaveChanges();
                }
                catch (DbUpdateException)
                {
                    throw;
                }
            }



        }

        // DELETE: api/PlanCourses/5
        public void Delete(int planId, string courseId)
        {
            PlanCourses planCourse = db.PlanCourses.Where(pc => pc.planId == planId && pc.courseId == courseId).FirstOrDefault();
            if (planCourse == null)
            {
                return;
            }

            db.PlanCourses.Remove(planCourse);

            db.SaveChanges();
        }
    }
}
