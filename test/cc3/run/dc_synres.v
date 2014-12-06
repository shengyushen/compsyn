
module Convolutional_Code_3 ( clock, in, noise0, noise1, out1, out2, decosy );
  input clock, in, noise0, noise1;
  output out1, out2, decosy;
  wire   Convolutional_Code_3_noise_3__x0, Convolutional_Code_3_noise_3__x1,
         n25, Convolutional_Code_3_noise_3__x2, n26, n27, n28,
         Convolutional_Code_3_r2, n29, n30, n31, n32, n33, n34, n35, n36, n37,
         n38, n39, n40, n41, n42, n29_1, n44, n34_1, n46, n47, n48, n39_1, n19,
         n24, N2, N3, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14, n15, n16, n17, n18, n20, n21, n22, n23, n43, n45;

  IV I_28 ( .A(n42), .Z(decosy) );
  IV I_27 ( .A(n41), .Z(out2) );
  IV I_26 ( .A(n34), .Z(out1) );
  AN2 C88 ( .A(n16), .B(n48), .Z(n39_1) );
  AN2 C85 ( .A(n23), .B(n21), .Z(n48) );
  AN2 C82 ( .A(n45), .B(n22), .Z(n47) );
  AN2 C81 ( .A(Convolutional_Code_3_noise_3__x2), .B(n44), .Z(n46) );
  AN2 C78 ( .A(n14), .B(n22), .Z(n34_1) );
  AN2 C77 ( .A(Convolutional_Code_3_noise_3__x0), .B(
        Convolutional_Code_3_noise_3__x1), .Z(n44) );
  AN2 C74 ( .A(n20), .B(n15), .Z(n29_1) );
  AN2 C72 ( .A(Convolutional_Code_3_noise_3__x2), .B(n14), .Z(n42) );
  AN2 C69 ( .A(n2), .B(n4), .Z(n41) );
  AN2 C67 ( .A(n18), .B(n38), .Z(n40) );
  AN2 C65 ( .A(n35), .B(n3), .Z(n39) );
  AN2 C62 ( .A(n5), .B(n8), .Z(n38) );
  AN2 C60 ( .A(n12), .B(n31), .Z(n37) );
  AN2 C58 ( .A(n24), .B(n6), .Z(n36) );
  AN2 C57 ( .A(noise0), .B(n27), .Z(n35) );
  AN2 C54 ( .A(n1), .B(n7), .Z(n34) );
  AN2 C53 ( .A(n28), .B(n31), .Z(n33) );
  AN2 C50 ( .A(n17), .B(n6), .Z(n32) );
  AN2 C47 ( .A(n11), .B(n9), .Z(n31) );
  AN2 C45 ( .A(n10), .B(Convolutional_Code_3_r2), .Z(n30) );
  AN2 C43 ( .A(n19), .B(n13), .Z(n29) );
  IV I_3 ( .A(noise0), .Z(N3) );
  AN2 C41 ( .A(N3), .B(n27), .Z(n28) );
  IV I_2 ( .A(noise1), .Z(N2) );
  AN2 C39 ( .A(N2), .B(n26), .Z(n27) );
  AN2 C38 ( .A(Convolutional_Code_3_noise_3__x2), .B(n25), .Z(n26) );
  AN2 C35 ( .A(n20), .B(n43), .Z(n25) );
  FD1 Convolutional_Code_3_r0_reg ( .D(in), .CP(clock), .Q(n19) );
  FD1 Convolutional_Code_3_r1_reg ( .D(n19), .CP(clock), .Q(n24) );
  FD1 Convolutional_Code_3_r2_reg ( .D(n24), .CP(clock), .Q(
        Convolutional_Code_3_r2) );
  FD1 Convolutional_Code_3_noise_3__x2_reg ( .D(n39_1), .CP(clock), .Q(
        Convolutional_Code_3_noise_3__x2) );
  FD1 Convolutional_Code_3_noise_3__x0_reg ( .D(n29_1), .CP(clock), .Q(
        Convolutional_Code_3_noise_3__x0) );
  FD1 Convolutional_Code_3_noise_3__x1_reg ( .D(n34_1), .CP(clock), .Q(
        Convolutional_Code_3_noise_3__x1) );
  IV U27 ( .A(n30), .Z(n9) );
  IV U28 ( .A(n37), .Z(n8) );
  IV U29 ( .A(n33), .Z(n7) );
  IV U30 ( .A(n31), .Z(n6) );
  IV U31 ( .A(n36), .Z(n5) );
  IV U32 ( .A(Convolutional_Code_3_noise_3__x2), .Z(n45) );
  IV U33 ( .A(Convolutional_Code_3_noise_3__x1), .Z(n43) );
  IV U34 ( .A(n40), .Z(n4) );
  IV U35 ( .A(n38), .Z(n3) );
  IV U36 ( .A(n46), .Z(n23) );
  IV U37 ( .A(n44), .Z(n22) );
  IV U38 ( .A(n47), .Z(n21) );
  IV U39 ( .A(Convolutional_Code_3_noise_3__x0), .Z(n20) );
  IV U40 ( .A(n39), .Z(n2) );
  IV U41 ( .A(n35), .Z(n18) );
  IV U42 ( .A(n28), .Z(n17) );
  IV U43 ( .A(n27), .Z(n16) );
  IV U44 ( .A(n26), .Z(n15) );
  IV U45 ( .A(n25), .Z(n14) );
  IV U46 ( .A(Convolutional_Code_3_r2), .Z(n13) );
  IV U47 ( .A(n24), .Z(n12) );
  IV U48 ( .A(n29), .Z(n11) );
  IV U49 ( .A(n19), .Z(n10) );
  IV U50 ( .A(n32), .Z(n1) );
endmodule

