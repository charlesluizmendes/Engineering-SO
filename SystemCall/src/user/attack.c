#include "kernel/types.h"
#include "user/user.h"

int main() {
  explode((char*)0xFFFFFFFF);  // ponteiro inválido
  exit(0);
}