(set-logic QF_BV)
(set-option :produce-models true)
(set-option :timeout 10000)
(declare-fun input_0 () Bool)
(declare-fun input_1 () (_ BitVec 8))
(define-fun term_0 () Bool (not true))

(assert (or term_0))
(check-sat)
