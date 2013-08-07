//
//  SpotAnnotation.h
//  GroupedMap
//
//  Created by Hiroki Ueno on 2013/08/07.
//  Copyright (c) 2013年 Coara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SpotAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *currentTitle;
@property (nonatomic, retain) NSMutableArray *places;

- (id) initWithTitle:(NSString *)aTitle latitude:(CLLocationDegrees)aLat longitude:(CLLocationDegrees)aLon;
- (int) placesCount;
- (void)addPlace:(SpotAnnotation *)place;

@end
