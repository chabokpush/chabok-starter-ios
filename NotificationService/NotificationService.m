//
//  NotificationService.m
//  NotificationService
//
//  Created by Hussein Habibi Juybari on 6/18/18.
//  Copyright © 2018 Chabok Realtime Solutions. All rights reserved.
//

#import "NotificationService.h"
#import <AdpPushClient/AdpPushClient.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    //ChabokPush download media
    [PushClientManager.defaultManager didReceiveNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
