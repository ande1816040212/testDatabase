<%@ Page Title="Add Accounts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddAccounts.aspx.cs" Inherits="ICTManagementTool.Admin.AddAccounts" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Add Accounts</h2>

    <div class="form-horizontal">
        <p>Adding multiple accounts is done by uploading a excel file.</p>

        <select runat="server" onchange="multipleUserTypeChange()" class="form-control userTypeSelect">
            <option value="">-- Select Account Type --</option>
            <option value="student">Student</option>
            <option value="client">Client</option>
            <option value="staff">Staff</option>
        </select>



        <hr />

        <div runat="server" class="divStudent" style="display: none">

            <p>This file must contain the following fields:</p>

            <ul runat="server" id="StudentList">
                <li>Student Email Address</li>
                <li>Student Id</li>
            </ul>

            <label class="control-label" for="Year">Year:</label>

            <asp:DropDownList runat="server" CssClass="form-control DDLYear" Style="width: auto;" ID="Year">
            </asp:DropDownList>


            <label class="control-label" for="Semester">Semester:</label>
            <select runat="server" class="form-control" id="Semester" style="width: auto;">
                <option>SP2</option>
                <option>SP5</option>
            </select>

            <br />




        </div>

        <div runat="server" class="divClient" style="display: none">

            <p>Adding of clients has not been implemented yet.</p>

        </div>

        <div runat="server" class="divStaff" style="display: none">

            <p>Adding of staff has not been implemented yet.</p>

        </div>

        <div class="divControls" style="display: none">

            <label class="btn btn-default" runat="server">
                <asp:FileUpload runat="server" Style="display: none;" ID="excelUpload" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" onchange="$('#upload-file-info').html(this.files[0].name);" />
                Browse...
            </label>

            <span id="upload-file-info">No file selected.</span>
            <asp:RequiredFieldValidator ID="requiredExcelValidator" runat="server" ControlToValidate="excelUpload" ErrorMessage="You must upload a file." Text="* You must upload a file." ForeColor="Red"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="regexValidator" runat="server" ControlToValidate="excelUpload" ErrorMessage="Only excel documents are allowed" Text="* Only excel files are allowed." ValidationExpression="^.*\.(xls|xlsx|csv)$" ForeColor="Red"></asp:RegularExpressionValidator>

            <br />
            <br />

            <asp:Button class="btn btn-default" runat="server" OnClick="UploadButton_Click" ID="UploadButton" Text="Submit File" />
        </div>

        <div class="divOutput" id="divOutput" runat="server" visible="false">
            <h2>Output</h2>
            <h3>Successful:</h3>
            <div style="overflow-x: auto; width: 100%; max-height: 600px">

                <asp:GridView ID="SuccessfulInserts" runat="server" EmptyDataText="No successful inserts" CssClass="table table-hover table-striped" UseAccessibleHeader="true">
                </asp:GridView>
            </div>
            <h3>Updated:</h3>
            <div style="overflow-x: auto; width: 100%; max-height: 600px">

                <asp:GridView ID="UpdatedInserts" runat="server" EmptyDataText="No updated inserts" CssClass="table table-hover table-striped" UseAccessibleHeader="true">
                </asp:GridView>
            </div>

            <h3>Unsuccessful:</h3>
            <div style="overflow-x: auto; width: 100%; max-height: 600px">
                <asp:GridView ID="FailedInserts" runat="server" EmptyDataText="No failed inserts" CssClass="table table-hover table-striped" UseAccessibleHeader="true">
                </asp:GridView>
            </div>
        </div>


    </div>


    <script src="AddAccounts.js"></script>
</asp:Content>
