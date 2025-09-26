#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PauseCurveManager : NSObject

@property (nonatomic) NSMutableArray * channelWithMode;

+ (instancetype) pauseCurveManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) hardSinkSpeed;

- (NSMutableDictionary *) persistentTabviewAppearance;

- (int) webPresenterMargin;

- (NSMutableSet *) sustainableErrorResponse;

- (NSMutableArray *) customizedMetadataKind;

@end

NS_ASSUME_NONNULL_END
        