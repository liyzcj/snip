# Git 相关

# ############################################################################ #
#                                  Git Command                                 #
# ############################################################################ #

# ================================== commit ================================== #

git commit -m "msg"  # 提交
git commit -am "msg" # 添加已修改的文件并提交
git commit --amend   # 修改上一个节点

# ================================= checkout ================================= #

# Checkout
git checkout -- /path/to/file # 重置单个文件到某个记录
git checkout .                # 重置到当前分支的 Commit

# =================================== diff =================================== #

git diff [options] [commits] -- [file]
--name-only   # 仅仅显示涉及的文件名
--name-status # 仅仅显示涉及的文件名以及更新的状态

# =================================== merge ================================== #

git merge branch
--ff      # 默认，当可以前进合并时不创建新的 Commit。
--no-ff   # 总是创建一个新的 Commit，它有两个 Parent，一个当前分支，一个合并分支。
--ff-only # 当无法前进合并时，直接合并失败
--squash  # 类似与 --no-ff，不过合并分支完全抛弃，不作为 Commit 的父节点。

# ================================== rebase ================================== #

git rebase -i 'ref' # 交互式 rebase

# =================================== reset ================================== #

# 重置 HEAD 到指定的状态
git reset --hard # 重置到当前分支，重置磁盘文件
git reset --soft # 重置到当前分支，重置暂存区

# ================================== revert ================================== #

git revert '<commit_id>' # 增加一个新的 Commit，来回滚到某个 Commit

# ==================================== tag =================================== #

git tag light                   # unannotated tag
git tag -a -m "Message" annot   # annotated tag
git tag                         # 列出所有标签
git describe                    # 列出 annotated 标签
git push --follow-tags          # 推送 annotated tag 到远程仓库
git tag -d footag               # 删除本地 Tag
git push origin :footag         # 删除远程 Tag
git push --delete origin footag # 删除远程 Tag

# =================================== clean ================================== #

git clean         # 清除当前工作空间中未跟踪的文件，默认只清除当前路径
-d                # 递归清楚搜索路径
-f, --force       # 强制删除
-i, --interactive # 交互模式删除
-n, --dry-run     # 模拟执行
-X                # 仅仅删除被 Git 忽略的文件，不会删除其他文件。
git clean -Xdf    # 删除所有 .gitignore 忽略的文件。

# =================================== stash ================================== #

git stash                        # 暂存变更
git stash pop                    # 弹出上个存储的变更
git stash list                   # 查看所有暂存
git stash clear                  # 清空缓存
git stash drop [-q | --quiet] [] # 删除某个暂存
git stash apply                  # 使用某个暂存，但不会删除
git stash push -p -m "message"   # 暂存部分文件

# ================================== branch ================================== #

git branch -a                       # 查看所有分支，包含远程
git branch                          # 查看本地分支
git branch -d branch_name           # 本地分支
git branch -D branch_name           # 强行删除本地分支
git branch -r -d origin/branch_name # 删除本地远程分支
git push origin :branch_name        # 删除远程分支
git branch branch_name              # 创建方法一，创建后不会自动切换
git checkout -b branch_name         # 创建方法二，创建后会自动切换到分支
git branch -m '<old>' '<new>'       # 移动分支 old 为 new
git branch -m '<new>'               # 将当前分支移动为 New
git branch -M '<old>' '<new>'       # 等价与 git branch --move --force
git branch -vv                      # 查看分支详细信息，包括跟踪的上游分支

# 删除已经 Merge 的所有分支
git branch --merged master | grep -v '^\*\|  master' | xargs -n 1 git branch -d

# ================================= submodule ================================ #

git submodule add --name 'module_name' '<REMOTE_URL>' '<LOCAL_PATH>' # 增加

# 删除
# 1. deinit
git submodule deinit '<module path>'
# 2. 从 .gitmodules 文件删除对应 submodule, 并 stage .gitmodules 文件。
# 3. 从 .git/modules/ 文件夹中删除对应module：
rm -rf .git/modules/module_name
# 4. 提交 Commmit

# ================================== config ================================== #

git config
--list   # 列出当前配置
--global # 全局配置
--edit   # 编辑配置文件
--unset  # 取消配置

user.name            # 用户名
user.email           # 用户邮箱
http.proxy           # 代理
push.followTags true # 自动推送 annotated 标签

