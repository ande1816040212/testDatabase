using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool.Allocation
{
    public partial class ProjectStudentEmail : System.Web.UI.Page
    {
        Models.ICTProjectsEntities ictp = new Models.ICTProjectsEntities();
        int year = System.DateTime.Now.Year;
        int month = System.DateTime.Now.Month;
        string sem = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            sem = month <= 3 ? "SP2" : "SP5";
        }

        protected void BSendEmail_Click(object sender, EventArgs e)
        {
            var pIDs = Request.Form["projectIDs"].Split(',').Select<string, int>(int.Parse).ToArray();


            //var projects = (from p in ictp.Projects
            //                where p.projectYear == year
            //                && p.projectSemester == sem
            //                && !string.IsNullOrEmpty(p.projectCode)
            //                join ppa in ictp.ProjectPeopleAllocations
            //                on p.projectID equals ppa.projectID
            //                join s in ictp.Students
            //                on ppa.personID equals s.studentID
            //                select p)
            //                .GroupBy(p => p.projectID)
            //                .Select(p => p.FirstOrDefault())
            //                .ToList();

            var projects = (from p in ictp.Projects
                            where pIDs.Contains(p.projectID)
                            select p).ToList();

            //foreach (var p in projects)
            //{
            //    if (String.IsNullOrEmpty(p.projectCode)) throw new Exception("Missing project code: ProjectID: " + p.projectID);
            //}

            foreach (var p in projects)
            {
                try
                {
                    var studentList = (from s in ictp.Students
                                       join pp in ictp.ProjectPeopleAllocations
                                       on s.studentID equals pp.personID
                                       where pp.projectID == p.projectID
                                       join u in ictp.AspNetUsers
                                       on s.studentID equals u.personID
                                       select new
                                       {
                                           s.studentEmail,
                                           u.firstName,
                                           u.lastName
                                       }
                   ).ToList();

                    var staffList = (from pp in ictp.ProjectPeopleAllocations
                                     where pp.projectID == p.projectID
                                     && pp.personRole == "staff"
                                     join u in ictp.AspNetUsers
                                     on pp.personID equals u.personID
                                     select new
                                     {
                                         pp.personID,
                                         u.Email,
                                         u.title,
                                         u.firstName,
                                         u.lastName
                                     }
               ).ToList();

                    var clientDetail = (from u in ictp.AspNetUsers
                                        where u.personID == p.projectCreatorID
                                        select u).FirstOrDefault();

                    var docs = (from pd in ictp.ProjectDocuments
                                where pd.projectID == p.projectID
                                && pd.documentSource == "client"
                                select pd)
                                .ToList();

                    var additionalDocs = (from pd in ictp.ProjectDocuments
                                          where pd.projectID == p.projectID
                                          && pd.documentSource != "client"
                                          select pd)
                                .ToList();

                    // TODO, if project code empty abort.

                    var subject = p.projectCode + " " + TBSubject.Text;
                    var to = studentList.Select(s => s.studentEmail).ToArray();

                    string body = Request.Unvalidated.Form["TBBody"];
                    body = body.Replace("[year]", System.DateTime.Now.Year.ToString());

                    string project = "<p><strong>Project Code:</strong> " + p.projectCode + "</p>";
                    project += "<p><strong>Project Title:</strong> " + p.projectTitle + "</p>";
                    if(docs.Count == 0)
                    {
                        project += "<p><strong>Brief scope:</strong> " + p.projectScope + "</p>";
                    }

                    body = body.Replace("[project]", project);

                    string client = "<p><strong>Client(s):</strong> ";

                    // TODO/Temp
                    //var badIDs = new int[] { 1126, 1127 };
                    //if (badIDs.Any(b => b == clientDetail.personID))
                    //{
                    //    client += "<strong>Insufficient Information Provided.  Please email me.</strong>";
                    //}
                    //else
                    //{
                        client += clientDetail.title + ". " + clientDetail.firstName + " " + clientDetail.lastName + " (" + clientDetail.Email + ")";
                    //}

                    client += "</p>";
                    body = body.Replace("[client]", client);


                    string staff = "<p><strong>Academic Supervisor(s):</strong> ";
                    //if (staffList.Any(sl => sl.personID == 1126))
                    //{
                    //    staff += "<strong>Insufficient Information Provided.  Please email me</strong>";
                    //}
                    //else
                    //{
                        foreach (var s in staffList)
                        {
                            staff += s.title + ". " + s.firstName + " " + s.lastName + " (" + s.Email + "), ";
                        }
                    //}

                    staff += "</p>";
                    body = body.Replace("[staff]", staff);

                    string student = "<p><strong>Group Members:</strong></p>";
                    student += "<ul>";
                    foreach (var s in studentList)
                    {
                        student += "<li>" + s.firstName + " " + s.lastName + " (" + s.studentEmail + ")" + "</li>";
                    }
                    student += "</ul>";

                    body = body.Replace("[student]", student);

                    string docText = "<p><strong>Documents:</strong> ";
                    docText += (docs != null && docs.Count > 0) ? "See attached files." : "There are no client documents.  You will need to consult the client for further detail on your project.";
                    docText += "</p>";

                    string additionalDocText = string.Empty;
                    if (additionalDocs.Count > 0)
                    {
                        additionalDocText = "<p><strong>Additional Documents:</strong> ";
                        additionalDocText += "Please read the additional " + (additionalDocs.Count == 1 ? "document" : (additionalDocs.Count + "documents ")) + "provided for this project.  They are attached so that you can understand what has been developed thus far.";
                        additionalDocText += "</p>";
                    }

                    body = body.Replace("[document]", docText);
                    body = body.Replace("[additionalDocuments]", additionalDocText);

                    var msg = body;

                    docs.AddRange(additionalDocs);

                    // body = "Email To: " + String.Join("; ", to) + body + "<br />";

                    //to = new[] { "doug@kellyaustralia.com" };

                    sendEmail(to, subject, msg, true, docs.ToArray());

                    var sEmailed = ictp.Projects.Find(p.projectID);
                    sEmailed.studentEmailSentDate = System.DateTime.Now;
                    ictp.SaveChanges();
                }

                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("FAIL: (" + p.projectID + ") " + p.projectCode);
                    System.Diagnostics.Debug.WriteLine(ex.Message + Environment.NewLine + Environment.NewLine);
                }
            }

        }

        public void sendEmail(string[] to = null, string subject = "", string body = "", bool isBodyHtml = false, ProjectDocuments[] projectDocuments = null)
        {
            MailAddress david = new MailAddress("David.Harris@unisa.edu.au", "David Harris");
            MailAddress stemICTProject = new MailAddress("**yourTestEmailAcct.com", "displayName");

            // MailAddress emily = new MailAddress("Emily.Sellar@unisa.edu.au", "Emily Sellar");
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress("**YourOwnGmailAccount.com**", "UniSA ICT Projects");
                mail.ReplyToList.Add(stemICTProject);
                //mail.CC.Add(david);
                mail.CC.Add(stemICTProject);
                mail.Priority = MailPriority.High;
                //mail.To.Add(david);
                foreach (var t in to)
                {
                    mail.To.Add(t);
                }
                mail.Subject = subject;
                mail.Body = body;


                mail.IsBodyHtml = isBodyHtml;
                if (projectDocuments != null)
                {
                    foreach (ProjectDocuments pDoc in projectDocuments)
                    {
                        string fileDir = HttpContext.Current.Server.MapPath(pDoc.filePath);

                        Attachment attch = new Attachment(fileDir, MediaTypeNames.Application.Octet);

                        attch.ContentDisposition.CreationDate = System.IO.File.GetCreationTime(fileDir);
                        attch.ContentDisposition.ModificationDate = System.IO.File.GetLastWriteTime(fileDir);
                        attch.ContentDisposition.ReadDate = System.IO.File.GetLastAccessTime(fileDir);

                        mail.Attachments.Add(attch);
                    }
                }



                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.Credentials = new NetworkCredential("**YourOwnGmailAccount.com**", "yourPassword*");
                    smtp.EnableSsl = true;
                    smtp.Timeout = 1200000;
                    smtp.Send(mail);
                }
            }
        }

        public System.Collections.IEnumerable RProjectList_GetData()
        {
            var projects = (from p in ictp.Projects
                            where p.projectYear == year
                            && p.projectSemester == sem
                            && p.projectStatus == 5 // allocated
                            select new StaffProjectDetail
                            {
                                project = p,
                                staffCount = ictp.ProjectPeopleAllocations.Where(ppa => ppa.projectID == p.projectID && ppa.personRole == "staff").Count(),
                                studentCount = ictp.ProjectPeopleAllocations.Where(ppa => ppa.projectID == p.projectID && ppa.personRole == "student").Count(),
                                staffEmailed = p.staffEmailSentDate.HasValue,
                                studentEmailed = p.studentEmailSentDate.HasValue
                            }
                            )
                            .OrderBy(p => p.studentEmailed)
                            .ThenBy(p => !p.staffEmailed)
                            .ThenBy(p => p.project.projectCode)
                            .ToList();

            foreach (StaffProjectDetail spd in projects)
            {
                var staffList = (from ppa in ictp.ProjectPeopleAllocations
                                 where ppa.projectID == spd.project.projectID
                                 && ppa.personRole == "staff"
                                 join person in ictp.AspNetUsers
                                 on ppa.personID equals person.personID
                                 select new { name = person.firstName + " " + person.lastName }
                                         ).ToList();

                // generate comma separated list of staff names
                spd.staff = string.Join(", ", staffList.Select(p => p.name));
            }

            projects = projects.Where(p => p.studentCount > 0 && p.staffCount > 0).ToList();

            return projects;
        }

        public class StaffProjectDetail
        {
            public Models.Projects project { get; set; }
            public int staffCount { get; set; }
            public string staff { get; set; }
            public int studentCount { get; set; }
            public bool staffEmailed { get; set; }
            public bool studentEmailed { get; set; }
        }

    }
}