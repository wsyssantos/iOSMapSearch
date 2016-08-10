//
//  ViewController.m
//  AppTest
//
//  Created by Wesley Silva Santos on 8/1/16.
//  Copyright © 2016 wesley. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self helloWorld];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) helloWorld
{
    NSLog(@"Hello World");
}

@end
