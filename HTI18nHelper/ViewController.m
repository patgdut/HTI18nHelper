//
//  ViewController.m
//  HTI18nHelper
//
//  Created by 任健生 on 13-11-6.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import "ViewController.h"
#import "HTI18NViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.view.frame.size.width, 100.0f)];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont boldSystemFontOfSize:25.0f];
    textView.text = NSLocalizedString(@"Test", nil);
    [self.view addSubview:textView];
    
    UIButton *i18nButton = [UIButton buttonWithType:UIButtonTypeSystem];
    i18nButton.frame = CGRectMake(self.view.frame.size.width / 2 - 80.0f, 150.0f, 160.0f, 30.0f);
    [i18nButton setTitle:@"I18n Helper,click me!" forState:UIControlStateNormal];
    [i18nButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [i18nButton addTarget:self action:@selector(i18nButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:i18nButton];
}

- (void)i18nButtonClick:(id)sender {
    HTI18NViewController *i18nVC = [[HTI18NViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:i18nVC];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
