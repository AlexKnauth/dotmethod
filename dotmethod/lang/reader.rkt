#lang racket/base

(provide (rename-out [dotmethod-read read]
                     [dotmethod-read-syntax read-syntax]))

(require syntax/parse
         racket/syntax
         (only-in afl/reader make-afl-readtable)
         (only-in postfix-dot-notation/reader make-postfix-dot-readtable)
         (only-in (submod sweet-exp reader) [read-syntax sweet-read-syntax]))

(define (dotmethod-read-syntax src in p ln col pos)
  (define stx (parameterize ([current-readtable (make-afl-readtable (make-postfix-dot-readtable))])
                (sweet-read-syntax src in p ln col pos)))
  (syntax-parse stx #:datum-literals (module)
    [(module name language body ...)
     #:with new-lang-id
     (generate-temporary (format-id #f "dotmethod-~a" #'language))
     #:with new-lang
     (datum->syntax #'language (syntax-e #'new-lang-id) #'language #'language)
     #:with submod-..-new-lang
     (datum->syntax #'language `(submod ".." ,#'new-lang) #'language #'language)
     #'(module name racket/base
         (module new-lang racket/base
           (require racket/require
                    dotmethod/dotmethod
                    (subtract-in language dotmethod/dotmethod))
           (provide (all-from-out language dotmethod/dotmethod)))
         (module main submod-..-new-lang body ...)
         (require (submod "." main))
         (provide (all-from-out (submod "." main))))]))

(define (dotmethod-read in)
  (syntax->datum (dotmethod-read-syntax #f in)))

