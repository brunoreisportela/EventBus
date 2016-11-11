//
//  EventBus.h
//  EventBus
//
//  Created by 张小刚 on 16/2/29.
//  Copyright © 2016年 DuoHuo Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString * name;//事件名
@property (nonatomic, weak) id publisher;//发布者
@property (nonatomic, assign) NSTimeInterval publishTime;//发布时间
@property (nonatomic, strong) id params;//参数
@property (nonatomic, assign) NSUInteger life;//生命

@end


@protocol EventSubscriber <NSObject>

- (void)eventOccurred: (NSString *)eventName event: (Event *)event;

@end

@protocol EventPublisher <NSObject>

@end

@interface EventBus : NSObject

@property (nonatomic, strong) NSString * busName;

+ (EventBus *)defaultBus;
+ (EventBus *)busWithName:(NSString *)busName;

/**
 *
 *  @param eventName  订阅的事件名
 *
 *  @param subscriber 符合条件的订阅者
 *
 *  @brief 订阅事件；
 *
 **/
- (void)subscribeEvent:(NSString *)eventName subscriber:(id<EventSubscriber>)subscriber;

/**
 *
 *  @param eventName  需要取消订阅的事件名
 *
 *  @param subscriber 符合条件的订阅者
 *
 *  @brief 取消订阅指定事件；
 *
 **/
- (void)unsubscribeEvent:(NSString *)eventName subscriber:(id<EventSubscriber>)subscriber;

/**
 *
 *  @param eventName 需要发布的事件的事件名
 *
 *  @param publisher 符合条件的发布者
 *
 *  @param params    事件所带参数（可传可不传）
 *
 *  @brief 发布事件；
 *
 **/
- (void)publishEvent:(NSString *)eventName publisher:(id<EventPublisher>)publisher;
- (void)publishEvent:(NSString *)eventName publisher:(id<EventPublisher>)publisher params:(id)params;

/**
 *
 *  @param eventName 需要发布的事件的事件名
 *
 *  @param publisher 符合条件的发布者
 *
 *  @param params    事件所带参数（可传可不传）
 *
 *  @return 包含所有离线以来未读Event的NSArray
 *
 *  @brief 获取从离线以来未读事件；
 *
 **/
- (NSArray<Event *> *)checkEvent:(NSString *)eventName forSubscriber:(id<EventSubscriber>)subscriber;

- (BOOL)checkAnyEventsExists:(NSArray *)eventNames forSubscriber: (id<EventSubscriber>)subscriber;
- (BOOL)checkAllEventsExist:(NSArray *)eventNames forSubscriber: (id<EventSubscriber>)subscriber;

@end

@interface NSObject (EventBus)

@property (nonatomic, assign) BOOL eventbus_offLine;

@end





