url."xxx".insteadOf "xxx"                     # 替换 URL
url."https://github".insteadOf "git://github" # 总是使用 https 进行访问

# ==================================== log =================================== #

# 列出历史 Commit 记录
# git log [<options>] [<revision range>] [[--] <path>...]
#
# * <revision range> 可以用来指定 Commit 的范围
# * [--] <path>... 可以用来指定一个或多个文件，仅仅涉及到这些文件改动的 Commit 才会显示。

# <options>
--stat    # 显示改动的文件及状态，比如文件变动的行数等
--graph   # 以图的方式显示
--oneline # 单行显示
-N        # 限制显示 N 个结果

# ############################################################################ #
#                                  Git Remote                                  #
# ############################################################################ #

git remote add '[<options>]' '<name>' '<url>' # 增加远程仓库
git remote -v                                 # 查看远程仓库

# ############################################################################ #
#                                 Git Advanced                                 #
# ############################################################################ #

# ================================== reflog ================================== #

# reflog 记录了 Git 的操作日志，包含多个子命令
# 例如执行了某个命令强行修改了 Git 的历史，如果不删除，历史还是可以通过 reflog 找回来。
# PS: reflog 只在本地仓库存在！！！

git reflog                   # 同 git reflog show
git reflog show              # 显示操作日志 等价与 git log -g --oneline
git reflog exists '<ref>'    # 判断某个 ref 是否存在，存在返回 0，不存在返回 1
git reflog delete 'HEAD@{N}' # 删除指定的 ref
git reflog expire            # 删除过期的 reflog

git reflog expire --expire-unreachable=now --all # 删除当前不可达的所有 reflog[慎用]

# =================================== prune ================================== #

# 删除不再引用的对象

git prune      # 删除不再引用的松散对象
--expire=now   # 指定过期时间
--dry-run      # 模拟运行
-- '<head>...' # 指定保留可达的引用

git prune-packed # 删除不再引用的打包对象
--dry-run        # 模拟运行

# =================================== fsck =================================== #

git fsck       # 检查对象数据库中对象的连接性以及有效性
--dangling     # 默认，打印 dangling 的对象
--full         # 检查所有对象
--unreachable  # 打印不可达对象
--name-objects # 显示对象是如何被引用的
--no-reflogs   # 不统计 reflog 对对象的引用

# ================================= cat-file ================================= #

git cat-file # 打印对象的内容
-p           # 格式化对象的内容
-s           # 打印对象的大小
-t           # 打印对象的类型

# ================================== others ================================== #

git count-objects -Hv # 统计对象数据库中的信息
git rev-list --all    # 按时间逆序列出 Commit 对象

# ############################################################################ #
#                                 Git Cookbook                                 #
# ############################################################################ #

# =========================== Change Commit History ========================== #

# 查看提交人与邮箱
git log --pretty=format:"[%h] %cd - Committer: %cn (%ce), Author: %an (%ae)"

# 修改历史提交人与邮箱
export FILTER_BRANCH_SQUELCH_WARNING=1
git filter-branch --env-filter '
OLD_EMAIL="旧邮箱"
CORRECT_NAME="新名称"
CORRECT_EMAIL="新邮箱"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
rm -rf .git/refs/original

# ============================== Clean Big File ============================= #

# 查看历史大文件
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -15 | awk '{print$1}')"
# 查看涉及某个文件的提交
git log --oneline --branches --all -- file/to/check
# 删除历史中涉及某个文件的提交
git filter-branch --prune-empty --index-filter 'git rm --ignore-unmatch --cached file/to/delete' --tag-name-filter cat -- --all
# 删除备份并重新打包
rm -Rf .git/refs/original # 删除备份
rm -Rf .git/logs/         # 删除 Checkout 日志
git gc                    # 垃圾回收，重新打包
git prune --expire now    # 删除过期的松散对象

# git 所有对象占用空间的大小
git count-objects -vH

# 查看所有引用了某个对象的提交
git whatchanged --all --find-object=[blob-has]

# 如果上面的方法都不生效，可以采用这种方式移除所有不可达的引用
# NOTE: This will remove many objects you might want to keep: Stashes; Old history not in any current branches; etc.
git reflog expire --expire-unreachable=now --all
git gc --prune=now
