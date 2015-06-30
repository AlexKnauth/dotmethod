#lang dotmethod racket

require rackunit

dotmethods
  list? l.rmv(x)
    (remove x l)
  list? l.conj(x)
    (cons x l)
  vector? v.conj(x)
    (vector-append v (vector x))
  hash? h.ref
    case-lambda ; can use case-lambda or any other expression here
      (key) (hash-ref h key)
      (key else) (hash-ref h key else)
  hash? h.rmv(x)
    (hash-remove h x)
  list? lst.fst ; not just methods, field-ish things too
    (first lst)
  list? lst.rst
    (rest lst)
  list? l.ref(i)
    (list-ref l i)
  list? lst.len
    (length lst)
  vector? v.ref(i)
    (vector-ref v i)
  vector? v.fst
    v.ref(0)
  vector? v.len
    (vector-length v)

define lst '(1 2 3)
define vec '#(1 2 3)
define hsh hash('a 1 'b 2 'c 3)

check-equal? lst.fst 1
check-equal? lst.rst '(2 3)
check-equal? lst.ref(2) 3
check-equal? lst.rmv(2) '(1 3)
check-equal? lst.conj(4) '(4 1 2 3)
check-equal? lst.len 3
check-equal? vec.fst 1
check-equal? vec.ref(2) 3
check-equal? vec.conj(4) '#(1 2 3 4)
check-equal? vec '#(1 2 3)
check-equal? vec.len 3
check-equal? hsh.ref('a) 1
check-equal? hsh.rmv('b) hash('a 1 'c 3)
