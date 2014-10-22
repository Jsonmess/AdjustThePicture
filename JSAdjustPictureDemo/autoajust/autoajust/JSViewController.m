//
//  JSViewController.m
//  autoajust
//
//  Created by Json on 14-10-18.
//  Copyright (c) 2014年 Jsonmess. All rights reserved.
//

#import "JSViewController.h"
#import "JSImprovePictureController.h"
@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)BeginajustPicture:(id)sender {
    JSImprovePictureController *improve=[[JSImprovePictureController alloc]initWithNibName:@"JSImprovePicture" bundle:nil];
    [self presentViewController:improve animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
