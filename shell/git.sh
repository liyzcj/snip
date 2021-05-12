# Git 相关

# ############################################################################ #
#                                  Git Command                                 #
# ############################################################################ #

# ================================= checkout ================================= #

# Checkout
git checkout -- /path/to/file # 重置单个文件到某个记录

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

git reflog expire --expire-unreachable=now --all
git gc --prune=now

# TODO https://stackoverflow.com/questions/1904860/how-to-remove-unreferenced-blobs-from-my-git-repo
