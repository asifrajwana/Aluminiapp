//
//  CustomHeader.m
//  Uni Alnmni
//
//  Created by asif on 14/04/2015.
//  Copyright (c) 2015 asif. All rights reserved.
//

#import "CustomHeader.h"
#import "Constants.h"
@implementation CustomHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self Init];
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self Init];
//    }
//    return self;
//}
//
- (void)Init {
    

}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        //self.navigationBar.opaque = YES;
        //self.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Sign-in-Large---Default"]];
        self.navigationBar.backgroundColor = BLUE_HEADER;
        [self.navigationBar setBarTintColor:BLUE_HEADER];
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        //[self addNavigationBarButton];
    }
    return self;
}

-(void)addNavigationBarButton{
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
                                 @"MyButton" style:UIBarButtonItemStyleDone target:
                                 self action:@selector(myButtonClicked:)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico-to-do-list"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.navigationItem.backBarButtonItem  = leftItem ;
    
    [[self.navigationBar.items objectAtIndex:0] setHidden:YES];
    
    // create a navigation push button that is initially hidden
    navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navButton setFrame:CGRectMake(60, 0, 200, 40)];
    [navButton setTitle:@"Push Navigation" forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(pushNewView:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navButton];
    //self.view a
    //[navButton setHidden:YES];
}





@end
