# Git 相关

# ############################################################################ #
#                                  Git Command                                 #
# ############################################################################ #

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
--no-ff   # 总是创建一个新的 Commit
--ff-only # 当无法前进合并时，直接合并失败

# ================================== config ================================== #

git config
--list   # 列出当前配置
--global # 全局配置

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
