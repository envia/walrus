;; array.copy accepts a source element type that is a subtype of the
;; destination element type.
(module
  (type $dst (array (mut externref)))
  (type $src (array (ref null noextern)))

  (func (export "abstract") (result i32)
    (local $dst-array (ref $dst))
    (local $src-array (ref $src))
    (local.set $dst-array (array.new_default $dst (i32.const 1)))
    (local.set $src-array (array.new_default $src (i32.const 1)))
    (array.copy $dst $src
      (local.get $dst-array) (i32.const 0)
      (local.get $src-array) (i32.const 0)
      (i32.const 1))
    (ref.is_null (array.get $dst (local.get $dst-array) (i32.const 0))))
)

(assert_return (invoke "abstract") (i32.const 1))

(module
  (type $base (sub (struct)))
  (type $sub (sub $base (struct)))
  (type $dst (array (mut (ref null $base))))
  (type $src (array (ref $sub)))

  (func (export "defined") (result i32)
    (local $dst-array (ref $dst))
    (local $src-array (ref $src))
    (local.set $dst-array (array.new_default $dst (i32.const 1)))
    (local.set $src-array
      (array.new $src (struct.new $sub) (i32.const 1)))
    (array.copy $dst $src
      (local.get $dst-array) (i32.const 0)
      (local.get $src-array) (i32.const 0)
      (i32.const 1))
    (ref.test (ref $sub)
      (array.get $dst (local.get $dst-array) (i32.const 0))))
)

(assert_return (invoke "defined") (i32.const 1))
