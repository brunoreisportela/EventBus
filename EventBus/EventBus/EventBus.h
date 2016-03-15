//
//  EventBus.h
//  EventBus
//
//  Created by 张小刚 on 16/2/29.
//  Copyright © 2016年 DuoHuo Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, weak) id publisher;
@property (nonatomic, assign) NSTimeInterval publishTime;

@end


@protocol EventSubscriber <NSObject>

- (void)eventOccurred: (NSString *)eventName event: (Event *)event;

@end

@protocol EventPublisher <NSObject>

@end

@interface EventBus : NSObject

//0 means no limit
@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, strong) NSString * busName;

+ (EventBus *)defaultBus;
+ (EventBus *)busWithName: (NSString *)busName;
+ (EventBus *)busWithName: (NSString *)busName capacity: (NSUInteger)capacity;

//订阅
- (void)subscribeEvent:(NSString *)eventName subscriber:(id<EventSubscriber>)subscriber;

//取消订阅
- (void)unsubscribeEvent:(NSString *)eventName subscriber:(id<EventSubscriber>)subscriber;

//发布
- (void)publishEvent:(NSString *)eventName publisher:(id<EventPublisher>)publisher;

//获取从离线以来未读Event
- (NSArray<Event *> *)checkEvent: (NSString *)eventName forSubscriber:(id<EventSubscriber>)subscriber;

- (BOOL)checkAnyEventsExists: (NSArray *)eventNames forSubscriber: (id<EventSubscriber>)subscriber;
- (BOOL)checkAllEventsExist: (NSArray *)eventNames forSubscriber: (id<EventSubscriber>)subscriber;

@end

@interface NSObject (EventBus)

@property (nonatomic, assign) BOOL eventbus_offLine;

@end





























