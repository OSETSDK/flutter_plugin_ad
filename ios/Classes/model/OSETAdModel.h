//
//  OSETAdModel.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSETAdModel : NSObject
@property (nonatomic) NSString *posId;
@property (nonatomic) NSString *adId;
@property (nonatomic) NSString *adLogo;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSNumber *adWidth;
@property (nonatomic) NSNumber *adHeight;

- (void)handleInit:(NSDictionary*)arguments;
@end

NS_ASSUME_NONNULL_END
