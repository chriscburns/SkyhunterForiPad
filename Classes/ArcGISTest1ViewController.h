//
//  ArcGISTest1ViewController.h
//  ArcGISTest1
//
//  Created by Chris Burns on 11-05-04.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcGIS.h"

@interface ArcGISTest1ViewController : UIViewController {
	AGSMapView *_mapView;
	
	IBOutlet UISegmentedControl *dcoControl;
	IBOutlet UISegmentedControl	*secondaryControl; 
	
	
	AGSDynamicMapServiceLayer *contoursLayer; 
	AGSDynamicMapServiceLayer *oilLayer; 
	AGSDynamicMapServiceLayer *depthsLayer; 
	
	AGSMapServiceInfo *depthsInfo; 
	AGSMapServiceInfo *contoursInfo; 
	

}

@property (nonatomic, retain) IBOutlet AGSMapView *mapView;

@property (nonatomic, retain) AGSMapServiceInfo *depthsInfo; 
@property (nonatomic, retain) AGSMapServiceInfo *contoursInfo;

@property (nonatomic, retain) AGSDynamicMapServiceLayer *contoursLayer;
@property (nonatomic, retain) AGSDynamicMapServiceLayer *oilLayer; 
@property (nonatomic, retain) AGSDynamicMapServiceLayer *depthsLayer; 



@property (nonatomic, retain) IBOutlet UISegmentedControl *dcoControl; 
@property (nonatomic, retain) IBOutlet UISegmentedControl *secondaryControl; 






- (IBAction) dcoIndexChanged; 
- (IBAction) secondaryIndexChanged; 



- (void) loadDepthControl;
- (void) loadOilControl; 
- (void) loadContoursControl;
@end

