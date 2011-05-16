//
//  ArcGISTest1AppDelegate.m
//  ArcGISTest1
//
//  Created by Chris Burns on 11-05-04.
//  Copyright Skyhunter Exploration Ltd.  2011. All rights reserved.
//

#import "ArcGISTest1AppDelegate.h"
#import "ArcGISTest1ViewController.h"
#import "MBProgressHUD.h"

@implementation ArcGISTest1AppDelegate

@synthesize window;
@synthesize viewController;

@synthesize sender; 
@synthesize receiver; 


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	
	//Send a request to server for a port number to setup socket connections 
	sender = [[MethodSender alloc] init];
	[sender registerDevice:self andSelector:@selector(setupMethodReceiver:)]; //target = self, action = setupMethodReceiver
	
	
	hud = [[MBProgressHUD alloc] initWithView:self.viewController.view]; 
	hud.labelText = @"Connecting to Surface";
	
	[self.viewController.view addSubview:hud]; 
	
	[hud show:YES]; 

	
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


/* Setup Method Receiver -  Receives from the Server a valid port number that corresponds to a socket created 
 for it's use. A method receiver will then access this port and listen on it for new MethodCalls*/
- (void) setupMethodReceiver: (NSData*) portAsData {

	[hud hide:YES]; 
	
	NSString *portAsString = [[[NSString alloc] initWithData:portAsData encoding:NSUTF8StringEncoding] deserializeString]; 
	
	//Instantiate the receiver object using the port returned from the server
	receiver = [[MethodReceiver alloc] initWithPort:[portAsString integerValue]];
	[receiver startReceiving]; //Begins receiving 

	//For the current view the returned port may have arrived after the view controller was loaded. Call it's "registerAsMethodResponder" method
	[viewController registerAllListeners];

	
}



- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
