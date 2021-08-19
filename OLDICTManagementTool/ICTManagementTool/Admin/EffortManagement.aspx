<%@ Page Title="Effort Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EffortManagement.aspx.cs" Inherits="ICTManagementTool.Admin.EffortManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <script src="/Scripts/angular.js"></script>

    <div class="row" data-ng-app="app" data-ng-controller="cont">
        <h2>Effort Management</h2>

        <table class="table table-striped table-hover">

            <thead class="thead-inverse">
                <tr>
                    <th class="col-md-2">Effort Id</th>
                    <th class="col-md-5">
                    Description
                    <th class="col-md-1">Rank Value</th>
                    <th class="col-md-2"></th>
                    <th class="col-md-2">Action</th>
                </tr>
            </thead>
            <tbody>
                <tr data-ng-repeat="e in efforts">
                    <td>{{ e.effortID }}</td>
                    <td>{{ e.effortDescription }}</td>
                    <td>
                        <input type="number" class="form-control" data-ng-model="e.effortRankValue" /></td>
                    <td>
                        <input type="button" class="btn btn-warning" value="Update" style="max-width: 100px" data-ng-click="updateRankValue(e)" /></td>
                    <td>
                        <input type="button" class="btn btn-danger" value="Delete effort" data-ng-click="deleteEffort(e)" />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="text" class="form-control" data-ng-model="newEffortDescription" /></td>
                    <td>
                        <input type="number" class="form-control" data-ng-model="newEffortRankValue" /></td>
                    <td>
                        <input type="button" class="btn btn-success" value="Add effort" data-ng-click="addEffort()" /></td>
                </tr>
            </tbody>
        </table>

    </div>

    <script>
        var app = angular.module("app", []);

        app.controller("cont", function ($scope, $http) {

            $http({
                method: 'GET',
                url: '/api/EffortManagement'
            }).then(function successCallback(response) {
                $scope.efforts = response.data;
                console.log($scope.efforts);
            }, error);


            //changes the status of a project
            $scope.deleteEffort = function (effort) {
                $scope.efforts.splice($scope.efforts.indexOf(effort), 1);
                $http({
                    method: "DELETE",
                    url: "/api/EffortManagement?id=1&effortId=" + effort.effortID,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                });
            };

            $scope.addEffort = function () {
                if ($scope.newEffortRankValue == null) {
                    $scope.newEffortRankValue = 1;
                }
                $http({
                    method: "PUT",
                    url: "/api/EffortManagement?id=1&effortDescription=" + $scope.newEffortDescription + "&effortRankValue=" + $scope.newEffortRankValue,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    $scope.efforts = response.data;
                });

                $scope.newEffortDescription = "";
                $scope.newEffortRankValue = null;


            };

            $scope.updateRankValue = function (effort) {
                if (effort.effortRankValue == null) {
                    effort.effortRankValue = 1;
                }
                $http({
                    method: "PUT",
                    url: "/api/EffortManagement?id=1&effortId=" + effort.effortID + "&effortRankValue=" + effort.effortRankValue,
                    headers: {
                        "Content-Type": "application/json"
                    }

                }).then(function (response) {
                    $scope.efforts = response.data;
                });


            };

            });


            function error(response) {
                console.log("Error:");
                console.log(response.status + " " + response.statusText);
            }
    </script>



</asp:Content>
