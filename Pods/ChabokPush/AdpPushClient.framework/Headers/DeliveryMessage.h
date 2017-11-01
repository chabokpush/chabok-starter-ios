//
//  DeliveryMessage.h
//  AdpPushClient
//
//  Created by Behrad Zari on 2/7/16.
//  Copyright © 2016 AdpDigital. All rights reserved.
//

#ifndef DeliveryMessage_h
#define DeliveryMessage_h

#import <Foundation/Foundation.h>

@interface DeliveryMessage : NSObject

@property (nonatomic, readonly) NSString *messageId;
@property (nonatomic, readonly) NSString *deliveredUserId;
@property (nonatomic, readonly) NSString *deliveredDeviceId;
@property (nonatomic, readonly) NSDate *deliveredAt;

- (instancetype)initWithId:(NSString *)messageId
     deliveredUserId:(NSString *)deliveredUserId
   deliveredDeviceId:(NSString *)deliveredDeviceId
         deliveredAt:(NSDate *)deliveredAt;


@end

#endif /* DeliveryMessage_h */
