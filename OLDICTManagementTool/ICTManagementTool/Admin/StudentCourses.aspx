<%@ Page Title="Student Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentCourses.aspx.cs" Inherits="ICTManagementTool.Admin.StudentCourses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Link Students To Courses</h2>

    <p>Linking students to courses can be done either manually or by uploading an excel document.</p>

    <asp:DropDownList CssClass="form-control userTypeSelect" ID="UserTypeSelect" runat="server"
        AutoPostBack="False" onchange="typeChange()">
        <asp:ListItem Value="">-- Select Account Type --</asp:ListItem>
        <asp:ListItem Value="manual">Manual</asp:ListItem>
        <asp:ListItem Value="excel">Excel File</asp:ListItem>
    </asp:DropDownList>

    <hr />
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>
    <p class="text-success">
        <asp:Literal runat="server" ID="SuccessMessage" />
    </p>

    <div runat="server" class="form-horizontal manualDiv" id="ManualDiv" style="display: none">

        <div class="form-group">
            <label class="control-label col-sm-2" for="AllStudents">Student:</label>
            <div class="col-sm-10">

                <asp:DropDownList runat="server" CssClass="form-control allStudents" ID="AllStudents" AutoPostBack="False" onchange="validateButton()">
                </asp:DropDownList>

            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-2" for="AllCourses">Course:</label>
            <div class="col-sm-10">

                <asp:DropDownList runat="server" CssClass="form-control allCourses" ID="AllCourses" AutoPostBack="False" onchange="validateButton()">
                </asp:DropDownList>

            </div>
        </div>


        <%-- Year --%>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Year">Year:</label>
            <div class="col-sm-10">

                <asp:DropDownList runat="server" CssClass="form-control DDLYear" ID="Year">
                </asp:DropDownList>
            </div>
        </div>

        <%-- Semester --%>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Semester">Semester:</label>
            <div class="col-sm-10">
                <select runat="server" class="form-control" id="Semester">
                    <option>SP2</option>
                    <option>SP5</option>
                </select>
            </div>
        </div>


        <%-- Mark --%>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Mark">Mark:</label>
            <div class="col-sm-10">
                <input runat="server" type="number" class="form-control markInput" id="Mark" step="0.1" max="1000.0">
            </div>
        </div>


        <%-- Grade --%>
        <div class="form-group">
            <label class="control-label col-sm-2" for="Grade">Grade:</label>
            <div class="col-sm-10">
                <input runat="server" type="text" class="form-control gradeInput" id="Grade" placeholder="Grade" maxlength="5" />
            </div>
        </div>

        <asp:Button runat="server" Text="Link Student to Course" CssClass="btn btn-default submitButton" ID="SubmitButton" OnClick="SubmitButton_Click"/>

    </div>

    <div runat="server" class="form-horizontal excelDiv" id="ExcelDiv" style="display: none">
        <p>This file must contain the following fields:</p>

        <ul runat="server" id="StudentList">
            <li>Student Id</li>
            <li>Term Desc Medium</li>
            <li>Course Id</li>
            <li>Course Grade Code</li>
        </ul>

        <label class="btn btn-default" runat="server">
            <asp:FileUpload runat="server" Style="display: none;" ID="excelUpload" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" onchange="$('#upload-file-info').html(this.files[0].name);" />
            Browse...
        </label>

        <span id="upload-file-info">No file selected.</span>

        <asp:RequiredFieldValidator ID="requiredExcelValidator" runat="server" ControlToValidate="excelUpload" ErrorMessage="You must upload a file." Text="* You must upload a file." ForeColor="Red"></asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="regexValidator" runat="server" ControlToValidate="excelUpload" ErrorMessage="Only excel documents are allowed" Text="* Only excel files are allowed." ValidationExpression="^.*\.(xls|xlsx|csv)$" ForeColor="Red"></asp:RegularExpressionValidator>

        <br />
        <br />

        <asp:Button CssClass="btn btn-default" ID="ExcelUploadButton" runat="server" Text="Upload File" OnClick="ExcelUploadButton_Click" />

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

        <br />
        <br />
        <div class="divOutput" id="divOutputText" runat="server" visible="false">
            <label runat="server" id="labelOutput" class="text-danger"></label>
        </div>

    </div>



    <script src="StudentCourses.js"></script>
</asp:Content>
