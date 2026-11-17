;; A defined ref.test has an i32 result even though its input is a reference.
;; Exercise the result through a handler stack initialization and on both the
;; normal and catch paths. The binary form preserves the handler layout that
;; requires the stack initialization.
(module binary
  "\00\61\73\6d\01\00\00\00\01\8c\80\80\80\00\03\5f"
  "\00\60\01\7f\00\60\01\7f\01\7f\03\82\80\80\80\00"
  "\01\02\0d\83\80\80\80\00\01\00\01\07\88\80\80\80"
  "\00\01\04\74\65\73\74\00\00\0a\a0\80\80\80\00\01"
  "\9a\80\80\80\00\00\02\7f\d0\6e\fb\14\00\1f\02\01"
  "\00\00\00\20\00\04\40\41\2a\08\00\0b\0b\0b\0b"
)

(assert_return (invoke "test" (i32.const 0)) (i32.const 0))
(assert_return (invoke "test" (i32.const 1)) (i32.const 42))
