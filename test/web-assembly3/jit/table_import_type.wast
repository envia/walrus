;; A table's element reference type is invariant when it is imported.
(module $provider
  (type $element (struct (field i32)))
  (table (export "t") 1 (ref null $element))
)

(register "provider" $provider)

;; Structurally equivalent concrete types match across modules.
(module
  (type $element (struct (field i32)))
  (table (import "provider" "t") 1 (ref null $element))
)

;; A different concrete type must not match merely because both are encoded
;; internally as DefinedRef.
(assert_unlinkable
  (module
    (type $element (struct (field i64)))
    (table (import "provider" "t") 1 (ref null $element))
  )
  "incompatible import type"
)
