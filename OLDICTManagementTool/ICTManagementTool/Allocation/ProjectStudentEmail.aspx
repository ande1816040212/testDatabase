<%@ Page Title="" ValidateRequest="false" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectStudentEmail.aspx.cs" Inherits="ICTManagementTool.Allocation.ProjectStudentEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Use this page to email people</h2>
    <div class="row">
        <div class="col-md-9">
            <div class="form-group">
                Subject:
        [project code]<asp:TextBox runat="server" ID="TBSubject" Text="- Your ICT Project Detail"></asp:TextBox>
            </div>
            <div class="form-group">
                Body Intro:
        <textarea class="form-control" id="TBBody" name="TBBody" rows="5"> 
        </textarea>
            </div>

            <div class="form-group pull-right">
                <asp:Button runat="server" ID="BSendEmail" OnClick="BSendEmail_Click" Text="Send" />
            </div>
        </div>
        <div class="col-md-3">
            <h3>Projects</h3>
            <div style="max-height: 480px; overflow-y: scroll">
                <asp:Repeater runat="server" EnableViewState="false" ID="RProjectList" SelectMethod="RProjectList_GetData" ItemType="ICTManagementTool.Allocation.ProjectStudentEmail+StaffProjectDetail">
                    <ItemTemplate>
                        <div class="form-group">
                            <h6><%# Item.project.projectCode %>: <%# Item.project.projectTitle %> </h6>
                            <ul>
                                <li><b>Students:</b> <%# Item.studentCount %></li>
                                <li><b>Staff:</b> <%# Item.staff %></li>
                                <li><b>Staff Emailed:</b> <%# Item.staffEmailed ? "Yes" : "No" %></li>
                                <li><b>Student Emailed:</b> <%# Item.studentEmailed ? "Yes" : "No" %></li>
                                <li><b>Email now:</b>
                                    <input type="checkbox" value='<%# Item.project.projectID %>' name="projectIDs" /></li>
                            </ul>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <script src="/Scripts/tinymce/tinymce.js"></script>
    <script>

        var text = '<p>Hi Everyone and welcome to ICT Projects for [year].</p>';
        text += '<p>This course provides you with an opportunity to take all the skills and knowledge you have developed over your degree and apply them to a real-world problem put forward by an industry partner. The people you will be working with <strong>are your clients</strong>, so you will need to work with them to establish <strong>what they need</strong> and how it can be best achieved with your available skills.</p>';
        text += '<p>The details of your client project are provided in this email. Please contact your academic supervisor and group members this week to arrange your first meeting to discuss your project and approach. Carefully read through the below detail and any attached documents (if provided).</p>';
        text += '<p>Designate one person to make contact with your client and ensure all initial contact is professional and courteous. As an example, start your email with &ldquo;Dear Dr&hellip;, Prof&hellip;, Miss, CIO, director&rdquo; and so on. You may want to check for a LinkedIn profile to help you with this. Remember this is your <strong>first contact</strong> with the industry person and a bad impression gets around. They also have significant input into your final grade so it\'s best to keep them onside!</p>';
        text += '<hr />';
        text += '[project]';
        text += '[client]';
        text += '[staff]';
        text += '[student]';
        text += '[document]';
        text += '[additionalDocuments]'
        text += '<p>Kind Regards <br />David</p>';

        $('#TBBody').html(text);

        tinymce.init({
            selector: '#TBBody',
            height: 500,
            menubar: false,
            plugins: [
                "advlist autolink autosave link image lists charmap print preview hr anchor pagebreak",
                "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
                "table contextmenu directionality emoticons template textcolor paste fullpage textcolor colorpicker textpattern"
            ],
            toolbar1: "newdocument fullpage | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | styleselect formatselect fontselect fontsizeselect",
            toolbar2: "cut copy paste | searchreplace | bullist numlist | outdent indent blockquote | undo redo | link unlink anchor image media code | insertdatetime preview | forecolor backcolor",
            toolbar3: "table | hr removeformat | subscript superscript | charmap emoticons | print fullscreen | ltr rtl | visualchars visualblocks nonbreaking template pagebreak restoredraft",
            content_css: [
                '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                '//www.tinymce.com/css/codepen.min.css'],

            menubar: false,
            toolbar_items_size: 'small',

            style_formats: [{
                title: 'Bold text',
                inline: 'b'
            }, {
                title: 'Red text',
                inline: 'span',
                styles: {
                    color: '#ff0000'
                }
            }, {
                title: 'Red header',
                block: 'h1',
                styles: {
                    color: '#ff0000'
                }
            }, {
                title: 'Example 1',
                inline: 'span',
                classes: 'example1'
            }, {
                title: 'Example 2',
                inline: 'span',
                classes: 'example2'
            }, {
                title: 'Table styles'
            }, {
                title: 'Table row 1',
                selector: 'tr',
                classes: 'tablerow1'
            }],

            templates: [{
                title: 'Test template 1',
                content: 'Test 1'
            }, {
                title: 'Test template 2',
                content: 'Test 2'
            }],

            init_instance_callback: function () {
                window.setTimeout(function () {
                    $("#div").show();
                }, 1000);
            }
        });
    </script>
</asp:Content>
