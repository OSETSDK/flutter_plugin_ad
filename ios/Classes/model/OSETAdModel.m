//
//  OSETAdModel.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETAdModel.h"

@implementation OSETAdModel
- (void)handleInit:(NSDictionary*)arguments {
    _posId = [NSString stringWithFormat:@"%@",arguments[@"posId"]];
    _adId = [NSString stringWithFormat:@"%@",arguments[@"adId"]];
    _userId = [NSString stringWithFormat:@"%@",arguments[@"userId"]];
    _adWidth = arguments[@"adWidth"];
    _adHeight = arguments[@"adHeight"];
}
@end
