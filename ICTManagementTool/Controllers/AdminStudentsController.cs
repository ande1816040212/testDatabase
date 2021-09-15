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
    public class AdminStudentsController : ApiController
    {
        private ICTProjectsEntities db = new ICTProjectsEntities();

        // GET: api/AdminStudents?sp=2
        public object GetStudents()
        {
            var students = (from s in db.Students
                            join au in db.AspNetUsers
                            on s.studentID equals au.personID
                            select new
                            {
                                s,
                                studentName = au.firstName + " " + au.lastName,
                                au.personID
                            }
                            )
                            .OrderBy(p => p.s.uniUserName)
                            .ToList();
            return students;
        }

        // GET: api/AdminStudents/5
        [ResponseType(typeof(Students))]
        public IHttpActionResult GetStudents(int id)
        {
            Students students = db.Students.Find(id);
            if (students == null)
            {
                return NotFound();
            }

            return Ok(students);
        }

        // PUT: api/AdminStudents/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutStudents(int id, Students students)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != students.studentID)
            {
                return BadRequest();
            }

            db.Entry(students).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StudentsExists(id))
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

        // POST: api/AdminStudents
        [ResponseType(typeof(Students))]
        public IHttpActionResult PostStudents(Students students)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Students.Add(students);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (StudentsExists(students.studentID))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = students.studentID }, students);
        }

        // DELETE: api/AdminStudents/5
        [ResponseType(typeof(Students))]
        public void DeleteStudents(int personId, int studentId)
        {
            Students student = db.Students.Find(studentId);
            if (student == null)
            {
                return;
            }
            
            AspNetUsers user = db.AspNetUsers.Where(p => p.personID == personId).FirstOrDefault();
            if (user == null)
            {
                return;
            }
            
            //have to do this stupid thing because the database wont allow some cascades to be implemented
            db.StudentCourses.RemoveRange(db.StudentCourses.Where(x => x.studentID == studentId));
            db.SaveChanges();
            db.PeopleComments.RemoveRange(db.PeopleComments.Where(x => x.commentPersonID == studentId || x.personID == studentId));
            db.SaveChanges();
            db.ProjectPeopleAllocations.RemoveRange(db.ProjectPeopleAllocations.Where(x => x.creatorID == studentId || x.personID == studentId));
            db.SaveChanges();
            //db.StudentCourses.RemoveRange(db.StudentCourses.Where(x => x.studentID == studentId));
            //db.SaveChanges();
            db.StudentProjectRanking.RemoveRange(db.StudentProjectRanking.Where(x => x.studentID == studentId));
            db.SaveChanges();
            db.Students.Remove(student);
            db.SaveChanges();
            db.AspNetUsers.Remove(user);
            db.SaveChanges();

        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool StudentsExists(int id)
        {
            return db.Students.Count(e => e.studentID == id) > 0;
        }
    }
}