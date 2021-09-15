<%@ Page Title="Project Prioritisation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PriorityProjects.aspx.cs" Inherits="ICTManagementTool.PriorityProjects.PriorityProjects1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <script src="/Scripts/angular.min.js"></script>
    <script src="/Scripts/angular-drag-and-drop-lists.js"></script>

    <h2>Project Prioritisation</h2>

    <div class="row" data-ng-app="app" data-ng-controller="cont">

        <div class="form-group row">
            <div class="col-md-6 col-sm-6 col-xs-6">
                <asp:DropDownList runat="server" ID="DDLYear" CssClass="form-control" data-ng-model="yearFilter" data-ng-change="updateFilter()"></asp:DropDownList>
            </div>
            <div class="col-md-6 col-sm-6 col-xs-6">
                <select class="form-control" data-ng-model="semesterFilter" data-ng-change="updateFilter()">
                    <option value="sp2">SP2</option>
                    <option value="sp5">SP5</option>
                </select>
            </div>
        </div>

        <table class="table table-striped table-hover">
            <thead class="thead-inverse">
                <tr>
                    <th class="col-md-4">Title
                    </th>

                    <th class="col-md-3">Priority Level
                    </th>

                    <th class="col-md-4">Reason
                    </th>

                    <th class="col-md-1">Save
                    </th>
                </tr>
            </thead>

            <tbody data-dnd-list="projects" class="row">

                <tr class="table tbody"
                    data-ng-repeat="p in projects"
                    data-dnd-draggable="p"
                    data-dnd-moved="projectMoved($index)"
                    draggable="true">

                    <td class="col-md-4">{{ p.projectId }} - {{ p.projectTitle }}
                                <br />
                        <a href="/Partners/Project?Id={{p.Id}}" target="_blank" title="Link to project">
                            <img src="../linkIcon.PNG" height="16" /></a>

                    </td>

                    <td class="col-md-3">
                        <select class="form-control" data-ng-model="p.recentPriority.priorityLevel" data-ng-options="key for (key, value) in priorityLevels">
                        </select>
                    </td>
                    <td class="col-md-4">
                        <input type="text" data-dnd-nodrag="" class="form-control" data-ng-model="p.recentPriority.priorityReason" />
                    </td>
                    <td class="col-md-1">
                        <input type="button" data-dnd-nodrag="" class="btn btn-success" data-ng-click="priorityChange(p.projectId, p.recentPriority.priorityLevel, p.recentPriority.priorityReason)" value="Save" />
                    </td>
                </tr>
            </tbody>

        </table>

    </div>

    <script>

        var app = angular.module("app", ["dndLists"]);

        app.controller('cont', function ($scope, $http) {
            var date = (new Date());
            $scope.yearFilter = date.getFullYear().toString();
            $scope.semesterFilter = date.getMonth() < 2 ? "sp2" : "sp5"; // month starts at 0

            $scope.priorityLevels = {
                High: '3',
                Medium: '2',
                Low: '1',
                None: '0',
            };

            $scope.updateFilter = function () {
                // alert('here');
                //gets all of the projects
                $http({
                    method: 'GET',
                    url: '/api/PriorityProjects?year=' + $scope.yearFilter + '&sem=' + $scope.semesterFilter
                }).then(function successCallback(response) {
                    $scope.projects = response.data;
                    console.log($scope.projects);

                    //gives all of the projects a priority level of None
                    //if they dont have an entry in the database
                    for (i = 0; i < $scope.projects.length; i++) {
                        if ($scope.projects[i].recentPriority == null) {
                            $scope.projects[i].recentPriority = { priorityLevel: "0" };
                        }
                    }


                }, error);
            }

            $scope.updateFilter();


            //changes the priority of a project
            $scope.priorityChange = function (projectId, priorityLevel, priorityComment) {
                //cant send an empty string to the controller
                if (priorityComment == "") {
                    priorityComment = "null";
                }
                $http({
                    method: "PUT",
                    url: "/api/PriorityProjects?projectId=" + projectId + "&priorityLevel=" + priorityLevel + "&priorityReason=" + priorityComment,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                });
            }

            $scope.projectMoved = function (index) {
                $scope.projects.splice(index, 1);

                $http.put("/api/PriorityProjects?projects=", $scope.projects)
                    .then(
                        function (response) {

                        }, error);

            };
        });


        function error(response) {
            console.log("Error:");
            console.log(response.status + " " + response.statusText);
        }


    </script>
</asp:Content>
