//
//  ViewController.m
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "Person.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "BaseCell.h"
#import "TextImageCell.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *persons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationController.navigationBar.translucent = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    Person *p1 = [[Person alloc] init];
    p1.cellClassName = @"TextCell";
    p1.name = @"Peter";
    
    Person *p2 = [[Person alloc] init];
    p2.cellClassName = @"ImageCell";
    p2.avatar = @"10112726.jpeg";
    
    Person *p3 = [[Person alloc] init];
    p3.cellClassName = @"TextImageCell";;
    p3.name = @"James";
    p3.avatar = @"11918635.png";
    
    self.persons = [NSMutableArray arrayWithObjects:p1, p2, p3, nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Person *p = _persons[indexPath.row];
    return [p createdTableViewCell:tableView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
