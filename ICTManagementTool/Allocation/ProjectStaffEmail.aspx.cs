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
    public partial class ProjectStaffEmail : System.Web.UI.Page
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
            //int i = 0;

            foreach (var p in projects)
            {
                if (String.IsNullOrEmpty(p.projectCode)) throw new Exception("Missing project code: ProjectID: " + p.projectID);
            }

            foreach (var p in projects)
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
                                       s.uniStudentID,
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
                            select pd)
                            .ToArray();

                // TODO, if project code empty abort.

                var subject = p.projectCode + " " + TBSubject.Text;
                var to = staffList.Select(s => s.Email).ToArray();

                string body = Request.Unvalidated.Form["TBBody"];

                // body = "Email To: " + String.Join("; ", to) + body + "<br />";

                //to = new[] { "doug@kellyaustralia.com" };

                body = body.Replace("[year]", System.DateTime.Now.Year.ToString());

                string project = "<p><strong>Project Code:</strong> " + p.projectCode + "</p>";
                project += "<p><strong>Project Title:</strong> " + p.projectTitle + "</p>";
                if (docs.Count() == 0)
                {
                    project += "<p><strong>Brief scope:</strong> " + p.projectScope + "</p>";
                }

                body = body.Replace("[project]", project);

                string client = "<p><strong>Client(s):</strong> ";
                client += clientDetail.title + ". " + clientDetail.firstName + " " + clientDetail.lastName + " (" + clientDetail.Email + ")" + "</p>";
                body = body.Replace("[client]", client);

                string staff = "<p><strong>Academic Supervisor(s):</strong> ";
                foreach (var s in staffList)
                {
                    staff += s.title + ". " + s.firstName + " " + s.lastName + " (" + s.Email + "), ";
                }
                staff += "</p>";
                body = body.Replace("[staff]", staff);

                string student = "<p><strong>Group Members:</strong></p>";
                student += "<ul>";
                foreach (var s in studentList)
                {
                    student += "<li>" + s.firstName + " " + s.lastName + " <a href=\"https://my.unisa.edu.au/Staff/Teaching/Students/Program.aspx?sid=" + s.uniStudentID + "\" target=\"_blank\">(Student Record)</a>, " + s.studentEmail + "</li>";
                }
                student += "</ul>";

                body = body.Replace("[student]", student);

                string docText = "<p><strong>Documents:</strong> ";
                docText += (docs != null && docs.Length > 0) ? "See attached files." : "There are no available documents.";
                docText += "</p>";

                body = body.Replace("[document]", docText);

                var msg = body;

                //to = new string[] {"Grant.Wigley@unisa.edu.au" };

                sendEmail(to, subject, msg, true, docs);

                var sEmailed = ictp.Projects.Find(p.projectID);
                sEmailed.staffEmailSentDate = System.DateTime.Now;
                ictp.SaveChanges();
            }

        }

        // TODO: Use Email Helper function in Helpers folder
        public void sendEmail(string[] to = null, string subject = "", string body = "", bool isBodyHtml = false, ProjectDocuments[] projectDocuments = null)
        {
            MailAddress david = new MailAddress("David.Harris@unisa.edu.au", "David Harris");
            MailAddress stemICTProject = new MailAddress("**yourTestEmailAcct.com", "displayName");

            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress("**YourOwnGmailAccount.com**", "UniSA ICT Projects");
                mail.ReplyToList.Add(stemICTProject);
                mail.CC.Add(stemICTProject);
                //mail.CC.Add(nicole);
                mail.Priority = MailPriority.High;

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
                                staffEmailed = p.staffEmailSentDate.HasValue
                            }
                            )
                            .OrderBy (p => p.staffEmailed)
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
        }
    }
}