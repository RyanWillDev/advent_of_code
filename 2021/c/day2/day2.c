#include "input.h"
#include <stdio.h>
#include <string.h>

int test_amount[6] = {5, 5, 8, 3, 8, 2};
char test_direction[6][8] = {
  "forward",
  "down",
  "forward",
  "up",
  "down",
  "forward"
};

int part1(void);

int main(void) {
  printf("The answer to part 1 is: %i\n", part1());
}

int part1(void) {
  int horizontal_position = 0;
  int depth = 0;

  int array_length = sizeof(amount) / sizeof(amount[0]);

  for(int i = 0; i < array_length; i++) {

    if (strcmp(direction[i], "down") == 0) {
      depth += amount[i];
    } else if (strcmp(direction[i], "up") == 0) {
      depth -= amount[i];
    } else if (strcmp(direction[i], "forward") == 0) {
      horizontal_position += amount[i];
    }
  }

  return depth * horizontal_position;
}
