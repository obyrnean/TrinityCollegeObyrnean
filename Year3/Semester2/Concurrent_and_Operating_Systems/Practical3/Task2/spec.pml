ltl spec1 { ((y == 0) U (y == 10))}                                   // passed
ltl spec2 { ((b == 12) || (b == 14))}                                 // passed
ltl spec3 { [](((b == 12) -> <>((b == 14))))}                         // passed
ltl spec4 { [](((b == 14) -> <>((b == 12))))}                         // failed
ltl spec5 { ((u == 0) U []((u == 3)))}                                // failed
ltl spec6 { (<>((u < 7)) && []((u > 7)))}                             // failed
ltl spec7 { (f == 12)}                                                // passed
ltl spec8 { <>((e == 14))}                                            // passed
ltl spec9 { ((a == 11) U ((a == 6) || (a == 7)))}                     // passed
ltl spec10 { (<>((a == 6)) -> (<>((a == 8)) && [](!((a == 9)))))}     // failed
ltl spec11 { (<>((a == 7)) -> (<>((a == 9)) && [](!((a == 8)))))}     // failed
ltl spec12 { (h == 11)}                                               // failed
ltl spec13 { <>((h == 11))}                                           // passed
ltl spec14 { ((h == 0) U (h == 11))}                                  // passed
ltl spec15 { ((h == 0) U []((h == 11)))}                              // passed
ltl spec16 { (r == 6)}                                                // passed
ltl spec17 { <>((r == 7))}                                            // passed
ltl spec18 { ((w > 0) U (r == 8))}                                    // failed
ltl spec19 { ((w > 0) U []((r == 9)))}                                // failed
ltl spec20 { ((w == 12) U (w == 14))}                                 // failed
ltl spec21 { (<>((w == 14)) U <>((w == 10)))}                         // passed
ltl spec22 { (<>((w == 10)) U <>((w == 3)))}                          // passed
ltl spec23 { (<>((w == 3)) U <>((w == 11)))}                          // passed
