#include "helper.h"
#include <stdio.h>

int test_depths[10] = {199, 200, 208, 210, 200, 207, 240, 269, 260, 263};
int part1(void);
int part2(void);

int main(void) {
    printf("Answer for Part 1 is: %i\n", part1());
    printf("Answer for Part 2 is: %i\n", part2());
}

int part1(void) {
  int previous = 0;
  int depth_increases = 0;
  int stop = sizeof(depths) / sizeof(depths[0]);

  for (int i = 0; i < stop; i++) {
    int current = depths[i];

    if (i == 0) {
      previous = depths[i];
      continue;
    }

    if (previous < current) depth_increases += 1;

    previous = current;
  }

  return depth_increases;
}

int part2(void) {
  return 0;
}
