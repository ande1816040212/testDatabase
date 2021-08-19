<%@ Page Title="Role Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RoleManagement.aspx.cs" Inherits="ICTManagementTool.Admin.RoleManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script src="/Scripts/angular.js"></script>


    <div class="row" data-ng-app="app" data-ng-controller="cont">
        <h2>Role Management</h2>

        <div class="col-md-5">
            <div class="row">
                <div class="col-md-6">
                    <select class="form-control" id="ddlUsers" data-ng-model="selectedUser" data-ng-options="item as item.fullName for item in users | filter:userFilter">
                    </select>
                </div>
                <div class="col-md-6">
                    <input type="text" class="form-control" placeholder="User filter.." data-ng-model="userFilter" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <h4>Courses for {{selectedUser.fullName}}:</h4>

                    <div data-ng-hide="selectedUser.AspNetRoles.length">No roles.</div>

                    <div class="row" data-ng-repeat="r in selectedUser.AspNetRoles">
                        <div class="col-md-8">{{r.Name}}</div>

                        <div class="col-md-4">
                            <input type="button" class="form-control btn btn-danger" value="Remove" data-ng-click="removeRole(selectedUser.Id, r.Name)" />
                        </div>

                    </div>
                </div>
            </div>
        </div>



        <div class="col-md-5">
            <div class="row">
                <select class="form-control" id="ddlRoles" data-ng-model="selectedRole" data-ng-options="item as item.Name for item in roles">
                </select>
            </div>
            <br />
            <br />
            <div class="row" style="border: 1px solid green; padding: 3px">

                <div class="col-md-3">
                    Role Name:
                </div>
                <div class="col-md-6">
                    <input type="text" id="roleName" class="form-control" data-ng-model="newRoleName" />
                </div>
                <div class="col-md-3">
                    <input type="button" value="Create role" class="form-control btn btn-success" data-ng-click="addNewRole(newRoleName)" />
                </div>

            </div>

        </div>

        <div class="col-md-2">
            <input type="button" class="form-control btn btn-success" value="Add user to role" data-ng-click="addRole(selectedUser.Id, selectedRole.Name)" />
        </div>
    </div>
    <script>
        var app = angular.module("app", []);

        app.controller("cont", function ($scope, $http) {

            $scope.selectedUser = null;

            $http({
                method: 'GET',
                url: '/api/RoleManagement'
            }).then(function successCallback(response) {
                $scope.users = response.data[0];
                $scope.roles = response.data[1];

                $scope.selectedUser = $scope.users[0];
                $scope.selectedRole = $scope.roles[0];
            }, error);


            function error(response) {
                console.log(response.status + " " + response.statusText);
            };


            $scope.removeRole = function (userId, roleName) {

                $http.delete("/api/RoleManagement?userId=" + userId + "&roleName=" + roleName).then(function (response) {
                    $scope.reloadData();
                });

            };

            $scope.addRole = function (userId, roleName) {
                if (userId == null || roleName == null || userId == "" || roleName == "") {
                    return;
                }
                $http({
                    method: "PUT",
                    url: "/api/RoleManagement?id=1&userId=" + userId + "&roleName=" + roleName,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    $scope.reloadData();
                });
            };

            $scope.addNewRole = function (roleName) {
                if (roleName == null || roleName == "") {
                    return;
                }
                $http({
                    method: "PUT",
                    url: "/api/RoleManagement?id=2&userId=&roleName=" + roleName,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    $scope.reloadData();
                    $scope.newRoleName = "";
                });
            };

            $scope.reloadData = function () {
                $http({
                    method: 'GET',
                    url: '/api/RoleManagement'
                }).then(function successCallback(response) {
                    $scope.users = response.data[0];
                    $scope.roles = response.data[1];

                    $scope.selectedUser = $scope.users[0];
                    $scope.selectedRole = $scope.roles[0];
                }, error);
            };

        });
    </script>
</asp:Content>
