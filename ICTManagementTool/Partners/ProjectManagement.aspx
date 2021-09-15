<%@ Page Title="Project Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProjectManagement.aspx.cs" Inherits="ICTManagementTool.Partners.ProjectManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.min.js"></script>
    <script src="/Scripts/angular-drag-and-drop-lists.js"></script>
    <script src="/Scripts/angular.js"></script>
    <h2>Current Projects</h2>



    <div class="row" data-ng-app="app" data-ng-controller="cont">
        <div class="form-group row">
            <div class="col-md-4 col-sm-4 col-xs-4">
                <asp:DropDownList runat="server" ID="DDLYear" CssClass="form-control" data-ng-model="yearFilter"></asp:DropDownList>
            </div>
            <div class="col-md-4 col-sm-4 col-xs-4">
                <asp:DropDownList runat="server" ID="DDLSemester" CssClass="form-control" data-ng-model="semesterFilter"></asp:DropDownList>
            </div>
            <div class="col-md-4 col-sm-4 col-xs-4">
                <a style="float: right" href="Project?mode=new" class="btn btn-default">Create a Project</a>
            </div>
        </div>
        <table class="table table-striped table-hover">

            <thead class="thead-inverse">
                <tr>
                    <th class="col-md-8">Title
                    </th>

                    <th class="col-md-2">Date Created
                    </th>

                    <th class="col-md-2">Status
                    </th>
                </tr>
            </thead>

            <tbody>
                <tr data-ng-hide="(projects | filter:{projectYear:yearFilter} | filter:{projectSemester:semesterFilter}).length">
                    <td>No projects for selected year/semester.</td>
                    <td></td>
                    <td></td>
                </tr>
                <tr class="data" data-ng-repeat="p in projects | filter:{projectYear:yearFilter} | filter:{projectSemester:semesterFilter} track by $index">
                    <td>{{ p.projectTitle }}
                        <a href="/Partners/Project?Id={{p.Id}}" target="_blank" title="Link to project"></a>
                    </td>
                    <td>{{ p.dateCreated | date: "d/M/yyyy" }}</td>
                    <td>
                        <select id="adminStatus" runat="server" class="form-control" data-ng-model="p.projectStatus" data-ng-options="status.statusId as status.statusName for status in statusList" data-ng-change="statusChange(p.projectId, p.projectStatus)">
                        </select>

                        <label runat="server" id="clientStatus">
                            {{nameOfStatus(p.projectStatus) }}
                        </label>


                    </td>
                </tr>
            </tbody>

        </table>
        Projects: {{total}}
    </div>

    <script>

        $('tbody').on('dblclick', 'tr.data', function () {

            $(this).find('td a')[0].click();
        })

        var app = angular.module("app", []);

        app.controller('cont', function ($scope, $http) {
            var date = (new Date());
            $scope.yearFilter = date.getFullYear().toString();
            $scope.semesterFilter = date.getMonth() < 2 ? "sp2" : "sp5"; // month starts at 0

  
            //gets all of the projects and a list of all status'
            $http({
                method: 'GET',
                url: '/api/ProjectManagement'
            }).then(function successCallback(response) {
                $scope.projects = response.data[0];
                $scope.statusList = response.data[1];
                $scope.total = response.data[0].length;


            }, error);


            //changes the status of a project
            $scope.statusChange = function (projectId, statusId) {
                $http({
                    method: "PUT",
                    url: "/api/ProjectManagement?id=1&projectId=" + projectId + "&statusId=" + statusId,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                });
            }

            $scope.nameOfStatus = function (id) {
                return $scope.statusList.find(s => s.statusId === id).statusName;
            }


        });




        function error(response) {
            console.log("Error:");
            console.log(response.status + " " + response.statusText);
        }




    </script>
</asp:Content>
