# brew

Homebrew 是 MacOS 上的一个包管理工具。

## ops

### 普通源安装

安装命令

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

卸载命令

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

### 国内清华源

采用清华源进行安装，首先需要添加几个环境变量

```bash
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
```

可以选择从清华源安装或者直接使用官方脚本安装：

```bash
# 从本镜像下载安装脚本并安装 Homebrew / Linuxbrew
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

# 也可从 GitHub 获取官方安装脚本安装 Homebrew / Linuxbrew
/bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"
```

安装完成之后，通过 `brew shellenv` 命令将环境变量添加到 rc 文件中：

```bash
/opt/homebrew/bin/brew shellenv
```

### 替换已安装的源

替换 Homebrew 本身的源：

```bash
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
brew update
```

设置包的仓库镜像：

```bash
# 或使用下面的几行命令自动设置
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
    brew tap --custom-remote --force-auto-update "homebrew/${tap}" "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git"
done
brew update
```

如果用户设置了环境变量 `HOMEBREW_BREW_GIT_REMOTE` 和 `HOMEBREW_CORE_GIT_REMOTE`，则每次执行 `brew update` 时，brew 程序本身和 Core Tap (homebrew-core) 的远程将被自动设置。
推荐用户将这两个环境变量设置加入 shell 的 profile 设置中。

```bash
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
```

### 复原仓库

将仓库复原为官方仓库：

```bash
# brew 程序本身
unset HOMEBREW_BREW_GIT_REMOTE
git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

# 以下针对 macOS 系统上的 Homebrew
unset HOMEBREW_CORE_GIT_REMOTE
BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
    if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then  # 只复原已安装的 Tap
        brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
    fi
done

# 重新拉取远程
brew update
```

重置回默认远程后，用户应该删除 shell 的 profile 设置中的环境变量 `HOMEBREW_BREW_GIT_REMOTE` 和 `HOMEBREW_CORE_GIT_REMOTE` 以免运行 `brew update` 时远程再次被更换。

## command

### version

查看版本

```bash
brew --version
```

### search

根据名称或者正则表达式进行搜索。

```bash
brew search mysql
```

### info

查看包的信息

```bash
brew info [formula]
```

### list

查看已经安装的包的列表

```bash
brew list -l
```

`-l` 表示列出详细信息

### upgrade

列出可升级的包

```bash
brew outdated
```

更新所有的包

```bash
brew upgrade
```

### clean

查看可清理旧版本

```bash
brew cleanup -n
```

清理旧的版本

```bash
brew cleanup
```

### pin

pin 命令可以用来锁定包的版本，不会进行更新

锁定包版本

```bash
brew pin [formula]
```

解锁包的版本

```bash
brew unpin [formula]
```

### uninstall

卸载指定的包

```bash
brew uninstall [formula]
```

### repo

新增一个仓库

```bash
brew tap repo
```

## cask

在 Homebrew 中，case 相当与直接下载并安装 Pkgs 安装包，一般安装的是 MacOS 中的应用，而不是命令行版本的工具。

```bash
brew install --cast ...
```

## plugin

### services

Homebrew 的 Services 插件是通过 Macos 的 `launchctl` Daemon Manager 管理后台的服务。

该插件在第一次使用 brew services 命令的时候会自动安装。

查看帮助：

```bash
brew services --help
```
