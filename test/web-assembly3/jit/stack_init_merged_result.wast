;; Stack initialization at a catch handler must write the merged variable,
;; not the catch-only alias. Exercise both the normal and catch paths.
;;
;; This binary module passes an i32 through a typed try_table. A catch replaces
;; it with the tag's i32 payload and branches to the same result block. The
;; binary form preserves the handler layout that requires stack initialization.
(module binary
  "\00\61\73\6d\01\00\00\00\01\8a\80\80\80\00\02\60"
  "\01\7f\00\60\01\7f\01\7f\03\82\80\80\80\00\01\01"
  "\0d\83\80\80\80\00\01\00\00\07\88\80\80\80\00\01"
  "\04\74\65\73\74\00\00\0a\9d\80\80\80\00\01\97\80"
  "\80\80\00\00\02\7f\41\00\1f\01\01\00\00\00\20\00"
  "\04\40\41\2a\08\00\0b\0b\0b\0b"
)

(assert_return (invoke "test" (i32.const 0)) (i32.const 0))
(assert_return (invoke "test" (i32.const 1)) (i32.const 42))
