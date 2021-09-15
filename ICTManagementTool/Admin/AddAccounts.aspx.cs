using System;
using System.Linq;
using System.Web;
using System.IO;
using System.Data;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using ICTManagementTool.Models;
using ICTManagementTool.Helpers;
using System.Web.UI.WebControls;
using System.Data.Entity.Validation;

namespace ICTManagementTool.Admin
{
    public partial class AddAccounts : System.Web.UI.Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            for (int i = 0; i < 3; i++)
            {
                Year.Items.Insert(Year.Items.Count, new ListItem((DateTime.Now.Year + i).ToString(), (DateTime.Now.Year + i).ToString()));
            }
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


        protected void UploadButton_Click(object sender, EventArgs e)
        {
            if (excelUpload.HasFile)
            {
                string uniqueID = (DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond).ToString();

                string folderPath = Server.MapPath("~/App_Data/ExcelDocuments/AddAccounts/");

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
                    //clone copies the structure but not the rows
                    DataTable succesfulInserts = t.Clone();
                    DataTable failedInserts = t.Clone();
                    DataTable updatedInserts = t.Clone();
                    failedInserts.Columns.Add("Reason", typeof(string));
                    updatedInserts.Columns.Add("Columns Changed", typeof(string));
                    failedInserts.Columns["Reason"].SetOrdinal(0);
                    updatedInserts.Columns["Columns Changed"].SetOrdinal(0);

                    //fix GPA decimal places
                    if (t.Columns.Contains("Current GPA"))
                    {
                        foreach (DataRow b in t.Rows)
                        {
                            try
                            {
                                //TODO: validate the uniusername
                                string studentUsername;
                                if (b["Student Email Address"].ToString().Replace("@mymail.unisa.edu.au", "").Length > 12)
                                {
                                    studentUsername = b["Student Email Address"].ToString().Replace("@mymail.unisa.edu.au", "").Substring(0, 12);
                                }
                                else
                                {
                                    studentUsername = b["Student Email Address"].ToString().Replace("@mymail.unisa.edu.au", "");
                                }

                                //this fixed the floating point issue of GPA's
                                b["Current GPA"] = Math.Round(double.Parse(b["Current GPA"].ToString()), 2);


                                //first need to create an AspNetUser
                                var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                                //manager.FindByName(b["Student Email Address"].ToString()));
                                #region insert student
                                //if there is no current account with the given email
                                if (null == manager.FindByName(studentUsername))
                                {
                                    var user = new ApplicationUser()
                                    {
                                        UserName = studentUsername,
                                        Email = b["Student Email Address"].ToString(),
                                        firstName = b["Student First Name"].ToString(),
                                        lastName = b["Student Family Name"].ToString(),
                                        dateCreated = System.DateTime.Now
                                    };
                                    try
                                    {
                                        IdentityResult result = manager.Create(user, (studentUsername + b["Student Id"].ToString()));


                                        if (result.Succeeded)
                                        {
                                            var student = new ICTManagementTool.Models.Students();

                                            using (var db = new ICTProjectsEntities())
                                            {
                                                var s = db.AspNetUsers.Find(user.Id);
                                                student.studentID = s.personID;



                                                student.uniUserName = studentUsername;
                                                student.studentEmail = user.Email;
                                                student.uniStudentID = b["Student Id"].ToString();
                                                student.genderCode = Convert.ToString(b["Gender Code"]);
                                                student.international = Convert.ToString(b["International Student Flag"]);
                                                student.gpa = decimal.Parse(b["Current GPA"].ToString());
                                                student.externalStudent = "Off-Site Location".Equals(Convert.ToString(b["Location Desc Medium"]).Trim());

                                                student.year = int.Parse(Year.SelectedValue);
                                                student.semester = Semester.Value;

                                                var plan = Convert.ToString(b["Program Plan"]);
                                                var planId = (from a in db.Plans
                                                              where a.planCode == plan
                                                              select a.planId).ToArray().FirstOrDefault();

                                                student.planId = planId;


                                                var studentComment = new ICTManagementTool.Models.PeopleComments();

                                                studentComment.comment = "Successfully added from Excel";
                                                studentComment.commentPersonID = db.AspNetUsers.Find(User.Identity.GetUserId()).personID;
                                                studentComment.personID = student.studentID;
                                                studentComment.commentDate = DateTime.Now;


                                                var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                                                ictm.Students.Add(student);
                                                ictm.PeopleComments.Add(studentComment);
                                                ictm.SaveChanges();
                                            }


                                            succesfulInserts.ImportRow(b);

                                            //adds users to the Student role
                                            UserRoleHelper.addUserToRole(user.Id, "Student");


                                        }
                                        else
                                        {
                                            failedInserts.ImportRow(b);
                                            failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = result.Errors.FirstOrDefault();
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        failedInserts.ImportRow(b);
                                        failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = ex.Message;
                                        if (ex is DbEntityValidationException)
                                        {
                                            var e2 = ex as DbEntityValidationException;
                                            foreach (var eve in e2.EntityValidationErrors)
                                            {
                                                var s1 = eve.Entry.Entity.GetType().Name;
                                                string s2 = "";
                                                foreach (var ve in eve.ValidationErrors)
                                                {
                                                    s2 = ve.PropertyName + " - " + ve.ErrorMessage;
                                                }
                                                failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] += Environment.NewLine + s1 + Environment.NewLine + s2;
                                            }
                                        }
                                    }
                                }
                                #endregion
                                #region update student
                                //if there is an account already with the given email
                                else
                                {
                                    string columnsChanged = "";
                                    ApplicationUser user = manager.FindByName(studentUsername);

                                    //if statments to check each attribute of the DB.AspNetUsers
                                    if (user.firstName != b["Student First Name"].ToString())
                                    {
                                        user.firstName = b["Student First Name"].ToString();
                                        columnsChanged += "Student First Name, ";
                                    }
                                    if (user.lastName != b["Student Family Name"].ToString())
                                    {
                                        user.lastName = b["Student Family Name"].ToString();
                                        columnsChanged += "Student Family Name, ";
                                    }


                                    manager.Update(user);

                                    int userPersonID;
                                    using (var db = new ICTProjectsEntities())
                                    {
                                        var s = db.AspNetUsers.Find(user.Id);
                                        userPersonID = s.personID;

                                        var result = db.Students.Where(stud => stud.studentID == userPersonID);

                                        var studentRecord = result.FirstOrDefault();


                                        if (null != studentRecord)
                                        {
                                            //if statements to check each attribute of DB.Students
                                            if (studentRecord.uniStudentID != b["Student Id"].ToString())
                                            {
                                                studentRecord.uniStudentID = b["Student Id"].ToString();
                                                columnsChanged += "Uni Student ID, ";
                                            }

                                            if (studentRecord.gpa != decimal.Parse(b["Current GPA"].ToString()))
                                            {
                                                studentRecord.gpa = decimal.Parse(b["Current GPA"].ToString());
                                                columnsChanged += "Current GPA, ";
                                            }

                                            if (studentRecord.genderCode != Convert.ToString(b["Gender Code"]))
                                            {
                                                studentRecord.genderCode = Convert.ToString(b["Gender Code"]);
                                            }

                                            if (studentRecord.international != Convert.ToString(b["International Student Flag"]))
                                            {
                                                studentRecord.international = Convert.ToString(b["International Student Flag"]);
                                            }

                                            if (studentRecord.studentEmail != Convert.ToString(b["Student Email Address"]))
                                            {
                                                studentRecord.studentEmail = Convert.ToString(b["Student Email Address"]);
                                            }

                                            studentRecord.externalStudent = "Off-Site Location".Equals(Convert.ToString(b["Location Desc Medium"]).Trim());


                                            var planFromFile = b["Program Plan"].ToString();

                                            int planId = (from a in db.Plans
                                                          where a.planCode == planFromFile
                                                          select a.planId).ToArray().FirstOrDefault();

                                            if (planId == 0)
                                            {
                                                //TODO:
                                                //check that the "no-plan" plan exists in the database
                                                planId = (from a in db.Plans
                                                          where a.planName == "No plan"
                                                          select a.planId).ToArray().FirstOrDefault();

                                            }

                                            if (studentRecord.planId != planId)
                                            {
                                                studentRecord.planId = planId;
                                                columnsChanged += "Plan Id, ";
                                            }
                                            if (studentRecord.year != int.Parse(Year.SelectedValue))
                                            {
                                                studentRecord.year = int.Parse(Year.SelectedValue);
                                                columnsChanged += "Year, ";
                                            }
                                            if (studentRecord.semester != Semester.Value)
                                            {
                                                studentRecord.semester = Semester.Value;
                                                columnsChanged += "Semester, ";
                                            }

                                        }


                                        db.SaveChanges();
                                        //if no columns have changed
                                        if ("" == columnsChanged)
                                        {

                                            var studentComment = new ICTManagementTool.Models.PeopleComments();

                                            studentComment.comment = "Duplicate excel upload attempt";
                                            studentComment.commentPersonID = db.AspNetUsers.Find(User.Identity.GetUserId()).personID;
                                            studentComment.personID = userPersonID;
                                            studentComment.commentDate = DateTime.Now;

                                            var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                                            ictm.PeopleComments.Add(studentComment);
                                            ictm.SaveChanges();

                                            failedInserts.ImportRow(b);
                                            failedInserts.Rows[failedInserts.Rows.Count - 1]["Reason"] = "Duplicate user in system";
                                        }
                                        //if at least one column has changed
                                        else
                                        {
                                            //trims off the ,
                                            columnsChanged = columnsChanged.Substring(0, columnsChanged.Length - 2);
                                            var studentComment = new ICTManagementTool.Models.PeopleComments();


                                            studentComment.comment = "Successfully updated columns: " + columnsChanged;
                                            studentComment.commentPersonID = db.AspNetUsers.Find(User.Identity.GetUserId()).personID;
                                            studentComment.personID = userPersonID;
                                            studentComment.commentDate = DateTime.Now;

                                            var ictm = new ICTManagementTool.Models.ICTProjectsEntities();
                                            ictm.PeopleComments.Add(studentComment);
                                            ictm.SaveChanges();
                                            updatedInserts.ImportRow(b);
                                            updatedInserts.Rows[updatedInserts.Rows.Count - 1]["Columns Changed"] = columnsChanged;
                                        }
                                    }



                                }
                                #endregion
                            }
                            catch (Exception ex)
                            {
                                //TODO
                                System.Diagnostics.Debug.WriteLine(ex.StackTrace);

                            }

                        }
                    }

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

                }
                catch (System.ArgumentException a)
                {
                    System.Diagnostics.Debug.WriteLine(a.Message);
                }
            }







        }





    }
}