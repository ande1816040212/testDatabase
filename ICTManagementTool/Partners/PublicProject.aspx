<%@ Page Title="Expression of Interest" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PublicProject.aspx.cs" Inherits="ICTManagementTool.Partners.PublicProject" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Expression of Interest</h2>
    Information here about what the page is about, something like:
    <br />
    <label>Take 3 minutes to use this page to express your interest in students completing a project of yours</label>
    <hr />
    <div class="form-group row">
        <div class="col-md-4">
            <label class="control-label">Project Name</label>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="InputProjName" ForeColor="Red" Text="* You must enter a project name"></asp:RequiredFieldValidator>
        </div>
        <div class="col-md-12">
            <input runat="server" type="text" class="form-control InputProjName" autocomplete="off" id="InputProjName" />
        </div>
    </div>

    <div class="form-group row">
        <div class="col-md-4">
            <label class="control-label">
                Project Description
            </label>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="InputDesc" ForeColor="Red" Text="* You must enter a project description"></asp:RequiredFieldValidator>
        </div>
        <div class="col-md-12">
            <asp:TextBox runat="server" TextMode="MultiLine" Rows="10" CssClass="form-control InputDesc" Style="resize: none" autocomplete="off" ID="InputDesc" />
        </div>
    </div>

    <div class="form-group row">

        <div class="col-md-12">
            <label>Phone</label>
            <asp:RequiredFieldValidator Display="Dynamic" runat="server" ControlToValidate="InputPhone" ForeColor="Red" Text="* You must enter a phone number"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cv" runat="server" ForeColor="Red"  ControlToValidate="InputPhone" Type="Integer" Operator="DataTypeCheck" Text="* You must enter a valid phone number with no spaces" />
            <asp:TextBox runat="server" CssClass="form-control InputPhone" autocomplete="off" ID="InputPhone"></asp:TextBox>
        </div>
    </div>
    <div class="form-group row">
        <div class="col-md-12">
            <label>Email</label>
            <asp:RequiredFieldValidator runat="server" Display="Dynamic" ControlToValidate="InputEmail" ForeColor="Red" Text="* You must enter an email address"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="InputEmail" ForeColor="Red" Text="* You must enter a valid email format"></asp:RegularExpressionValidator>
            <asp:TextBox runat="server" CssClass="form-control InputEmail" autocomplete="off" AutoCompleteType="Email" ID="InputEmail"></asp:TextBox>
        </div>
    </div>

    <asp:Button runat="server" Text="Submit Project" CssClass="btn btn-success" ID="BtnSubmit" OnClick="BtnSubmit_Click" />
    <input type="button" value="Clear Form" class="btn btn-warning" onclick="resetForm()" />


    <div class="DivSuccessBackground" hidden="hidden">
    </div>
    <div class="DivSuccess" hidden="hidden">
        <p>Project interest successfully entered.</p>
    </div>
    <script type="text/javascript">
        //this gets called from c#
        function showSuccess() {
            resetForm();
            $(".DivSuccessBackground").show();
            $(".DivSuccess").show();
            setTimeout(function () { $(".DivSuccessBackground").hide(); $(".DivSuccess").hide() }, 2500);
        }

        function resetForm() {
            $(".InputProjName").val("");
            $(".InputDesc").val("");
            $(".InputPhone").val("");
            $(".InputEmail").val("");
        }

    </script>
    <style type="text/css">
        .DivSuccessBackground {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1000;
            background-color: grey;
            opacity: .4;
        }

        .DivSuccess {
            position: absolute;
            top: 50%;
            left: 50%;
            background-color: #5cb85c;
            z-index: 1002;
            overflow: auto;
            width: 400px;
            height: 50px;
            margin-left: -200px;
            margin-top: -200px;
            /* www.cssdeck.com/labs/16-box-shadows-to-save-your-time/ */
            -webkit-box-shadow: 0 10px 6px -6px #777;
            -moz-box-shadow: 0 10px 6px -6px #777;
            box-shadow: 0 10px 6px -6px #777;
        }

            .DivSuccess p {
                color: white;
                text-align: center;
                margin: 0;
                position: absolute;
                top: 50%;
                left: 50%;
                width: 100%;
                transform: translate(-50%, -50%);
            }
    </style>

</asp:Content>
