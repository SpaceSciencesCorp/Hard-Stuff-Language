package main

import "fmt"
import "time"
import "sync/atomic"

var kount int32
var alldone chan bool

func whistle(ind int) {
  time.Sleep(time.Duration(ind) * time.Second)
  kountdown := atomic.AddInt32(&kount, -1)
  fmt.Println("whistle", ind, kountdown)
  if kountdown < 0 {
    alldone <- true
  }
}

func main() {
  alldone = make(chan bool)
  kount = 2
  for i:=0; i<3; i++ {
    go whistle(i)
  }
  <- alldone
  fmt.Printf("Type of alldone is %T\n", alldone)
  time.Sleep(3 * time.Second)
  fmt.Println("Done after wait")
}
