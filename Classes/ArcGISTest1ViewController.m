//
//  ArcGISTest1ViewController.m
//  ArcGISTest1
//
//  Created by Chris Burns on 11-05-04.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "ArcGISTest1ViewController.h"

@implementation ArcGISTest1ViewController

@synthesize mapView=_mapView;

@synthesize depthsInfo; 
@synthesize contoursInfo; 


@synthesize contoursLayer; 
@synthesize oilLayer; 
@synthesize depthsLayer; 


@synthesize dcoControl; 
@synthesize secondaryControl;





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	

	
	//Add the base map which serves as the background to all subsquent maps 
	NSURL *baseUrl = [NSURL URLWithString:@"http://asebeast.cpsc.ucalgary.ca:1892/ArcGIS/rest/services/bingmapsRoad/MapServer"];
	AGSDynamicMapServiceLayer *baseLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:baseUrl]; 
	
	[self.mapView addMapLayer:baseLayer withName:@"Base Layer"];
	
	
	
	NSError *error = nil; 

	
	//Depth (Map) Layers (! Not Shown By Default, ergo it's not loaded or put into the map view) 
	NSURL *depthsUrl = [NSURL URLWithString:@"http://asebeast.cpsc.ucalgary.ca:1892/ArcGIS/rest/services/cpzdepths/MapServer"];
	self.depthsInfo = [AGSMapServiceInfo mapServiceInfoWithURL:depthsUrl error:&error]; 
	

	//Contours (Lines) Layers 
	NSURL *contoursUrl = [NSURL URLWithString:@"http://asebeast.cpsc.ucalgary.ca:1892/ArcGIS/rest/services/cpzcontoursopt/MapServer"];
	self.contoursInfo = [AGSMapServiceInfo mapServiceInfoWithURL:contoursUrl error:&error]; 
	
	self.contoursLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithMapServiceInfo:contoursInfo]; 
	self.contoursLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], nil];  //Only show C Layer 
	
	
	[self.mapView addMapLayer:contoursLayer withName:@"Contours Layer"]; 
	
	
	
	
	//Oil Layer 
	NSURL *oilUrl = [NSURL URLWithString:@"http://asebeast.cpsc.ucalgary.ca:1892/ArcGIS/rest/services/Oil12mask/MapServer"]; 
	AGSMapServiceInfo *oilInfo = [AGSMapServiceInfo mapServiceInfoWithURL:oilUrl error:&error]; 

	self.oilLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithMapServiceInfo:oilInfo]; 
	self.oilLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], nil]; //Only show 75% Layer 
	
	[self.mapView addMapLayer:oilLayer withName:@"Oil Layer"]; 
	
	
	

	//Zoom the correct initial extent 
	
	AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:4283]; 
	
	AGSEnvelope *initialExtent = [AGSEnvelope envelopeWithXmin:138.225
														  ymin:-29.215
														  xmax:141.855
														  ymax:-26.321
											  spatialReference:sr];
						
	[self.mapView zoomToEnvelope:initialExtent animated:YES]; 
	


}




#pragma mark Segmented Control Functions

- (IBAction) dcoIndexChanged {
	
	
	
	int currentIndex = self.dcoControl.selectedSegmentIndex; 
	
	
	switch (currentIndex) {
		case 0:
			[self loadDepthControl];
			break;
			
		case 1:
			[self loadOilControl];
			break;
			
		case 2:
			[self loadContoursControl];
			break;


		default:
			break;
	}
	
}




- (IBAction) secondaryIndexChanged {
	
		
	//Determine what the new changed index value
	int currentIndex = self.secondaryControl.selectedSegmentIndex; 
	
	
	
	
	//Determine which segment the higher level controller is on (i.e. depth, contours, etc) 
	
	if (self.dcoControl.selectedSegmentIndex == 0) { //Depth
		

		self.contoursLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:currentIndex], nil]; 
		
		//(TODO) if we are also displaying contours, allow this to be displayed as well 
		
	} 
	
	
	else if (self.dcoControl.selectedSegmentIndex == 1) { //Microseeps 
		
		self.oilLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:currentIndex], nil]; 
		
		
	}
	
	
	else if (self.dcoControl.selectedSegmentIndex == 2) {  //Visibility of lines & map 
		
		switch (currentIndex) {
			case 0: //Contours (Lines) Only
	
				self.contoursLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithMapServiceInfo:self.contoursInfo]; //Load the contours map and capture the visible layers
				self.contoursLayer.visibleLayers = self.depthsLayer.visibleLayers; 
				
				[self.mapView removeMapLayerWithName:@"Depths Layer"]; //Remove depths layer 
				self.depthsLayer = nil; 
				break;
				
			case 1: //Depths (Map) Only 
				
				self.depthsLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithMapServiceInfo:depthsInfo]; //Load the depths map and capture the visible layers 
				self.depthsLayer.visibleLayers = self.contoursLayer.visibleLayers; 
				
				[self.mapView removeMapLayerWithName:"Contours Layer"]; //Remove contours layer 
				self.contoursLayer = nil;
				break;
								
			case 2: 
				
 
				
				
				
			default:
				NSAssert(false, @"Error with the secondary control under the lines & maps context"); 
				break;
		}
		
		
	}
	
	
	
	
	
	
	
}



- (void) loadDepthControl {
	
	
	//Remove all existing segments
	
	[self.secondaryControl removeAllSegments]; 
	
	//Add the C P Z depth segments 
	[self.secondaryControl insertSegmentWithTitle:@"C" atIndex:0 animated:YES]; 
	[self.secondaryControl insertSegmentWithTitle:@"P" atIndex:1 animated:YES];
	[self.secondaryControl insertSegmentWithTitle:@"Z" atIndex:2 animated:YES];
	
	//Select the item in the list that is currently selected in the map
	//int currentSelected = [[depthsLayer.visibleLayers lastObject] intValue];
	
	int currentSelected = [[contoursLayer.visibleLayers lastObject] intValue];
	self.secondaryControl.selectedSegmentIndex = currentSelected; 

	
}

- (void) loadOilControl {
	
	//Remove all existing segments 
	
	[self.secondaryControl removeAllSegments]; 
	
	//Add 75%, 85%, 90%, 95%
	[self.secondaryControl insertSegmentWithTitle:@"75%" atIndex:0 animated:YES]; 
	[self.secondaryControl insertSegmentWithTitle:@"85%" atIndex:1 animated:YES]; 
	[self.secondaryControl insertSegmentWithTitle:@"90%" atIndex:2 animated:YES]; 
	[self.secondaryControl insertSegmentWithTitle:@"95%" atIndex:3 animated:YES]; 
	
	//Select the item in the list that s currently selected in the map
	int currentSelected = [[oilLayer.visibleLayers lastObject] intValue]; 
	self.secondaryControl.selectedSegmentIndex = currentSelected; 
}


- (void) loadContoursControl {
	
	//Remove all existing segments 
	
	[self.secondaryControl removeAllSegments]; 
	
	//Add the C P Z contour segments
	[self.secondaryControl insertSegmentWithTitle:@"Line" atIndex:0 animated:YES]; 
	[self.secondaryControl insertSegmentWithTitle:@"Map" atIndex:1 animated:YES];
	[self.secondaryControl insertSegmentWithTitle:@"Both" atIndex:2 animated:YES];
	
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.mapView = nil;
    [super dealloc];
}

@end
