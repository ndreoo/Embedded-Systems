
extern void asm_routine();

void main() {

  asm volatile ("li t0,42");
  asm volatile ("li t1,17");
  asm volatile ("add t2,t0,t1");
  asm volatile ("sub t3,t0,t1");
  asm_routine();
  while (1);                              // Loop forever to prevent program from ending
} 