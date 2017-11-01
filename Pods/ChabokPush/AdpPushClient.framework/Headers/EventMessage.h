//
//  EventMessage.h
//  AdpPushClient
//
//  Created by Hussein Habibi on 7/1/1396 AP.
//  Copyright © 1396 AP AdpDigital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventMessage : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSDictionary *data;

-(instancetype) initWithEventName:(NSString *)eventName
                         deviceId:(NSString *) deviceId
                             data:(NSDictionary *) data;


@end
