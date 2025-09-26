#import "InActionEffect.h"
    
@interface InActionEffect ()

@end

@implementation InActionEffect

- (void) takeBeginnerNotifierState
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableArray *beginnerSinkDelay = [NSMutableArray array];
		for (int i = 0; i < 2; ++i) {
			[beginnerSinkDelay addObject:[NSString stringWithFormat:@"taskLikeJob%d", i]];
		}
		NSString *rowViaParameter = @"draggableSpriteOrientation";
		//NSLog(@"sets= bussiness9 gen_arr %@", bussiness9);
	});
}


@end
        