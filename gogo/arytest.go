package main

import "fmt"

func main() {
  var a [5]int
  var b [4][3][2]int
  fmt.Printf("Type of a: %T, type of b: %T\n", a, b)
  fmt.Printf("Type of b[1]: %T, type of b[3][2]: %T\n", b[1], b[3][2])
  fmt.Printf("Type of b[1:3]: %T, type of b[3][0:1]: %T\n", b[1:3], b[3][0:1])
  fmt.Printf("Type of b[2][1][0]: %T, type of b[2][1][0:1]: %T\n", b[2][1][0], b[2][1][0:1])
}
