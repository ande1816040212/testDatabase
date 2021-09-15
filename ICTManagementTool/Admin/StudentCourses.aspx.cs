using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DocumentFormat.OpenXml;
using Microsoft.AspNet.Identity;
using System.IO;
using System.Data;
using ICTManagementTool.Helpers;
using ICTManagementTool.Models;

namespace ICTManagementTool.Admin
{
    public partial class StudentCourses : System.Web.UI.Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            for (int i = 0; i < 3; i++)
            {
                Year.Items.Insert(Year.Items.Count, new ListItem((DateTime.Now.Year + i).ToString(), (DateTime.Now.Year + i).ToString()));
            }

            //populating the student ddl
            IQueryable<ICTManagementTool.Models.Students> allStudents = new Models.ICTProjectsEntities().Students;

            //adding all students to the ddl
            AllStudents.DataSource = allStudents.ToList();
            AllStudents.DataValueField = "studentID";
            AllStudents.DataTextField = "uniUserName";
            AllStudents.DataBind();

            //adding the heading for the ddl
            AllStudents.Items.Insert(0, new ListItem("-- Select a Student --", "-1"));


            //populating the course ddl

            //adding all courses to the ddl
            IQueryable<ICTManagementTool.Models.Course> ab = new Models.ICTProjectsEntities().Course;
            AllCourses.DataSource = ab.ToList();
            AllCourses.DataValueField = "courseID";
            AllCourses.DataTextField = "courseName";
            AllCourses.DataBind();

