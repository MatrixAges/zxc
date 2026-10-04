(set-logic QF_BV)
(set-option :produce-models true)
(set-option :timeout 10000)
(declare-fun input_0 () Bool)
(define-fun term_0 () Bool (not input_0))
(define-fun term_1 () Bool (not true))

(assert true)
(check-sat)
