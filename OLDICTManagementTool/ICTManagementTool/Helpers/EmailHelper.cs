using ICTManagementTool.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;

namespace ICTManagementTool.Helpers
{
    public class EmailHelper
    {

        //optional parameters
        //more parameters can be added when dealing with other document types
        static public void sendEmail(string[] to = null, string subject = "", string body = "", bool isBodyHtml = false, ProjectDocuments[] projectDocuments = null)
        {
            using (MailMessage mail = new MailMessage())
            {
                mail.From = new MailAddress("YourEmailPlease@gmail.com", "University of South Australia");

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
                        string fileDir = HttpContext.Current.Server.MapPath("~/ProjectFiles\\" + pDoc.projectID + "\\" + pDoc.documentTitle);

                        Attachment attch = new Attachment(fileDir, MediaTypeNames.Application.Octet);

                        attch.ContentDisposition.CreationDate = System.IO.File.GetCreationTime(fileDir);
                        attch.ContentDisposition.ModificationDate = System.IO.File.GetLastWriteTime(fileDir);
                        attch.ContentDisposition.ReadDate = System.IO.File.GetLastAccessTime(fileDir);

                        mail.Attachments.Add(attch);
                    }
                }


                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.Credentials = new NetworkCredential("YourEmailPlease@gmail.com", "YourPasswordPlease!");
                    smtp.EnableSsl = true;
                    smtp.Send(mail);
                }
            }
        }

        static public Attachment createAttachment()
        {


            return null;
        }


    }
}