;; A mutable global's value type is invariant.
(module $mutable-provider
  (global (export "g") (mut (ref null noextern)) (ref.null noextern))
)

(register "mutable-provider" $mutable-provider)

(assert_unlinkable
  (module
    (global (import "mutable-provider" "g") (mut externref))
  )
  "incompatible import type"
)

;; Abstract heap-type hierarchies and exception references are matched too.
(module $abstract-provider
  (global (export "struct") structref (ref.null struct))
  (global (export "i31") i31ref (ref.null i31))
  (global (export "none") nullref (ref.null none))
  (global (export "exn") exnref (ref.null exn))
)

(register "abstract-provider" $abstract-provider)

(module
  (type $struct (struct))
  (global (import "abstract-provider" "struct") anyref)
  (global (import "abstract-provider" "i31") eqref)
  (global (import "abstract-provider" "none") (ref null $struct))
  (global (import "abstract-provider" "exn") exnref)
)

;; An immutable global's concrete reference type may be a subtype of the
;; imported global's type.
(module $provider
  (type $base (sub (struct (field i32))))
  (type $sub (sub $base (struct (field i32) (field i64))))

  (global (export "g") (ref $sub)
    (struct.new $sub (i32.const 7) (i64.const 9)))
)

(register "provider" $provider)

(module
  (type $base (sub (struct (field i32))))
  (global $g (import "provider" "g") (ref $base))

  (func (export "get") (result i32)
    (struct.get $base 0 (global.get $g)))
)

(assert_return (invoke "get") (i32.const 7))
