# 日志打印

#######
# 颜色 #
#######

# 打印特殊格式（如颜色）是终端提供的功能，现在常用的终端是 xterm-256color，顾名思义支持 256 种颜色。
# 要想让终端打印带有颜色字符串，需要使用 "<Esc>[ + FormatCode + m" 代码来开启或重置颜色输入。
# 其中 <Esc> 在 Bash 中可以由三种转义字符表示：\e | \033 | \x1B

###########
# 特殊属性 #
###########

# 非颜色，特殊字体显示格式
printf "\e[1m加粗    \\\e[1m\e[0m\n"
printf "\e[2m加深    \\\e[2m\e[0m\n"
printf "\e[3m斜体    \\\e[3m\e[0m\n"
printf "\e[4m下划线  \\\e[4m\e[0m\n"
printf "\e[5m闪烁    \\\e[5m\e[0m\n"
printf "\e[7m反转背景  \\\e[7m\e[0m\n"
printf "隐藏（适用密码） \\\e[8m\e[8m隐藏\e[0m\n"

# 重置属性
printf "重置所有属性    \\\e[0m\n"
printf "重置加粗       \\\e[21m\n"
printf "重置加深      \\\e[22m\n"
printf "重置下划线     \\\e[24m\n"
printf "重置闪烁      \\\e[25m\n"
printf "重置反转背景   \\\e[27m\n"
printf "重置隐藏      \\\e[28m\n"

############
# 16 色编码 #
############

# 包含 8 种颜色 + 8 种颜色的亮色 + 默认颜色共 17 种前景色和背景色，共 34 种编码

# 前景色
for fg in 39 {30..37} {90..97}; do
    printf "\e[${fg}m$fg\e[0m\n"
done

# 背景色
for bg in 49 {40..47} {100..107}; do
    printf "\e[${bg}m$bg\e[0m\n"
done

###########
# 属性组合 #
###########

# 由上面的编码也可以看到，属性可以组合使用，格式为 "<Esc>[特殊属性;背景色;前景色m"]

# 打印 16 色组合属性代码
for clbg in {40..47} {100..107} 49; do
    #Foreground
    for clfg in {30..37} {90..97} 39; do
        #Formatting
        for attr in 0 1 2 4 5 7; do
            #Print the result
            printf "\e[${attr};${clbg};${clfg}m \\\e[${attr};${clbg};${clfg}m \e[0m"
        done
        echo #Newline
    done
done

############
# 256 色编码 #
############

# 256 色编码包含 256 个前景色和 256 个背景色

# 前景色编码为 "<Esc>[38;5; + Code + m"]
# 背景色编码为 "<Esc>[39;5; + Code + m"]

for fgbg in 38 48; do         # Foreground / Background
    for color in {0..255}; do # Colors
        # Display the color
        printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
        # Display 6 colors per lines
        if [ $((($color + 1) % 6)) == 4 ]; then
            echo # New line
        fi
    done
    echo # New line
done
