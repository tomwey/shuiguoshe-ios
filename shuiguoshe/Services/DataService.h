//
//  DataService.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@interface DataService : NSObject

+ (DataService *)sharedService;

- (void)loadEntityForClass:(NSString *)clz
                       URL:(NSString *)url
                completion:( void (^)(id result, BOOL succeed) )completion;

@end
