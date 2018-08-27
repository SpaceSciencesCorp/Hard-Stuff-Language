package main

import "fmt"
import "time"
import "sync/atomic"

var kount int32
var alldone chan bool
var basetime time.Time

func when(b bool, c chan int) chan int {
  if b {
    return c
  }
  return nil
}

func lopriTime() int {
  return int(time.Since(basetime)/(64*time.Microsecond))
}

func child(fmas, tmas chan int) {
  var thewait [2]int
  for j:=0; j<2; j++ {
    thewait[j] = <- fmas
  }
  for j:=0; j<2; j++ {
    time.Sleep(time.Duration(thewait[j]*64) * time.Microsecond)
    tmas <- thewait[j]
  }
  if atomic.AddInt32(&kount, -1) < 0 {
    alldone <- true
  }
}

func parent(masin, masout [3]chan int) {
  var results [12]int
  var notinput [3]bool
  var thewait, ind, m int
  waits := [][]int{
    []int{10000, 30000, 30000},
    []int{10000, 30000, 30000},
  }
  m = 0
  for j:=0; j<2; j++ {
    for i:=0; i<3; i++ {
      masout[i] <- waits[j][i]
    }
  }
  for j:=0; j<2; j++ {
    for i:=0; i<3; i++ {
      notinput[i] = true
    }
    for k:=0; k<3; k++ {
      select {
        case thewait = <- masin[0] :
          ind = 0
        case thewait = <- masin[1] :
          ind = 1
        case thewait = <- masin[2] :
          ind = 2
      }
      notinput[ind] = false
      results[m] = ind
      m++
      results[m] = thewait
      results[m] = lopriTime()
      m++
    }
  }
  for i:=0; i<11; i++ {
    fmt.Printf("  %d", results[i])
  }
  fmt.Printf("  %d\n", results[11])
  if atomic.AddInt32(&kount, -1) < 0 {
    alldone <- true
  }
}

func main() {
  var masin  [3]chan int
  var masout [3]chan int
  alldone = make(chan bool)
  masin[0]  = make(chan int)
  masin[1]  = make(chan int)
  masin[2]  = make(chan int)
  masout[0] = make(chan int)
  masout[1] = make(chan int)
  masout[2] = make(chan int)
  basetime = time.Now()
  kount = 3
  go parent(masin, masout)
  for i:=0; i<3; i++ {
    go child(masout[i], masin[i])
  }
  <- alldone
  fmt.Printf("Type of alldone is %T\n", alldone)
  time.Sleep(3 * time.Second)
  fmt.Println("Done after wait")
}
