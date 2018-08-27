package main

import "fmt"
import "time"
import "sync/atomic"

var kount int32
var alldone chan bool

func snd(c chan []int, cb chan int) {
  var sl int
  src := [8]int{8, 7, 6, 5, 4, 3, 2, 1}
  s4 := src[0:4]
  c <- s4
  sl = <- cb
  fmt.Println("snd 4 sl", sl)
  s6 := src[0:6]
  c <- s6
  sl = <- cb
  fmt.Println("snd 6 sl", sl)
  s8 := src[0:8]
  c <- s8
  sl = <- cb
  fmt.Println("snd 8 sl", sl)
  kountdown := atomic.AddInt32(&kount, -1)
  fmt.Println("snd", kountdown)
  if kountdown < 0 {
    alldone <- true
  }
}

func rcv(c chan []int, cb chan int) {
  var tl int
  var tgt [6]int
  t4 := <- c
  tl = len(t4)
  if tl > 6 {
    tl = 6
  }
  copy(tgt[0:tl], t4)
  fmt.Println("rcv tgt[0:tl]", tgt[0:tl])
  cb <- tl
  t6 := <- c
  tl = len(t6)
  if tl > 6 {
    tl = 6
  }
  copy(tgt[0:tl], t6)
  fmt.Println("rcv tgt[0:tl]", tgt[0:tl])
  cb <- tl
  t8 := <- c
  tl = len(t8)
  if tl > 6 {
    tl = 6
  }
  copy(tgt[0:tl], t8)
  fmt.Println("rcv tgt[0:tl]", tgt[0:tl])
  cb <- tl
  kountdown := atomic.AddInt32(&kount, -1)
  fmt.Println("rcv", kountdown)
  if kountdown < 0 {
    alldone <- true
  }
}

func main() {
  c := make(chan []int)
  cb := make(chan int)
  alldone = make(chan bool)
  kount = 1
  go snd(c, cb)
  go rcv(c, cb)
  <- alldone
  fmt.Printf("Type of alldone is %T\n", alldone)
  time.Sleep(3 * time.Second)
  fmt.Println("Done after wait")
}
