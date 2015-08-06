//	Permissions.js
//	Permissions Cordova Plugin
//
//
//  	Copyright 2015 Emmanuel Tabard. All rights reserved.
//      MIT Licensed
//


var exec = require('cordova/exec');

var LocationStatus = (function(resp) {
	var status = resp.authorizationStatus;
	

	this.allowed = false;
	this.restricted = false;
	this.always = false;
	this.neverPrompted = false;

	if (['AuthorizationStatusNotDetermined', 'AuthorizationStatusDenied'].indexOf(status) === -1 ) {
		this.allowed = true;
	}

	if (status === 'AuthorizationStatusNotDetermined') {
		this.neverPrompted = true;
	}

	if (status === 'AuthorizationStatusRestricted') {
		this.restricted = true;
	}

	if (status === 'kCLAuthorizationStatusAuthorizedAlways') {
		this.always = true;
	}
});

function Permissions() {
   
}

Permissions.prototype.getLocationStatus = function(cb, error) {
	var callback = function (status) {
		var LS = new LocationStatus(status);
		cb(LS);
	};

    exec(cb && callback, error && error, 'Permissions', 'getLocationStatus', []);
};

Permissions.prototype.openSettings = function(cb, error) {
	exec(cb && cb, error && error, 'Permissions', 'openSettings', []);
};

module.exports = new Permissions();
