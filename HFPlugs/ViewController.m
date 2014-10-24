//
//  ViewController.m
//  HFPlugs
//
//  Created by wangmeng on 14-10-23.
//  Copyright (c) 2014年 HF. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkUtil.h"

@interface ViewController ()
- (IBAction)testbuttonPress:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testbuttonPress:(id)sender {
    [NetWorkUtil udpsendSync:@"nihao"];
}
@end
