//
//  DemoViewController.m
//  EventBus
//
//  Created by 张小刚 on 16/3/9.
//  Copyright © 2016年 DuoHuo Network Technology. All rights reserved.
//

#import "DemoViewController.h"
#import "ConsoleTextView.h"
#import "EventBus.h"

@interface DemoViewController ()<EventSubscriber,EventPublisher>

@property (weak, nonatomic) IBOutlet UITextField *subscribeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *publishTextfield;
@property (weak, nonatomic) IBOutlet UITextField *unsubscribeTextfield;
@property (weak, nonatomic) IBOutlet ConsoleTextView *consoleTextView;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;
@property (weak, nonatomic) IBOutlet UITextField *checkTextfield;
@property (weak, nonatomic) IBOutlet UITextField *anyTextfield;
@property (weak, nonatomic) IBOutlet UITextField *anyTextfield2;
@property (weak, nonatomic) IBOutlet UITextField *anyTextfield3;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUInteger tabIndex = [self.tabBarController.viewControllers indexOfObject:self.navigationController];
    NSUInteger pushIndex = [self.navigationController.viewControllers indexOfObject:self];
    self.navigationItem.title = [NSString stringWithFormat:@"Demo(%ld,%ld)",tabIndex+1,pushIndex+1];
    UIBarButtonItem * nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
    self.navigationItem.rightBarButtonItem = nextItem;
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.onlineSwitch.on = !self.eventbus_offLine;
}

- (void)doNext
{
    DemoViewController * demoVC = [[DemoViewController alloc] init];
    [self.navigationController pushViewController:demoVC animated:YES];
}

- (IBAction)subscribeButtonPressed:(id)sender {
    NSString * eventName = self.subscribeTextfield.text;
    if(eventName.length == 0) return;
    [[EventBus defaultBus] subscribeEvent:eventName subscriber:self];
    [self log:[NSString stringWithFormat:@"[subscribe] -> [%@]",eventName]];
    self.subscribeTextfield.text = nil;
    [self recoverUI];
}

- (IBAction)publishButtonPressed:(id)sender {
    NSString * eventName = self.publishTextfield.text;
    if(eventName.length == 0) return;
    [[EventBus defaultBus] publishEvent:eventName publisher:self];
    [self log:[NSString stringWithFormat:@"[publish] -> [%@]",eventName]];
    self.publishTextfield.text = nil;
    [self recoverUI];
}

- (IBAction)unsubscribeButtonPressed:(id)sender {
    NSString * eventName = self.unsubscribeTextfield.text;
    if(eventName.length == 0) return;
    [[EventBus defaultBus] unsubscribeEvent:eventName subscriber:self];
    [self log:[NSString stringWithFormat:@"[unsubscribe] -> [%@]",eventName]];
    self.unsubscribeTextfield.text = nil;
    [self recoverUI];
}

- (IBAction)checkButtonPressed:(id)sender {
    NSString * eventName = self.checkTextfield.text;
    if(eventName.length == 0) return;
    NSArray * events = [[EventBus defaultBus] checkEvent:eventName forSubscriber:self];
    for (Event * event in events) {
        [self log:[NSString stringWithFormat:@"[checked] -> [%@]//publish at : %.f",event.name,event.publishTime]];
    }
    self.checkTextfield.text = nil;
    [self recoverUI];
}

- (IBAction)checkAnyButtonPressed:(id)sender {
    NSMutableArray * eventNames = [NSMutableArray array];
    if(self.anyTextfield.text.length > 0){
        [eventNames addObject:self.anyTextfield.text];
    }
    if(self.anyTextfield2.text.length > 0){
        [eventNames addObject:self.anyTextfield2.text];
    }
    if(self.anyTextfield3.text.length > 0){
        [eventNames addObject:self.anyTextfield3.text];
    }
    BOOL result = [[EventBus defaultBus] checkAnyEventsExists:eventNames forSubscriber:self];
    NSMutableString * eventNamesLog = [NSMutableString string];
    for (NSString * name in eventNames) {
        [eventNamesLog appendFormat:@"%@,",name];
    }
    [self log:[NSString stringWithFormat:@"[check any %@] -> [%@]",eventNamesLog,result ? @"YES" : @"NO"]];
    self.anyTextfield.text = nil;
    self.anyTextfield2.text = nil;
    self.anyTextfield3.text = nil;
    [self recoverUI];
}

- (IBAction)checkAllButtonPressed:(id)sender {
    NSMutableArray * eventNames = [NSMutableArray array];
    if(self.anyTextfield.text.length > 0){
        [eventNames addObject:self.anyTextfield.text];
    }
    if(self.anyTextfield2.text.length > 0){
        [eventNames addObject:self.anyTextfield2.text];
    }
    if(self.anyTextfield3.text.length > 0){
        [eventNames addObject:self.anyTextfield3.text];
    }
    BOOL result = [[EventBus defaultBus] checkAllEventsExist:eventNames forSubscriber:self];
    NSMutableString * eventNamesLog = [NSMutableString string];
    for (NSString * name in eventNames) {
        [eventNamesLog appendFormat:@"%@,",name];
    }
    [self log:[NSString stringWithFormat:@"[check all %@] -> [%@]",eventNamesLog,result ? @"YES" : @"NO"]];
    self.anyTextfield.text = nil;
    self.anyTextfield2.text = nil;
    self.anyTextfield3.text = nil;
    [self recoverUI];
}

- (void)eventOccurred: (NSString *)eventName event: (Event *)event
{
    [self log:[NSString stringWithFormat:@"[received] -> [%@]",eventName]];
}

- (void)log: (NSString *)message
{
    message = [NSString stringWithFormat:@"%@          %@",self.navigationItem.title,message];
    [self.consoleTextView log:message];
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self recoverUI];
}

- (IBAction)onlineSwitchValueChanged:(id)sender {
    self.eventbus_offLine = !self.onlineSwitch.on;
    [self log:[NSString stringWithFormat:@"[online] -> [%@]",self.eventbus_offLine ? @"NO": @"YES"]];
}

- (void)recoverUI
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    NSLog(@"dealloced");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end













