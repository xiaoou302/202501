#import "BasicGraphTarget.h"
    
@interface BasicGraphTarget ()

@end

@implementation BasicGraphTarget

- (void) captureConstCubit: (NSMutableDictionary *)sliderBridgeResponse
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger resultForType = sliderBridgeResponse.count;
		int commonDecorationAcceleration[12];
		for (int i = 0; i < 12; i++) {
			commonDecorationAcceleration[i] = 41 * i;
		}
		if (resultForType > commonDecorationAcceleration[11]) {
			commonDecorationAcceleration[0] = resultForType;
		} else {
			int tabbarJobRate=0;
			for (int i = 0; i < 11; i++) {
				if (commonDecorationAcceleration[i] < resultForType && commonDecorationAcceleration[i+1] >= resultForType) {
				    tabbarJobRate = i + 1;
				    break;
				}
			}
			for (int i = 0; i < tabbarJobRate; i++) {
				commonDecorationAcceleration[tabbarJobRate - i] = commonDecorationAcceleration[tabbarJobRate - i - 1];
			}
			commonDecorationAcceleration[0] = resultForType;
		}
		//NSLog(@"Business17 gen_dic executed%@", Business17);
	});
}


@end
        