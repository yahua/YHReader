//
//  bookClassifyView.m
//  YHMobileReader
//
//  Created by wang shiwen on 14-3-20.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookClassifyView.h"
#import "BookClassifyCell.h"
#import "UIView+Size.h"
#import "BlockCreateUIDefine.h"
#import "DBInterfaceFactory.h"
#import "AppColor.h"
#import "UIColor+Hex.h"

#define kRowHeight 50
#define kImageViewTag  1000
#define kLabelTag  1001

@interface BookClassifyView () <
UITableViewDelegate,
UITableViewDataSource,
BookClassifyCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *bookClassifyArray;

@property (nonatomic, assign) NSInteger selectClassifyID;
@property (nonatomic, assign) BOOL editButtonIsClick;
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation BookClassifyView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Public

- (void)reloadData:(NSArray *)bookClassifyArray; {
    
    [self.bookClassifyArray removeAllObjects];
    self.bookClassifyArray = [NSMutableArray arrayWithArray:bookClassifyArray];
    [self.tableView reloadData];
}

- (void)setIsEdit:(BOOL)isEdit {
    
    self.isEditing = isEdit;
    
    self.tableView.allowsSelection = NO;
    self.editButtonIsClick = YES;
    
    if (isEdit) {
        
        //进入编辑模式
        self.tableView.editing = YES;
    }else {
        
        //退出编辑模式
        self.tableView.editing = NO;
        self.tableView.allowsSelection = YES;
        
        [self clickDone];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.bookClassifyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellWithIdentifier = @"Cell";
    //BookClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    
    //if (cell == nil) {
        BookClassifyCell *cell = [[BookClassifyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //}
    
    NSInteger row = indexPath.row;
    BookClassify *bookClassify = [self.bookClassifyArray objectAtIndex:row];
    [cell initDate:bookClassify];
    
    if (row != 0) {
        
        if (self.addButton.selected) {
            
            if (row == 1) {
                
                [cell showAndBeginEditNameTextField];
            }
        } else {
            
            [cell showNameTextField:tableView.editing];
        }
    } else {
        
        cell.editing = YES;
    }

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate enterBookRack:[self.bookClassifyArray objectAtIndex:indexPath.row]];
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//方法类型：系统方法
//编   写：
//方法功能：删除指定数据
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        //从数据库中删除
        BookClassify *bookClassify = [self.bookClassifyArray objectAtIndex:indexPath.row];
        [[DBInterfaceFactory classifyDBInterface] deleteBookClassify:bookClassify.classifyID];
            
            //将数组中的数据删除
        [self.bookClassifyArray removeObjectAtIndex:indexPath.row];
        
        //将当前cell删除
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
#pragma mark BookClassifyCellDelegate

- (void)cancelTableViewEditing:(NSInteger)classifyID {
    
    self.selectClassifyID = classifyID;
    self.tableView.editing = NO;
}

- (void)resetClassifyName:(BookClassify *)bookClassify {

    self.addButton.selected = NO;
    UIImageView *addimageView = (UIImageView *)[self.addButton viewWithTag:kImageViewTag];
    addimageView.hidden = NO;
    UILabel *addlabel = (UILabel *)[self.addButton viewWithTag:kLabelTag];
    addlabel.text = @"添加";
    addlabel.left = addimageView.right + 5;
    
    self.tableView.allowsSelection = YES;
    self.selectClassifyID = 0;

   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [[DBInterfaceFactory classifyDBInterface] updateBookClassify:bookClassify];
   });

    //数组更新
    NSInteger index=1;
    for (; index<[self.bookClassifyArray count]; index++) {
        
        BookClassify *classify = [self.bookClassifyArray objectAtIndex:index];
        if (classify.classifyID == bookClassify.classifyID) {
            
            classify.classifyName = bookClassify.classifyName;
            break;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark
#pragma mark - Action

- (void)addButtonClick:(id)sender {
    
    self.tableView.allowsSelection = NO;
    self.editButtonIsClick = NO;
    self.addButton.selected = !self.addButton.selected;
    if (self.addButton.selected) {
        
        //添加一个分类
        BookClassify *newBookClassify = [[BookClassify alloc] init];
        newBookClassify.classifyID = 1;
        if ([self.bookClassifyArray count] > 1) {
            
            BookClassify *lastBookClassify = (BookClassify *)[self.bookClassifyArray objectAtIndex:1];
            newBookClassify.classifyID = lastBookClassify.classifyID + 1;
        }
        newBookClassify.classifyName = @"";
        newBookClassify.bookNum = 0;
        [self.bookClassifyArray insertObject:newBookClassify atIndex:1];
        
        UIImageView *imageView = (UIImageView *)[self.addButton viewWithTag:kImageViewTag];
        imageView.hidden = YES;
        
        UILabel *label = (UILabel *)[self.addButton viewWithTag:kLabelTag];
        label.text = @"完成";
        
        //[self.tableView scrollsToTop];
    }else {
        
        //done
        UIImageView *imageView = (UIImageView *)[self.addButton viewWithTag:kImageViewTag];
        imageView.hidden = NO;
        
        UILabel *label = (UILabel *)[self.addButton viewWithTag:kLabelTag];
        label.text = @"添加";
        label.left = imageView.right + 5;
        
        [self clickDone];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Private

- (void)initSubviews {
    
    self.addButton = block_createButton(CGRectMake(30, kUIScreen_AppTop, 72, 32), @"", self, @selector(addButtonClick:));
    self.addButton.backgroundColor = [UIColor colorWithHex:0xaad0dc];
    self.addButton.layer.cornerRadius = 4;
    [self addSubview:self.addButton];
    
    UIImageView *addImageView = block_createImageView(CGRectMake(10, 9, 14, 14), @"bookclassify_add.png");
    addImageView.tag = kImageViewTag;
    [self.addButton addSubview:addImageView];
    
    UILabel *addLabel = block_createLabel([UIColor whiteColor], CGRectMake(addImageView.right + 5, 8, 32, 16), 16);
    addLabel.tag = kLabelTag;
    addLabel.text = @"添加";
    [self.addButton addSubview:addLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kUIScreen_AppTop+kUIScreen_TopBarHeight, self.width, kUIScreen_AppContentHeight)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)clickDone {
    
    //哪一个cell
    NSInteger index=1;
    for (; index<[self.bookClassifyArray count]; index++) {
        
        BookClassify *classify = [self.bookClassifyArray objectAtIndex:index];
        if (classify.classifyID == self.selectClassifyID) {
            
            break;
        }
    }
    if (index < [self.bookClassifyArray count]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        BookClassifyCell *cell = (BookClassifyCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell closeKeyboard];
        
    }else {
        
        NSLog(@"该分类不存在");
    }
}


@end
