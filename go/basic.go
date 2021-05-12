/*
 Go 基础语法与关键字
*/

// nolint
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

/* ########################################################################## */
/*                                 User Input                                 */
/* ########################################################################## */

/* ================================== scanf ================================== */

// 使用 Scan 格式化输入
func scanInput() {
	var name string
	var age int
	fmt.Scan(&name, &age)                      // 从标准输入读取，空格分割（换行作为空格看待）
	fmt.Scanln(&name, &age)                    // 从标准输入读取一行，空格分割
	fmt.Scanf("name %s, age: %d", &name, &age) // 从标准输入按格式读取，值中不能有空格。
}

/* ================================== bufio ================================= */

// 使用 bufio 获取 Raw 输入。
func bufioInput() {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter text: ")
	text, _ := reader.ReadString('\n')
	reader.ReadLine()
	fmt.Println("Text:", text)
}

/* ================================= scanner ================================ */

// 使用 Scanner 按行扫描
func scanLine() {
	// 任何 Reader 都可以作为输入来源
	scanner := bufio.NewScanner(os.Stdin)
	// 开始扫描
	for scanner.Scan() {
		//处理代码
		fmt.Println(scanner.Text()) // Println will add back the final '\n'
	}
	// 判断扫描错误
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading standard input:", err)
	}
}

/* -------------------------------------------------------------------------- */

// 使用 Scanner 定制数据分割逻辑
func scanCustomSplit() {
	// 任何 Reader 都可以作为输入来源
	scanner := bufio.NewScanner(os.Stdin)

	/* 对数据进行逗号分割
	data: 扫描的数据
	atEOF: 是否在数据的结尾
	advance: 下次扫描前进的步数
	toekn: 单次切分的结果
	err: 扫描错误
	*/
	onComma := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		for i := 0; i < len(data); i++ {
			if data[i] == ',' {
				return i + 1, data[:i], nil
			}
		}
		if !atEOF {
			return 0, nil, nil
		}
		// 返回 bufio.ErrFinalToken 表示没有更多的 Token 了，并且 Scanner 不会报错
		return 0, data, bufio.ErrFinalToken
	}
	// 设置 split 函数，一定要在 Scan() 开始之前设置，默认的切分函数是按行切分
	scanner.Split(onComma)

	// 开始扫描
	for scanner.Scan() {
		//处理代码
		fmt.Printf("%s\n", scanner.Text())
	}

	// 判断扫描错误
	if err := scanner.Err(); err != nil {
		fmt.Printf("Invalid input: %s", err)
	}
}

/* -------------------------------------------------------------------------- */

// 使用 Scanner 定制输入验证。
func scanVerify() {
	// 任何 Reader 都可以作为输入来源
	scanner := bufio.NewScanner(os.Stdin)

	// 通过内置的 ScanWords 函数定制扫描验证.】
	split := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		// 扫描一个单词
		advance, token, err = bufio.ScanWords(data, atEOF)

		// 这里编写验证逻辑，例如验证是否为整数
		if err == nil && token != nil {
			_, err = strconv.ParseInt(string(token), 10, 32)
		}
		return
	}
	// 设置 split 函数，一定要在 Scan() 开始之前设置，默认的切分函数是按行切分
	scanner.Split(split)

	// 开始扫描
	for scanner.Scan() {
		//处理代码
		fmt.Printf("%s\n", scanner.Text())
	}

	// 判断扫描错误
	if err := scanner.Err(); err != nil {
		fmt.Printf("Invalid input: %s", err)
	}
}
