//
//  I18NViewController.m
//  
//
//  Created by 任健生 on 13-6-13.
//
//

#import "HTI18NViewController.h"
#import "HTAlertView.h"

@interface HTI18NViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSString *currentLanguage;
@property (nonatomic,strong) NSIndexPath *checkMarkIndexPath;

@end

@implementation HTI18NViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        if (![[NSUserDefaults standardUserDefaults] stringForKey:@"i18n"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"system" forKey:@"i18n"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"多国语言";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *dataSource = [NSMutableArray array];
    [dataSource addObject:@"system"];
    
    for (NSString *file in files) {
        if ([file hasSuffix:@"lproj"]) {
            [dataSource addObject:[file stringByReplacingOccurrencesOfString:@".lproj" withString:@""]];
        }
    }
    
    self.dataSource = dataSource;
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"i18n"];
    self.currentLanguage = language;
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentLanguage forKey:@"i18n"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HTAlertView *alertView = [[HTAlertView alloc] initWithTitle:nil message:@"重新打开程序生效!这里只是为了方便测试,若不想关闭程序,可以实现自己的Notification" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    alertView.block = ^(NSInteger index){
        // 这里只是为了方便测试,若不想关闭程序,可以实现自己的Notification
        exit(0);
    };
    
    [alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"I18NCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *language = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([language isEqualToString:@"system"]) {
        cell.textLabel.text = @"跟随系统";
    } else {
        cell.textLabel.text = language;
    }
    
    
    if (![language isEqualToString:self.currentLanguage]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.checkMarkIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.checkMarkIndexPath.row) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.checkMarkIndexPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    NSString *language = [self.dataSource objectAtIndex:indexPath.row];
    self.currentLanguage = language;
    self.checkMarkIndexPath = indexPath;
    
}

@end