            //adding the heading for the ddl
            AllCourses.Items.Insert(0, new ListItem("-- Select a Course --", "-1"));

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //checks if there is someone logged in
            if (null == Context.GetOwinContext().Authentication.User.Identity.GetUserId())
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri, false);
            }
            else
            {
                if (!UserRoleHelper.userInRole(User.Identity.GetUserId(), "Admin"))
                {
                    //redirects the page to the login screen
                    Session["errorMessage"] = "You do not have access to the requested page.";
                    Response.Redirect("~/", false);
                }
            }
        }


        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            var studentCourse = new ICTManagementTool.Models.StudentCourses();
            int studentID;
            var courseID = AllCourses.SelectedValue;
            if (int.TryParse(AllStudents.SelectedValue, out studentID))
            {
                if (studentID != -1)
                {
                    studentCourse.studentID = studentID;
                    studentCourse.courseID = courseID;

                    var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                    ictm.StudentCourses.Add(studentCourse);
                    ictm.SaveChanges();
                    ErrorMessage.Text = "";
                    SuccessMessage.Text = "Student-Course successfully added.";
                }
            }
            else
            {
                SuccessMessage.Text = "";
                ErrorMessage.Text = "An error has occured.";
            }

        }

        protected void ExcelUploadButton_Click(object sender, EventArgs e)
        {
            if (excelUpload.HasFile)
            {
                string uniqueID = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond).ToString();

                string folderPath = Server.MapPath("~/App_Data/ExcelDocuments/StudentCourses/");

                if (!Directory.Exists(folderPath))
                {
                    //If Directory (Folder) does not exists. Create it.
                    Directory.CreateDirectory(folderPath);
                }

                //Save the File to the Directory (Folder).
                string fullFilePath = folderPath + uniqueID + "_" + Path.GetFileName(excelUpload.FileName);
                excelUpload.SaveAs(fullFilePath);

                try
                {
                    DataTable t = ExcelHelper.ExcelToDataTable(fullFilePath);
                    List<string> columnNames = new List<string>()
                    {
                        "Student Id",
                        "Term Desc Medium",
                        "Course Id",
                        "Course Grade Code"
                    };
                    bool containsAllColumns = true;

                    foreach (string columnName in columnNames)
                    {
                        if (!t.Columns.Contains(columnName))
                        {
                            containsAllColumns = false;
                        }
                    }

                    if (containsAllColumns)
                    {
                        DataTable succesfulInserts = t.Clone();
                        DataTable failedInserts = t.Clone();
                        DataTable updatedInserts = t.Clone();

                        //adds extra columns to display additional information
                        failedInserts.Columns.Add("Reason", typeof(string));

                        //puts the desired columns at the start of the table
                        failedInserts.Columns["Reason"].SetOrdinal(0);


                        foreach (DataRow b in t.Rows)
                        {
                            var studentId = b["Student Id"].ToString(); //eg. 110118101
                            var termDescMedium = b["Term Desc Medium"].ToString(); //eg. Study Period 2 - 2016
                            var courseId = b["Course Id"].ToString(); //eg. 012398
                            var courseGradeCode = b["Course Grade Code"].ToString(); //eg. P1, HD
                            var courseName = b["Course Desc Long"].ToString(); //eg. ICT Project
                            var courseCode = b["Subject Area Catalog Number"].ToString(); //eg. INFT3025

                            //convert termDescMedium to seperate values, Semester and year
                            var year = "";
                            var semester = "";
                            //termDescMedium needs to be at least x characters long in order
                            //to derive the year and semester
                            if (termDescMedium.Length >= 21)
                            {
                                year = termDescMedium.Substring(termDescMedium.Length - 4);
                                semester = termDescMedium.Substring(termDescMedium.IndexOf("Study Period ") + 13, 1);

                                int semesterParsed;

                                if (int.TryParse(semester, out semesterParsed))
                                {
                                    semester = "SP" + semesterParsed;

                                    //we good to go
                                    //check if there is already an entry
                                    using (var db = new ICTProjectsEntities())
                                    {

                                        var result = (from sc in db.StudentCourses
                                                      join c in db.Course
                                                      on sc.courseID equals c.courseID
                                                      join s in db.Students
                                                      on sc.studentID equals s.studentID
                                                      where s.uniStudentID == studentId && c.courseID == courseId && sc.semester == semester && sc.year.ToString() == year
                                                      select sc)
                                                      .ToList();

                                        if (result.Count != 0)
                                        {
                                            //update
                                            var studentCourse = result.FirstOrDefault();


                                            studentCourse.semester = semester;

                                            //TODO: actually check if these are numbers
                                            studentCourse.year = int.Parse(year);
                                            studentCourse.courseID = courseId;

                                            //TODO: check if grade is null
                                            studentCourse.grade = courseGradeCode;
                                            db.Entry(studentCourse).State = System.Data.Entity.EntityState.Modified;

                                            db.SaveChanges();


                                            updatedInserts.ImportRow(b);

                                        }
                                        else
                                        {
                                            Course course = null;
                                            var courses = (from c in db.Course
                                                           where c.courseID == courseId
                                                           select c)
                                                      .ToList();
                                            if (courses.Count == 0)
                                            {
                                                Course newCourse = new Course
                                                {
                                                    courseID = courseId,
                                                    courseName = courseName,
                                                    courseCode = courseCode,
                                                    courseAbbreviation = "-"

                                                };
                                                db.Course.Add(newCourse);
                                                db.SaveChanges();
                                                course = newCourse;

                                            }
                                            else
                                            {
                                                course = courses.FirstOrDefault();

                                            }


                                            var studentCourse = new ICTManagementTool.Models.StudentCourses();

                                            var student = (from s in db.Students
                                                           where s.uniStudentID == studentId
                                                           select s
                                                           )
                                                           .ToList();

                                            if (student.Count != 0)
                                            {
                                                //look up student with the studentId
                                                studentCourse.studentID = student.FirstOrDefault().studentID;
                                                studentCourse.semester = semester;

                                                //TODO: actually check if these are numbers
                                                studentCourse.year = int.Parse(year);
                                                studentCourse.courseID = course.courseID;

                                                //TODO: check if grade is null
                                                studentCourse.grade = courseGradeCode;

                                                var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                                                ictm.StudentCourses.Add(studentCourse);
                                                ictm.SaveChanges();

                                                succesfulInserts.ImportRow(b);
                                            }
                                            else
                                            {
                                                //student does not exist in the database
                                                failedInserts.ImportRow(b);
                                                failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = "Student does not exist in the database";
                                            }




                                        }
                                    }



                                }
                                else
                                {
                                    failedInserts.ImportRow(b);
                                    failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = "Semester is bad";
                                }



                            }
                            else
                            {
                                failedInserts.ImportRow(b);
                                failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = "Term Desc Medium needs to be longer";

                            }












                        }

                        //show output div
                        failedInserts.AcceptChanges();
                        succesfulInserts.AcceptChanges();
                        updatedInserts.AcceptChanges();

                        //configuring the successful GridView
                        SuccessfulInserts.DataSource = succesfulInserts;
                        SuccessfulInserts.DataBind();
                        if (0 != succesfulInserts.Rows.Count)
                        {
                            SuccessfulInserts.HeaderRow.TableSection = TableRowSection.TableHeader;
                        }

                        //configuring the updated GridView
                        UpdatedInserts.DataSource = updatedInserts;
                        UpdatedInserts.DataBind();
                        if (0 != updatedInserts.Rows.Count)
                        {
                            UpdatedInserts.HeaderRow.TableSection = TableRowSection.TableHeader;
                        }


                        //configuring the failed GridView
                        FailedInserts.DataSource = failedInserts;
                        FailedInserts.DataBind();
                        if (0 != failedInserts.Rows.Count)
                        {
                            FailedInserts.HeaderRow.TableSection = TableRowSection.TableHeader;
                        }
                        divOutput.Visible = true;
                        divOutputText.Visible = false;


                    }
                    else
                    {
                        //columns are missing
                        divOutput.Visible = false;
                        divOutputText.Visible = true;
                        labelOutput.InnerText = "One or more of the required columns is missing from the excel upload";
                    }


                }
                catch (System.ArgumentException a)
                {
                    System.Diagnostics.Debug.WriteLine(a.Message);
                }





            }
        }
    }
}