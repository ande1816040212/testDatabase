<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectClientEmail.aspx.cs" Inherits="ICTManagementTool.Allocation.ProjectClientEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .projectRow {
            margin: 5px 0;
            border: 1px solid #787878;
            border-radius: 10px;
        }
    </style>
    <asp:Repeater ID="RProjects" runat="server" ItemType="ICTManagementTool.Allocation.ClientProjectDetail" OnItemCreated="RProjects_ItemCreated">
        <ItemTemplate>
            <div class="row projectRow">
                <div class="col-md-12">
                    <p>
                        <strong>Client:</strong> <%# Item.client.title + ". " + Item.client.firstName + " " + Item.client.lastName %><br />
                        <strong>Email:</strong> <a href="mailto:<%#Item.client.Email %>?subject=UniSA ICT Project Allocation"><%#Item.client.Email %></a><br />
                        <strong>Status:</strong> <%#Item.projectStatus %><br />
                        <strong>Hons:</strong> <%# Item.project.honoursUndergrad %>
                    </p>
                    <p><strong>Subject:</strong> UniSA ICT Project Allocation</p>
                    <p>
                        Dear  <%# Item.client.title + ". " + Item.client.lastName %>,<br />
                        I am writing to let you know that your project "<%#Item.project.projectTitle %>" has been allocated <%# Item.students.Count() + (Item.students.Count() > 1 ? " students" : " student") %> and <%# Item.staff.Count() + (Item.staff.Count() > 1 ? " academic supervisors" : " academic supervisor") %> to help.  
                        The students will be informed of the project later tonight and should make initial contact with yourself within the next week.  Each student is expected to spend 15hrs/week working on the project. The role of the academic supervisors is to meet with the student(s), provide professional advice and act as a mentor throughout the project.  
                        As such they may/may not communicate with you directly but their details are provided should you wish to contact them at any point during the project for any reason.  
                    </p>
                    <p>
                        In the coming weeks, Nicole King will also contact you regarding Project Agreements and student insurance information.  If you have any questions or concerns regarding this document, please let her know at the earliest opportunity.
                        She can be contact via: <a href="mailto:Nicole.King@unisa.edu.au">Nicole.King@unisa.edu.au</a>.
                        It is important that all parties (including the students) sign the agreement in the early stages of the project as this also ensures they are covered by university insurance policies as part of the agreement.  
                    </p>
                    <p>
                        <strong>Project:</strong> <%#Item.project.projectTitle %><br />
                        <strong>Project Code:</strong> <%# Item.project.projectCode %>
                    </p>

                    <strong>Academic<%# (Item.staff.Count() > 1 ? " Supervisors" : " Supervisor") %>:</strong>
                    <ul>
                        <asp:Repeater ID="RStaff" runat="server" ItemType="ICTManagementTool.Models.AspNetUsers">
                            <ItemTemplate>
                                <li><%# Item.title + ". " + Item.firstName + " " + Item.lastName %> (<a href="mailto:<%# Item.Email %>"><%# Item.Email %></a>)</li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>

                    <strong>Project <%# (Item.students.Count() > 1 ? " Students" : " Student") %>:</strong>
                    <ul>
                        <asp:Repeater ID="RStudents" runat="server" ItemType="ICTManagementTool.Allocation.ClientProjectDetail+Student">
                            <ItemTemplate>
                                <li><%# Item.firstName + " " + Item.lastName %> (<a href="mailto:<%# Item.email %>"><%# Item.email %></a>)</li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <p>During the semester the students give several presentations which you are most welcome to attend:</p>
                    <ul>
                        <li>In week 5 (starting Monday 23nd August) each student gives a short 5-6 min presentation on the project scope and requirements.</li>
                        <li>In week 13 (starting Monday 1st November) each project group gives a 10-15 min final presentation on the whole project and deliverables/handover.</li>
                        <li>Fair Day (Thursday 11th November) A poster/presentation where all projects are exhibited for you to view and explore.</li>
                    </ul>
                    <p>
                        We will notify you of the final presentation time and location closer to the week 13 date.  You will also receive an invite for the fair day should you wish to attend.<br />

                        All the best with your project and should you have any queries please don’t hesitate to contact the academic supervisor, myself or Nicole King via email.<br />
                    </p>
                    <p>
                        Kind Regards<br />
                        David (ICT Project Coordinator)

                    </p>
                    Client Emailed: 
                    <asp:CheckBox runat="server" ID="CBEmailed" Checked="<%# Item.project.clientEmailSentDate.HasValue %>" />
                    <br />
                    <span class="projectID"><%# Item.project.projectCode %></span><br />
                    <input type="text" class="projectID" readonly="" value="<%# Item.project.projectID %>" />
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <script>

        $('input[type="checkbox"]').on('change', function () {
            var checked = $(this).is(':checked') ? true : false;
            var id = $(this).closest('div').find('input.projectID').val();

            $.ajax({
                url: '/api/ClientProjectEmail/' + id + '?emailed=' + checked,
                method: 'PUT',
                //  data: JSON.stringify({ emailed: checked }),
                dataType: 'json',
                success: function (res) {

                },
                error: function (res) {
                    alert(JSON.stringify(res));
                }
            })
        })
    </script>
</asp:Content>
