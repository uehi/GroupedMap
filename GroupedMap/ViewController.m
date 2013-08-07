//
//  ViewController.m
//  GroupedMap
//
//  Created by Hiroki Ueno on 2013/08/07.
//  Copyright (c) 2013年 Coara. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "SpotAnnotation.h"

@interface ViewController () {
	IBOutlet MKMapView *mapView;
	NSArray	*places;
	CLLocationDegrees zoomLevel;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// 表示データ
	places = [self spots];

	// 現在地表示
	[mapView setShowsUserLocation:YES];
	// Mapの縮尺を設定
	MKCoordinateRegion zoom = mapView.region;
	zoom.span.latitudeDelta = 0.005;
	zoom.span.longitudeDelta = 0.005;
	[mapView setRegion:zoom animated:YES];
	// 中心設定
	[mapView setCenterCoordinate:[(SpotAnnotation *)[places objectAtIndex:0] coordinate] animated:YES];

	// Annotationを配置
	[self filterAnnotations:places];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKAnnotation

// 地図の縦横を何分割した距離より近いものをグループ化するか
#define kDivideLatitude    15
#define kDivideLongitude   15

// annotationをグループ化する
-(void)filterAnnotations:(NSArray *) paramPlaces
{
    float latDelta = mapView.region.span.latitudeDelta / kDivideLatitude;
    float lonDelta = mapView.region.span.longitudeDelta / kDivideLongitude;
    [paramPlaces makeObjectsPerformSelector:@selector(cleanPlaces)];
    NSMutableArray *spotsToShow = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i < [places count]; i++) {
        SpotAnnotation *currentObj = [paramPlaces objectAtIndex:i];
        CLLocationDegrees lat = [currentObj coordinate].latitude;
        CLLocationDegrees lon = [currentObj coordinate].longitude;

        BOOL found = NO;
        for (SpotAnnotation *tempAnnotation in spotsToShow) {
            if(fabs([tempAnnotation coordinate].latitude - lat) < latDelta && fabs([tempAnnotation coordinate].longitude - lon) < lonDelta){
                [mapView removeAnnotation:currentObj];
                found = YES;
                [tempAnnotation addPlace:currentObj];
                break;
            }
        }
        if (!found) {
            [spotsToShow addObject:currentObj];
            [mapView addAnnotation:currentObj];
        }

    }
	
}

// annotationの設定
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[MKUserLocation class]]){
		// user location
        return nil;
    }else{
        MKAnnotationView *annotationView = nil;
        static NSString *PinIdentifier = @"PinID";
        MKPinAnnotationView *pin = (id)[mV dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
		if (pin == nil) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
            pin.animatesDrop = NO;
            pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pin.canShowCallout = YES;
            pin.enabled = YES;
        }
        annotationView = pin;

		return annotationView;
	}
}

// ズームレベルが変わった時のイベント
-(void)mapView:(MKMapView *)mV regionDidChangeAnimated:(BOOL)animated
{
	if (zoomLevel != mV.region.span.longitudeDelta) {
		// コールアウト消す
		for (id ano in mapView.selectedAnnotations) {
			[mapView deselectAnnotation:ano animated:NO];
		}

		[self filterAnnotations:places];
		zoomLevel = mV.region.span.longitudeDelta;
	}
}

// annotationの詳細押された
- (void)mapView:(MKMapView *)mV annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	SpotAnnotation *annotation = (SpotAnnotation *)view.annotation;

	int placesCount = [annotation placesCount];

	if (placesCount <= 0) return;

	if (placesCount == 1) {
		// 1スポットのAnnotationの場合
		// スポットの詳細画面に遷移するとか処理するとか
	}else {
		// 複数スポットのAnnotationの場合
		// 複数スポットの一覧表示画面線処理するとか
	}

}


#pragma mark - methods

- (NSArray *) spots
{

	SpotAnnotation *s1 = [[SpotAnnotation alloc] initWithTitle:@"博多駅" latitude:33.590099 longitude:130.420411];
	SpotAnnotation *s2 = [[SpotAnnotation alloc] initWithTitle:@"福岡市役所" latitude:33.590492 longitude:130.401639];
	SpotAnnotation *s3 = [[SpotAnnotation alloc] initWithTitle:@"キャナルシティ" latitude:33.588562 longitude:130.41078];
	SpotAnnotation *s4 = [[SpotAnnotation alloc] initWithTitle:@"長崎駅" latitude:32.753066 longitude:129.870487];
	SpotAnnotation *s5 = [[SpotAnnotation alloc] initWithTitle:@"熊本駅" latitude:32.790377 longitude:130.688883];

	return [NSArray arrayWithObjects:s1, s2, s3, s4, s5, nil];

}

@end
