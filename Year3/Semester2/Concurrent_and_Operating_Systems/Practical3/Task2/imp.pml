int a = 11;
int b = 12;
int e = 0;
int f = 12;
int h = 11;
int r = 6;
int u = 0;
int w = 10;
int y = 0;

int count = 0; 

inline up_a() { 
  // spec9 { ((a == 11) U ((a == 6) || (a == 7)))} -> passed
  // spec10 { (<>((a == 6)) -> (<>((a == 8)) && [](!((a == 9)))))} -> passed
  // spec11 { (<>((a == 7)) -> (<>((a == 9)) && [](!((a == 8)))))} -> failed (not possible to satisfy both 10 and 11)
  if
  :: a == 11 -> a = 6;  
  :: a == 6 -> a = 7;  
  :: a == 7 -> a = 8;
  :: a == 8 -> a = 6;
  :: else -> skip;
  fi;
}

inline up_b() { 
  // spec2 { ((b == 12) || (b == 14))} -> passed
  // spec3 { [](((b == 12) -> <>((b == 14))))} -> passed
  // spec4 { [](((b == 14) -> <>((b == 12))))} -> failed
  if
  :: b == 12 -> b = 14;
  :: b == 14 -> b = 12;
  fi;
}

inline up_e() {
  // spec8 { <>((e == 14))} -> passed
  if
  :: e == 0 -> e = 14;
  :: else -> skip;
  fi;
}

inline up_f() {
  // spec7 { (f == 12)} -> passed
  if
  :: f == 12 -> f = 0;
  :: else -> skip;
  fi;
}

inline up_h() {
  // spec12 { (h == 11)} -> passed
  // spec13 { <>((h == 11))} -> passed
  // spec14 { ((h == 0) U (h == 11))} -> passed
  // spec15 { ((h == 0) U []((h == 11)))} -> passed
  if
  :: h == 11 -> skip; 
  fi;
}

inline up_r() {
  // spec16 { (r == 6)} -> passed
  // spec17 { <>((r == 7))} -> passed
  if
  :: r == 6 -> r = 7;
  :: r == 7 -> r = 8;
  :: r == 8 -> r = 9;
  :: r == 9 -> skip;  
  fi;
}

inline up_u() {
  // spec5 { ((u == 0) U []((u == 3)))} -> passed
  // spec6 { (<>((u < 7)) && []((u > 7)))} -> failed (not possible no satisfy)
  if
  :: u == 0 -> u = 3;
  :: else -> skip;
  fi;
}

inline up_w() {
  // spec18 { ((w > 0) U (r == 8))} -> passed
  // spec19 { ((w > 0) U []((r == 9)))} -> passed
  // spec20 { ((w == 12) U (w == 14))} -> failed
  // spec21 { (<>((w == 14)) U <>((w == 10)))} -> passed
  // spec22 { (<>((w == 10)) U <>((w == 3)))} -> passed
  // spec23 { (<>((w == 3)) U <>((w == 11)))} -> passed
  if
  :: w == 10 -> w = 12;
  :: w == 12 -> w = 14;
  :: w == 14 -> w = 3;
  :: w == 3 -> w = 11;
  fi;
}

inline up_y() {
  // spec1 { ((y == 0) U (y == 10))} -> passed
  if
  :: y == 0 -> y = 10;
  :: else -> skip;
  fi;
}

init {
  printf("P3p2\n");

  do
  :: (count < 23) ->
      up_a();
      up_b();
      up_e();
      up_f();
      up_h();
      up_r();
      up_u();
      up_w();
      up_y();
      count++;
  :: else -> break;
  od;

}

