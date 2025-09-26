#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisconnectCommonCoordinator : NSObject

@property (nonatomic) int anchorTaskTransparency;

+ (instancetype) disconnectCommonCoordinatorWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) agileSensorKind;

- (NSMutableDictionary *) radiusPerObserver;

- (int) resultAboutPlatform;

- (NSMutableSet *) tappableLoopStatus;

- (NSMutableArray *) hierarchicalCaptionTension;

@end

NS_ASSUME_NONNULL_END
        