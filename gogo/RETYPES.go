package main

import (
  "fmt"
  "unsafe"
  "reflect"
)

func main() {
  var try64 [2]int64
  var data []int32
  try64[0] = -4
  try64[1] = 3
  p := uintptr(unsafe.Pointer(&try64))
  sh := (*reflect.SliceHeader)(unsafe.Pointer(&data))
  sh.Data = p
  sh.Len = 4
  sh.Cap = 4
  fmt.Println(try64)
  fmt.Println(data)
}