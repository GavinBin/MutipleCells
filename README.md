#UITableView支持不同类型的Cell#

在某些业务场景下，同一个UITableView需要支持多种UITableViewCell。考虑一下即时通信的聊天对话列表，不同的消息类型对应于不同的UITableViewCell，同一个tableview往往需要支持多达10种以上的cell类型，例如文本、图片、位置、红包等等。一般情况下，UITableViewCell往往会和业务数据模型绑定，来展示数据。根据不同的业务数据，对应不同的cell。本文将探讨如何有效的管理和加载多种类型的cell。

为了方便讨论，假设我们要实现一个员工管理系统。一个员工包含名字和头像。如果员工只有名字，则只展示名字，如果只有头像，则只展示头像，如果既有名字，又有头像，则需要既展示头像又展示名字。

我们用一个Person类表示员工，用三种不同的cell来处理不同的展示情况。

```
@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@end
```

```
/*负责展示只有名字的员工*/

@interface TextCell : BaseCell

- (void)setPerson:(Person *)p;

@end

```

```
/*负责展示只有头像的员工*/

@interface ImageCell : BaseCell

- (void)setPerson:(Person *)p;

@end

```

```
/*负责展示只有既有名字又有头像的员工*/

@interface TextImageCell : BaseCell

- (void)setPerson:(Person *)p;

@end

```
这三个类都继承了BaseCell，BaseCell继承UITableViewCell

```
@interface BaseCell : UITableViewCell

- (void)setPerson:(Person *)p;

@end

```
下面我们在UITableView的delegate来处理展示Cell

**第一次尝试：**

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell;
    NSString *cellIdentifier;

    switch (p.showtype) {
        case PersonShowText:
            cellIdentifier = @"TextCell";
            break;
        case PersonShowAvatar:
            cellIdentifier = @"PersonShowAvatar";
            break;
        case PersonShowTextAndAvatar:
            cellIdentifier = @"PersonShowTextAndAvatar";
            break;
        default:
            break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        switch (p.showtype) {
            case PersonShowText:
                cell = [[TextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                break;
            case PersonShowAvatar:
                cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                break;
            case PersonShowTextAndAvatar:
                cell = [[TextImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                break;
            default:
                break;
        }
    }
    
    [cell setPerson:p];
    return cell;
}
```
这段代码实现了根据不同的业务模型选取和显示Cell的逻辑。但是这段代码包含了重复代码，switch case被调用了两次。我们改进一下代码：

**第二次尝试**

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell;
    NSString *cellIdentifier;

	Class cellClass;
    switch (p.showtype) {
        case PersonShowText:
            cellClass = [TextCell class];
            break;
        case PersonShowAvatar:
            cellClass = [ImageCell class];
            break;
        case PersonShowTextAndAvatar:
            cellClass = [TextImageCell class];
            break;
        default:
            cellClass = [UITableViewCell class];
            break;
    }
    
    cellIdentifier = NSStringFromClass(cellClass);

    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setPerson:p];
    
    return cell;
}

```

这次比第一次的代码看起来好了不少，通过一个通用的Class对象，来动态生成cell，避免了两次调用switch case的重复代码。但是，有没有更好的实现方式？

**第三次尝试**

```
- (void)viewDidLoad 
{
	...
	[self registerCell];  //注册cell
}
```

```
- (void)registerCell
{
    [_tableView registerClass:[TextCell class] forCellReuseIdentifier:NSStringFromClass([TextCell class])];
    [_tableView registerClass:[ImageCell class] forCellReuseIdentifier:NSStringFromClass([ImageCell class])];
    [_tableView registerClass:[TextImageCell class] forCellReuseIdentifier:NSStringFromClass([TextImageCell class])];
}

```
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *p = _persons[indexPath.row];
    BaseCell *cell;
    NSString *cellIdentifier;

    switch (p.showtype) {
        case PersonShowText:
            cellIdentifier = NSStringFromClass([TextCell class]);
            break;
        case PersonShowAvatar:
            cellIdentifier = NSStringFromClass([ImageCell class]);
            break;
        case PersonShowTextAndAvatar:
            cellIdentifier = NSStringFromClass([TextImageCell class]);
            break;
        default:
            cellIdentifier = NSStringFromClass([UITableViewCell class]);
            break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    [cell setPerson:p];
    
    return cell;
}

```

可以看到，这次我们调用了 `- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier` 方法，把tableView和cell先配置好，并且在`cellForRowAtIndexPath`方法里面，去掉了`if (!cell) {...}`的处理，代码看起来更加简洁。

为什么不再需要判断cell是否为空？因为通过`registerClass`方法注册了cell之后，`dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath` 方法会确保有一个**可用**的cell返回。

当然，我们可以把类型判断的这段代码提取出来，让`cellForRowAtIndexPath`方法看起来更加简洁

```
@interface Person : NSObject

......
@property (nonatomic, strong) NSString *cellIdentifier;

@end

```

```
@implementation Person

- (NSString *)cellIdentifier
{
    if (_showtype == PersonShowTextAndAvatar) {
        return NSStringFromClass([TextImageCell class]);
    } else if (_showtype == PersonShowAvatar){
        return NSStringFromClass([ImageCell class]);
    } else {
        return NSStringFromClass([TextCell class]);
    }
}

@end

```
现在`cellForRowAtIndexPath`方法看起来就像下面这样，明显简洁多了

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *p = _persons[indexPath.row];
    BaseCell *cell;
    NSString *cellIdentifier;

    cellIdentifier = p.cellIdentifier;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
    [cell setPerson:p];
    
    return cell;
}

```

**结论：**

使用 `- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier` 和 `- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath` 可以让UITableView处理多种类型的cell更加灵活和轻松。

# MutipleCells
