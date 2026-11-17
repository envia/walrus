;; A tag's function type is invariant when it is imported.
(module $provider
  (type $base (sub (func (param i32))))
  (type $sub (sub $base (func (param i32))))
  (tag (export "t") (type $sub))
)

(register "provider" $provider)

(module
  (type $base (sub (func (param i32))))
  (type $sub (sub $base (func (param i32))))
  (tag (import "provider" "t") (type $sub))
)

(assert_unlinkable
  (module
    (type $base (sub (func (param i32))))
    (tag (import "provider" "t") (type $base))
  )
  "incompatible import type"
)
