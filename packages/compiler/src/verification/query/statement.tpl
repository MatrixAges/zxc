(set-logic QF_BV)
(set-option :produce-models true)
(set-option :timeout 10000)
${in.declarations}
${in.definitions}
(assert ${in.predicate})
(check-sat)
