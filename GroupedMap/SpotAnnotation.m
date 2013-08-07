//
//  SpotAnnotation.m
//  GroupedMap
//
//  Created by Hiroki Ueno on 2013/08/07.
//  Copyright (c) 2013年 Coara. All rights reserved.
//

#import "SpotAnnotation.h"

@implementation SpotAnnotation

- (id) initWithTitle:(NSString *)aTitle latitude:(CLLocationDegrees)aLat longitude:(CLLocationDegrees)aLon
{
	self.coordinate = CLLocationCoordinate2DMake(aLat, aLon);
	self.currentTitle = aTitle;
    self.places = [[NSMutableArray alloc] initWithCapacity:0];
	return self;
}

- (NSString *)title{
    if ([self.places count] == 1) {
        return self.currentTitle;
    }
    else{
        return [NSString stringWithFormat:@"%d箇所のスポット", [self.places count]];
    }
}

- (int) placesCount
{
    return [self.places count];
}

- (void) cleanPlaces
{
    [self.places removeAllObjects];
    [self.places addObject:self];
}

- (void)addPlace:(SpotAnnotation *)place
{
    [self.places addObject:place];
}

@end
