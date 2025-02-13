; RUN: llc < %s | FileCheck %s --check-prefixes=OUTLINER,CHECK
; RUN: llc -enable-machine-outliner=always < %s | FileCheck %s --check-prefixes=OUTLINER,CHECK
; RUN: llc -enable-machine-outliner=never < %s  | FileCheck %s --check-prefixes=INDIRECT,CHECK

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-arm-none-eabi"

; CHECK-LABEL: f:
; OUTLINER: bl g
; OUTLINER: bl g
; OUTLINER: bl g
; INDIRECT: blx r
; INDIRECT: blx r
; INDIRECT: blx r
define void @f() minsize optsize {
entry:
  call void @g(i32 45, i32 66)
  call void @g(i32 88, i32 32)
  call void @g(i32 55, i32 33)
  ret void 
}

; CHECK-LABEL: h:
; CHECK: bl g
; CHECK: bl g
define void @h() minsize optsize {
entry:
  call void @g(i32 45, i32 66)
  call void @g(i32 88, i32 32)
  ret void 
}

declare void @g(i32,i32)
