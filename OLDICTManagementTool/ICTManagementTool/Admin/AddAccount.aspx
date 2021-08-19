<%@ Page Title="Add Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddAccount.aspx.cs" Inherits="ICTManagementTool.Admin.AddAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Add Account</h2>

    <asp:DropDownList runat="server" EnableViewState="false" CssClass="form-control" ClientIDMode="static" ID="DDLUserType">
        <asp:ListItem Value="">-- Select Account Type --</asp:ListItem>
        <asp:ListItem Value="student">Student</asp:ListItem>
        <asp:ListItem Value="client">Client</asp:ListItem>
        <asp:ListItem Value="staff">Staff</asp:ListItem>
    </asp:DropDownList>



    <hr />
    <div>
        This page will allow any administrators to add a single user to the website.  Select and account type to get started!
    </div>


    <%-- User Name --%>
    <div class="form-group student staff client row" style="display: none">

        <label class="control-label col-sm-2" for="UserName">User Name:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" class="form-control" ID="TBUsername" placeholder="Enter Student University User Name" MaxLength="12" />
        </div>
        <div class="col-sm-1">
            <asp:RequiredFieldValidator runat="server" ControlToValidate="TBUsername" Font-Size="Large" ForeColor="Red" ErrorMessage="You must enter a username" Text="*" ValidationGroup="Student"></asp:RequiredFieldValidator>
        </div>
    </div>

    <%-- Title --%>
    <div class="form-group student staff client row" style="display: none">
        <asp:Label runat="server" AssociatedControlID="DDLTitle" CssClass="col-md-2 control-label">Title</asp:Label>
        <div class="col-md-10">
            <asp:DropDownList runat="server" EnableViewState="false" ID="DDLTitle" ClientIDMode="Static" CssClass="form-control">
                <asp:ListItem Value="">Title</asp:ListItem>
                <asp:ListItem>Assoc. Prof</asp:ListItem>
                <asp:ListItem>Dr</asp:ListItem>
                <asp:ListItem>Prof</asp:ListItem>
                <asp:ListItem>Mr</asp:ListItem>
                <asp:ListItem>Ms</asp:ListItem>
                <asp:ListItem>Mrs</asp:ListItem>
                <asp:ListItem Value="other">Other</asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox runat="server" placeholder="Title. . ." CssClass="form-control" ID="TBTitle" Style="display: none" ClientIDMode="Static"></asp:TextBox>
        </div>
        <script>
            $('#DDLTitle').on('change', function () {
                if ($(this).val() == 'other') {
                    $('#TBTitle').show().val('');
                } else {
                    $('#TBTitle').val($(this).val()).hide();

                }
            })
        </script>
    </div>

    <%-- First Name --%>
    <div class="form-group student staff client row" style="display: none">
        <label class="control-label col-sm-2" for="TBFirstName">First Name:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" class="form-control" ID="TBFirstName" placeholder="Enter Student First Name" />
        </div>
    </div>

    <%-- Family Name --%>
    <div class="form-group student staff client row" style="display: none">
        <label class="control-label col-sm-2" for="TBLastName">Last Name:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" class="form-control" ID="TBLastName" ClientIDMode="static" placeholder="Enter Student Family Name" />
        </div>

    </div>

    <%-- Email --%>
    <div class="form-group student staff client row" style="display: none">
        <asp:Label runat="server" AssociatedControlID="TBEmail" CssClass="col-md-2 control-label">Email</asp:Label>
        <div class="col-md-9">
            <asp:TextBox runat="server" ID="TBEmail" ClientIDMode="static" CssClass="form-control" TextMode="Email" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="TBEmail"
                CssClass="text-danger" ErrorMessage="The email field is required." />
        </div>
        <div class="col-sm-1">
            <asp:RegularExpressionValidator ID="REVEmail" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="TBEmail" Font-Size="Large" ForeColor="Red" ErrorMessage="Invalid email format" Text="*"></asp:RegularExpressionValidator>
        </div>
    </div>


    <%-- Phone number --%>
    <div class="form-group student staff client row" style="display: none">
        <label class="control-label col-sm-2" for="TBPhoneNumber">Phone No:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" class="form-control" ID="TBPhoneNumber" placeholder="Enter Phone Number" MaxLength="12" />
        </div>

        <div class="col-sm-1">
            <asp:CompareValidator runat="server" Operator="DataTypeCheck" Type="Integer" ControlToValidate="TBPhoneNumber" Font-Size="Large" ForeColor="Red" ErrorMessage="Phone number must be a number" Text="*" ValidationGroup="Student"></asp:CompareValidator>
        </div>
    </div>

    <%-- Student ID --%>
    <div class="form-group row student" style="display: none">
        <label class="control-label col-sm-2" for="TBStudentID">Student ID:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" class="form-control" ID="TBStudentID" placeholder="Enter Student ID" MaxLength="12" />
        </div>
        <div class="col-sm-1">
            <asp:RequiredFieldValidator runat="server" ControlToValidate="TBStudentID" Font-Size="Large" ForeColor="Red" ErrorMessage="You must enter a student id" Text="*" ValidationGroup="Student"></asp:RequiredFieldValidator>
        </div>
    </div>


    <%-- Program Code --%>
    <div class="form-group row student" style="display: none">
        <label class="control-label col-sm-2" for="Plan">Plan:</label>
        <div class="col-sm-9">
            <asp:DropDownList runat="server" CssClass="form-control DDLPlans" ID="DDLPlans">
            </asp:DropDownList>
        </div>
    </div>

    <%-- GPA --%>
    <div class="form-group row student" style="display: none">
        <label class="control-label col-sm-2" for="GPA">GPA:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" TextMode="Number" class="form-control" ID="TBGPA" step="0.01" />
        </div>
    </div>

    <%-- Company Name --%>
    <div class="form-group row client" style="display: none">
        <label class="control-label col-sm-2" for="TBCompany">Company:</label>
        <div class="col-sm-9">
            <asp:TextBox runat="server" ClientIDMode="static" class="form-control" ID="TBCompany" placeholder="Company Name" />
        </div>
    </div>

    <%-- Submit Button --%>
    <div class="form-group client staff student row" style="display: none">
        <div class="col-sm-offset-2 col-sm-9">
            <asp:Button runat="server" class="btn btn-default" Text="Add Account" ID="SubmitStudent" OnClick="AddAccount_Click" />
        </div>
    </div>





    <script src="AddAccount.js"></script>


</asp:Content>
