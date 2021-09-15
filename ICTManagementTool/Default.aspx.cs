using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ICTManagementTool
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["errorMessage"] != null)
            {
                messageBox.Visible = true;

                messageText.InnerHtml = Session["errorMessage"].ToString();
                
                Session.Remove("errorMessage");
            }
            else
            {
                messageBox.Visible = false;
            }
        }
    }
}