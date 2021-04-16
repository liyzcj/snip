# ----------------------------------- 字符串转义 ---------------------------------- #

# 反斜杠转义：反斜杠之后的字符都会作为普通字符处理，行尾的反斜杠会导致换行符号失效
echo \e
echo 1 \
    2

# 单引号转义：单引号内的所有字符都作为普通字符处理
echo ',"$\/_+='

# 双引号转义：除了 $ ` \ 之外的其他字符作为普通字符处理
echo "12345"

# ANSI C 风格的转义字符串
printf $'123\n'

# ---------------------------------- Pattern --------------------------------- #

# 文件
shopt -s globstar # v4.0+
*                 # 当前目录所有文件和文件夹
**                # 递归匹配所有文件和文件夹
**/               # 递归匹配所有文件夹
**/*              # 递归匹配所有文件和文件夹

shopt -u globstar # v4.0+
*                 # 当前目录所有文件和文件夹
**                # 当前目录所有文件和文件夹
**/               # 当前目录所有文件夹
**/*              # 当前目录所有文件夹的子文件和文件夹

# 基础
?           # 任意单个字符
[abc]       # 匹配单个字符
[a-zA-Z0-9] # 范围
[^a-z]      # 取反

# Pattern 中的特殊符号组
[:alnum:]  # 字母和数字
[:alpha:]  # 字母
[:ascii:]  # ASCII 字符
[:blank:]  # 空白字符
[:cntrl:]  # 控制字
[:digit:]  # 数字
[:word:]   # 字母数字以及
[:graph:]  # 图像字符
[:lower:]  # 小写字母
[:print:]  # 打印字符
[:punct:]  # 标点符号
[:space:]  # 空格
[:upper:]  # 大写字母
[:xdigit:] # 十六进制数字

# 扩展规则 一个 pattern-list 表示使用 | 分割的多个 Patterns。
?(pattern-list) # 匹配 pattern-list 中的零个或一个
*(pattern-list) # 匹配 pattern-list 中的零个或多个
+(pattern-list) # 匹配 pattern-list 中的一个或多个
@(pattern-list) # 匹配 pattern-list 中的一个
!(pattern-list) # 不匹配 pattern-list 中的任何一个

# ----------------------------------- 变量操作 ----------------------------------- #

# 数组
array=(a b c)            # 赋值
array[3]=d               # 索引赋值
echo ${array[0]}         # 索引读取
for i in ${array[@]}; do # 循环数组
    echo $i
done

# 通过索引访问数组
echo ${parameter:-word}     # 如果 parameter不存在或为 Null，则采用 word
echo ${parameter:=word}     # 如果 parameter不存在或为 Null，则为 parameter赋值 word并返回。
echo ${parameter:?word}     # 如果 parameter不存在或为 Null，则将 word 打印到标准输出，并退出脚本
echo ${parameter:?}         # 如果 parameter不存在或为 Null，打印默认提示并退出
echo ${parameter:+word}     # 如果 parameter不存在或为 Null，不进行替换，否则采用 word替换。
${parameter:offset}         # 对字符串或数组进行切片，从 offset 处取到结尾，offset可以为负数，表示从结尾处往回索引
${parameter:offset:length}  # 对字符串或数组进行切片，从 offset 处取 length 长度
${!prefix*}                 # 扩展为以 prefix 开头的变量名称，作为单个字符串
${!prefix@}                 # 同上，不过是作为多个分开的单词
${!name[*]}                 # 如果name是一个 Array数组，扩展为该数组的索引，否则为 0，作为单个字符串。
${!name[@]}                 # 同上，不过是作为多个分开的单词。
${#parameter}               # 表示变量内字符串长度
${#parameter[@]}            # 数组长度
echo ${#*}                  # 位置参数的个数
echo ${#@}                  # 同上
${parameter#pattern}        # 如果 pattern 能够匹配 parameter 的开始部分，移除 pattern 所匹配的部分，采用最短匹配原则。
${parameter##pattern}       # 如果 pattern 能够匹配 parameter 的开始部分，移除 pattern 所匹配的部分，采用最长匹配原则。
${parameter%pattern}        # 如果 pattern 能够匹配 parameter 的结尾部分，移除 pattern 所匹配的部分，采用最短匹配原则。
${parameter%%pattern}       # 如果 pattern 能够匹配 parameter 的结尾部分，移除 pattern 所匹配的部分，采用最长匹配原则。
${parameter[@]#pattern}     # 对数组中的每个元素执行操作
${*#pattern}                # 对每个输入参数执行操作
${parameter/pattern/string} # 如果 pattern 能够匹配 parameter 的值，则匹配的部分会被替换为 string。
${parameter^pattern}        # 将 pattern 匹配的字符转换为大写，仅仅转换第一个匹配的字符。
${parameter^^pattern}       # 将 pattern 匹配的字符转换为大写，转换每一个匹配的字符。
${parameter,pattern}        # 将 pattern 匹配的字符转换为小写，仅仅转换第一个匹配的字符。
${parameter,,pattern}       # 将 pattern 匹配的字符转换为小写，转换每一个匹配的字符。
# 上面的 pattern 都只能匹配单个字符，当 pattern为 ? 时，表示匹配任意字符。如果 pattern 省略不填，则视为 ?。

# ---------------------------------- 条件语句 ----------------------------------- #

# IF 语]

if test-commands; then
    echo 1

elif test-commands; then
    echo 2

else
    echo 3
fi

# Case 语句
# 查看字符串是否符合某个 pattern，* 为默认情况，可以匹配任何字符串。

word=1
case $word in
1) echo word1 ;;
2) echo word1 ;;
*) echo word1 ;;
esac

# ----------------------------------- 循环语句 ----------------------------------- #

# Until 语句，直到条件为 true
until test-commands; do consequent-commands; done

# While 语句，直到条件为 false
while test-commands; do consequent-commands; done

# shell 中没有 do...while 语法，但是可以模拟一个
i=1
while
    #### 循环体开始 ####
    echo "$i"
    #### 循环体结束 ####
    ((++i < 10)) # 相当于 until 条件语句
do :; done

# for in 语法，如果省略 [in]，表示循环参数 $1...$n
for name in a b c; do echo $name; done
for name; do echo $name; done

# 括号语法，其中每个表达式都为算术表达式
for ((i = 1; i <= 10; i++)); do echo $i; done

# 便利数值还可以使用 seq 或 {}
for i in $(seq 1 10); do
    echo $i
done

for i in {1..10} {15..20} 30; do
    echo $i
done

# 大括号不仅支持数字，还可以设置步长
for i in {a..z..2}; do
    echo $i
done

# ----------------------------------- 判断条件 ----------------------------------- #
# 任何命令都可以作为条件，返回 0 为 true

# 单方括号条件

# test 命令与 [] 是等价的
[ 1 -eq 1 ]
test 1 -eq 1
[ ! 1 -eq 1 ] # 使用 ! 取反

# 文件相关
[ -a 文件 ] # 文件存在
[ -e 文件 ] # 文件存在，和 -a 相同

# 文件类型
[ -f 常规文件]          # 文件存在且为常规文件
[ -b 块文件 ]          # 文件存在并且为块文件
[ -c 字符文件 ]         # 文件存在并为字符文件
[ -d 目录 ]           # 文件存在且为目录（目录为特殊文件）
[ -h 符号链接 ]         # 文件存在且为符号链接
[ -L 符号链接 ]         # 文件存在且为符号链接，与 -h 相同
[ -p 命名管道 ]         # 文件存在且为命名管道**
[ -t openterminal ] # 文件存在且为打开的终端
[ -S socket ]       # 文件存在且为 socket

# 文件权限
[ -s 文件 ] # 文件存在且超过 0 bytes
[ -G 文件 ] # 文件存在且有有效组ID
[ -O 文件 ] # 文件存在且有有效的用户
[ -N 文件 ] # 文件存在且在最后读后被修改过
[ -r 文件 ] # 文件存在且可读
[ -w 文件 ] # 文件存在且可写
[ -x 文件 ] # 文件存在且可执行

# 文件标志位
[ -k 文件 ] # 文件存在且 stick 位被打开
[ -g 文件 ] # 文件存在且 set-group-ID 位打开
[ -u 文件 ] # 文件存在且 set-user-ID 位打开

# 文件比较
[ 新文件 -nt 旧文件 ] # 新文件在旧文件之后修改或，新文件存在旧文件不存在
[ 旧文件 -ot 新文件 ] # 旧文件在新文件之前修改或，新文件存在旧文件不存在
[ 文件 -ef 文件 ]   #两个文件关联到同一个设备或文件inode

# 字符串比较
[ FOO == BAR ]     # 相等
[ FOO != BAR ]     # 不相等
[ FOO ] >BAR       # 在当前 locale 排序下的排在之后
[ FOO ] <BAR       # 在当前 locale 排序下的排在之前
[ -n 非空字符串 ]       # 非空字符串
[ -z 空字符串 ]        # 空字符串
[[ FOO =~ Regex ]] # 字符串符合正则表达式

# 如果字符有空格，需要加上引号
[ "12 34" == "12 34" ]

# 算术相关条件
[ NUM1 -eq NUM2 ] # 等于
[ NUM1 -ne NUM2 ] # 不等于
[ NUM1 -gt NUM2 ] # 大于
[ NUM1 -ge NUM2 ] # 大于等于
[ NUM1 -lt NUM2 ] # 小于
[ NUM1 -le NUM2 ] # 小于等于

# 其他条件
[ -o shelloption ] # 判断 shell 选项是否打开。
[ -v FOO ]         # 变量是否设置 v4.2+

# ---------------------------------------------------------------------------- #

# 双方括号语法 [[]]

# 是单方括号的增强版本
# * 支持字符串 Globbing
# * 字符串变量的值如果有空格，不会被空格分割
# * 不会扩展文件名，单括号扩展多个文件名会报错
# * 可以使用逻辑符号 && 和 ||，不能使用 -a 和 -o
# * 可以直接使用括号而不用转义
if [ \( "$g" -eq 1 -a "$c" = "123" \) -o \( "$g" -eq 2 -a "$c" = "456" \) ]; then
    echo abc
else
    echo efg
fi

if [[ ("$g" -eq 1 && "$c" = "123") || ("$g" -eq 2 && "$c" = "456") ]]; then
    echo abc
else
    echo efg
fi
# * 允许使用 =~ 进行正则表达式匹配

# ---------------------------------------------------------------------------- #

# 双圆括号语法 专门用于算术表达式，和 let 命令等价
((NUM1 == NUM2)) # 等于
((NUM1 != NUM2)) # 不等于
((NUM1 > NUM2))  # 大于
((NUM1 >= NUM2)) # 大于等于
((NUM1 < NUM2))  # 小于
((NUM1 <= NUM2)) # 小于等于

# ---------------------------------- 重定向与管道 ---------------------------------- #

# 0	stdin	标准输入文件	   键盘
# 1	stdout	标准输出文件	   终端
# 2	stderr	标准错误输出文件	终端

# 重定向符号左边是描述符，右边是文件、&描述符或 Here DOC

# > 等价与 1>，从标准输出重定向
# < 等价与 0<，重定向到标准输入

# ---------------------------------------------------------------------------- #

# 输出重定向
# 如果右边是文件，则会打开文件并写入
command >out.log 2>error.log # 标准错误 -> 文件1，标准输出 -> 文件2
command >out.log 2>&1        # 标准错误 -> 文件，标准输出 -> 文件
command &>out.log            # 同上
command >&out.log            # 同上
command 2>&1 >out.log        # 标准错误 -> 标准输出，标准输出 -> 文件

# 如果 noclobber 选项打开，则不会覆盖以及存在的选项，这时候可以使用 >| 强制覆盖。
set -o noclobber
command >|out.log

# 追加输出 >>
command >>out.log      # 追加到文件
command >>out.log 2>&1 # 标准错误也追加到文件
command &>>out.log     # 同上

# ---------------------------------------------------------------------------- #

# 输入重定向
command <input.txt # 从文件输入

# Here Doc
cat <<EOF
123
EOF

# 可以缩进的 Here DOC，注意使用 <Tab> 而不是空格缩进
cat <<-EEE
	123
	EEE

# 加在分隔符上的转义会作用到字符串上
cat <<-'EEE'
	123$PATH
	EEE

# 输出重定向
cat >out.log <<-'EEE'
	123$PATH
	EEE

# Here String 将 word 作为一行重定向到标准输入
cat <<<word

# ---------------------------------------------------------------------------- #

# 关闭和复制
command 2>&-      # 关闭描述符 2
command 0<&-      # 关闭描述符 0
command 3>&4      # 将 4 复制到 3
command 3<&4      # 将 3 复制到 4
command 3>&4-     # 将 4 复制到 3 并关闭 4
command 3>&4 4>&- # 同上
command <>file    # 以读写模式打开文件

# ---------------------------------------------------------------------------- #

# 管道
command | command # 将一个 command 的标准输入作为另一个的标准输出
<out.log | cat    # 以文件作为标准输入

# ---------------------------------------------------------------------------- #

# 特殊文件
/dev/null              # 空设备
/dev/fd/{fd}           # 可用的文件描述符
/dev/stdin             # 标准输入
/dev/stdout            # 标准输出 1
/dev/stderr            # 标准错误 2
/dev/tcp/{host}/{port} # 如果 host 与 port 有效，则 Bash会打开对应的 TCP socket
/dev/udp/{host}/{port} # 如果 host 与 port 有效，则 Bash会打开对应的 UDP socket
/dev/null              # 空文件
/dev/zero              # 全为 0，无限大
/dev/full              # 写入时显示空间已满，读取时全为 0
/dev/random            # 随机生成器，可能会阻塞
/dev/urandom           # 非阻塞的随机生成器

# ---------------------------------- 用户输入 ---------------------------------- #

# Select 语句
# 打印列表的每一项和编号，选择编号后，对应的编号会复制给 $REPLY

select fname in *; do
    echo you picked $fname \($REPLY\)
    if [[ $fname != "" ]]; then
        break # 选择错误的时候 break，不然会无限循环
    fi
done

# select 配合 case 使用
select name in dog cat; do
    echo you picked $name \($REPLY\)
    case $name in
    dog) echo "a dog" ;;
    cat) echo "a cat" ;;
    *) echo "failed" ;;
    esac
    break
done

# ---------------------------------------------------------------------------- #

# read 命令
read var1 var2 # 读取到 var 变量，多个由空格分割，多余的存到最后一个变量
read           # 读到 REPLY 变量

# 选项
read -d ":" var      # 输入结束的符号，默认为 Enter
read -n 2 var        # 接受字符的个数，不等待结束符
read -p "name: " var # 输入提示
read -t 3 var        # 限制等待时间
read -a arrayname    # 将输入存入数组
read -s pass         # 输入时不回显

# 实例：输入 yes no
read -p "Install packages? [y/n]:" res
if [[ "$res" =~ ^([yY][eE][sS]|[yY])+$ ]] || [ ! $res ]; then
    # 确认后的逻辑
    echo ok
fi

# ------------------------------------ 函数 ------------------------------------ #

# 函数有三种形式
function_name() { command; }
function function_name { command; }
function function_name() { command; }

# 参数，和脚本一样，通过内建变量访问
$? # 上一个命令的返回值，0表示成功，否则出错
$@ # 所有命令行参数，每个参数独立
$* # 所有命令行参数，所有参数算作一个字符串
$# # 命令行参数的数量
$! # 最后运行的程序的 PID
$$ # shell 本身的 PID
$- # 使用 set 命令设置的所有 Flag
$0 # 本身的文件名
$n # n 为 1-9，代表第 1-9 个参数
$_ # 上一个命令的最后一个参数

# 返回值，通过 return 语句返回 0 - 255 的整数，0 表示 true
function return_error {
    return 1
}

# 可以利用命令 true 和 false
true  # 返回 0
false # 返回 1
return_error() { return $(false); }
return_true() { return $(true); }

# 如果没有返回语句，函数默认返回最后一个命令的返回值
is_dictionary() { [ -d $1 ]; }

# ----------------------------------- 数值运算 ----------------------------------- #

# 使用圆括号语法
echo $((1 + 2))
a=$((4 + 2))
((a++))

# let 命令
let "a = 1 + 2"
let "a = $a + 2"
let "a++"

# ----------------------------------- shopt ---------------------------------- #
# TODO
# ------------------------------------ set ----------------------------------- #
# TODO
