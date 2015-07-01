#lang afl postfix-dot-notation sweet-exp racket/base

provide dotmethod
        dotmethods

require syntax/parse/define
        mutable-match-lambda
        for-syntax (except-in racket/base if define)
                   syntax/parse
                   my-cond/iffy
module+ test
  require rackunit
          racket/vector

define-syntax maybe-define-dotmethod
  syntax-parser
    group
      maybe-define-dotmethod method-id:id
      my-cond
        if (identifier-binding #'method-id)
          #'(begin)
        else
          #'(define method-id (make-mutable-match-lambda #:name 'method-id))

define-syntax dotmethod
  syntax-parser
    (dotmethod pred:expr method-id:id ~! method-expr:expr)
      syntax
        begin
          maybe-define-dotmethod method-id
          mutable-match-lambda-add-clause! method-id
            make-clause-proc pred
              let ([method-id method-expr])
                method-id
    (dotmethod pred:expr obj-id:id.method-id:id method-expr:expr |...+|)
      syntax
        dotmethod pred method-id
          λ (obj-id) method-expr ...
    (dotmethod pred:expr obj-id:id.method-id:id(. args) method-body:expr |...+|)
      syntax
        dotmethod pred obj-id.method-id
          λ args method-body ...


define-simple-macro
  dotmethods
    pred:expr stuff ...
    ...
  begin
    dotmethod pred stuff ...
    ...

module+ test
  dotmethods
    list? lst.rmv(x)
      (remove x lst)
    list? lst.conj(x)
      (cons x lst)
    vector? vec.conj(x)
      (vector-append vec (vector x))
  let ([lst '(1 2 3)] [vec '#(1 2 3)])
    check-equal? lst.rmv(2) '(1 3)
    check-equal? lst.conj(4) '(4 1 2 3)
    check-equal? vec.conj(4) '#(1 2 3 4)

