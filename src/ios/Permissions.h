//
//  	Permissions.h
//  	Permissions Cordova Plugin
//
//  	Copyright 2015 Emmanuel Tabard. All rights reserved.
//      MIT Licensed
//

#import <Cordova/CDVPlugin.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef CDVPluginResult* (^CDVPluginCommandHandler)(CDVInvokedUrlCommand*);

@interface Permissions : CDVPlugin{
	
}

- (void)getLocationStatus:(CDVInvokedUrlCommand *)command;
- (void)openSettings:(CDVInvokedUrlCommand *)command;

@end
