(function (angular) {
	"use strict";
	
	/**
	 * Controller for showing customer list in a table (with the help of ngTable)
	 */
	angular.module("myapp")
		.controller("ListCustomerCtrl", ListCustomerCtrl);
	
	function ListCustomerCtrl($scope, $http, $location, NgTableParams) {
		var self = this;
		
		$http({
			method: "GET",
			url: GLOBAL_URL.customerBaseUrl
		})
		.then(function success(response) {
			self.tableParams = new NgTableParams({}, { dataset: response.data });
			self.countAll = response.data.length;
		}, function error(response) {
			console.log(response);
		});
		
		// click event for edit
		$scope.editCustomer = function (customerId) {
			$location.path("/edit-customer/" + customerId);
		};
		
	}
	
	ListCustomerCtrl.$inject = ["$scope", "$http", "$location", "NgTableParams"];
	
	
	/**
	 * Controller for adding new customer
	 */
	angular.module("myapp")
		.controller("AddCustomerCtrl", AddCustomerCtrl);
	
	function AddCustomerCtrl($scope, $http) {
		$scope.customer = undefined;   // model for form submit
		$scope.alert = undefined;      // model for 'uib-alert' directive
		
		$scope.closeAlert = function () {
			$scope.alert = undefined;
		};
		
		$scope.submitCustomerForm = function () {
			$http({
				method: "POST",
				url: GLOBAL_URL.customerBaseUrl,
				data: $scope.customer
			})
			.then(function success(response) {
				$scope.alert = { message: "Thêm mới Khách hàng thành công!" };
				$scope.resetForm();
			}, function error(response) {
				$scope.alert = { errorMessage: "(Error: " + response.status + ") Thêm mới thất bại" };
			});
		};
		
		$scope.resetForm = function () {
			$scope.customer = undefined;
		};
	}
	
	AddCustomerCtrl.$inject = ["$scope", "$http"];
	
	
	/**
	 * Controller for editing a customer
	 */
	angular.module("myapp")
		.controller("EditCustomerCtrl", EditCustomerCtrl);
	
	function EditCustomerCtrl($scope, $http, $location, $routeParams, $route) {
		
		$scope.id = $routeParams.id;
		$scope.alert = undefined;
		
		$scope.closeAlert = function() {
			$scope.alert = undefined;
		};
		
		$http({
			method: "GET",
			url: GLOBAL_URL.customerBaseUrl + $scope.id
		})
		.then(function success(response) {
			$scope.customer = response.data;
		}, function error(response) {
			$scope.alert = { errorMessage: "(Error " + response.status + ") Không tìm được khách hàng" };
		});
		
		$scope.submitCustomerForm = function () {
			$http({
				method: "PUT",
				url: GLOBAL_URL.customerBaseUrl + $scope.id,
				data: $scope.customer
			})
			.then(function success(response) {
				$scope.alert = { message: "Cập nhật thành công!" };
			}, function error(response) {
				$scope.alert = { errorMessage: "(Error " + response.status + ") Cập nhật thất bại" };
			});
		};
	}
	
	EditCustomerCtrl.$inject = ["$scope", "$http", "$location", "$routeParams", "$route"];
	
}(angular));