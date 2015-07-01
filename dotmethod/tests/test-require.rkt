#lang dotmethod racket

require rackunit
        racket/set
        "test-lang.rkt"

dotmethods
  generic-set? st.conj(x)
    set-add st x
  generic-set? st.rmv(x)
    set-remove st x
  generic-set? st.len
    set-count st

define s set(1 2 3)
define l list(1 2 3)

check-equal? s.conj(4) set(1 2 3 4)
check-equal? s.rmv(2) set(1 3)
check-equal? s.len 3
check-equal? l.conj(4) list(4 1 2 3)

