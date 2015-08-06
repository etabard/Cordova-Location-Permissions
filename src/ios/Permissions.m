//
//      Permissions.m
//      Permissions Cordova Plugin
//
//      Copyright 2015 Emmanuel Tabard. All rights reserved.
//      MIT Licensed
//

#import "Permissions.h"
#import <Cordova/CDVJSON.h>

@implementation Permissions

- (void)getLocationStatus:(CDVInvokedUrlCommand*)command {
    [self _handleCallSafely:^CDVPluginResult *(CDVInvokedUrlCommand *command) {
        
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

        NSString* authorizationStatusString = [self authorizationStatusAsString:authorizationStatus];
        
        NSDictionary *dict = @{@"authorizationStatus": authorizationStatusString};
        return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        
        
    } :command];
}

- (void)openSettings:(CDVInvokedUrlCommand*)command {
    [self _handleCallSafely:^CDVPluginResult *(CDVInvokedUrlCommand *command) {
        
        if (&UIApplicationOpenSettingsURLString != NULL) {
           NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
           [[UIApplication sharedApplication] openURL:url];
           return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        else {
          return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        
        
        
        
    } :command];
}

- (NSString *)authorizationStatusAsString: (CLAuthorizationStatus) authorizationStatus {
    
    NSDictionary* statuses = @{@(kCLAuthorizationStatusNotDetermined) : @"AuthorizationStatusNotDetermined",
      @(kCLAuthorizationStatusAuthorized) : @"AuthorizationStatusAuthorized",
      @(kCLAuthorizationStatusDenied) : @"AuthorizationStatusDenied",
      @(kCLAuthorizationStatusRestricted) : @"AuthorizationStatusRestricted",
      @(kCLAuthorizationStatusAuthorizedWhenInUse) : @"AuthorizationStatusAuthorizedWhenInUse",
      @(kCLAuthorizationStatusAuthorizedAlways) : @"AuthorizationStatusAuthorizedAlways"};
    
    return [statuses objectForKey:[NSNumber numberWithInt: authorizationStatus]];
}

#pragma mark Utilities

- (void) _handleExceptionOfCommand: (CDVInvokedUrlCommand*) command : (NSException*) exception {
    NSLog(@"Uncaught exception: %@", exception.description);
    NSLog(@"Stack trace: %@", [exception callStackSymbols]);
    
    // When calling without a request (LocationManagerDelegate callbacks) from the client side the command can be null.
    if (command == nil) {
        return;
    }
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.description];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) _handleCallSafely: (CDVPluginCommandHandler) unsafeHandler : (CDVInvokedUrlCommand*) command  {
    [self _handleCallSafely:unsafeHandler :command :true];
}

- (void) _handleCallSafely: (CDVPluginCommandHandler) unsafeHandler : (CDVInvokedUrlCommand*) command : (BOOL) runInBackground :(NSString*) callbackId {
    if (runInBackground) {
        [self.commandDelegate runInBackground:^{
            @try {
                [self.commandDelegate sendPluginResult:unsafeHandler(command) callbackId:callbackId];
            }
            @catch (NSException * exception) {
                [self _handleExceptionOfCommand:command :exception];
            }
        }];
    } else {
        @try {
            [self.commandDelegate sendPluginResult:unsafeHandler(command) callbackId:callbackId];
        }
        @catch (NSException * exception) {
            [self _handleExceptionOfCommand:command :exception];
        }
    }
}

- (void) _handleCallSafely: (CDVPluginCommandHandler) unsafeHandler : (CDVInvokedUrlCommand*) command : (BOOL) runInBackground {
    [self _handleCallSafely:unsafeHandler :command :true :command.callbackId];
    
}

@end