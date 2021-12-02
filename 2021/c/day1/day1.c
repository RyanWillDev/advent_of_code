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
  int WINDOW_SIZE = 3;
  int array_length = sizeof(depths) / sizeof(depths[0]);
  int depth_increases = 0;

  int current_window_start;
  int current_window_sum = 0;

  int next_window_start;
  int next_window_sum = 0;

  for (int i = 0; i < array_length; i++) {
    current_window_start = i;
    next_window_start = current_window_start + 1;

    // next window doesn't have enough elements to fill window
    if (array_length - next_window_start < WINDOW_SIZE) {
      break;
    }

    // Using * to get around pointer stuff for now
    for (int j = 1 * current_window_start; j < (current_window_start + WINDOW_SIZE); j++) {
      current_window_sum += depths[j];
    }

    // Using * to get around pointer stuff for now
    for (int j = 1 * next_window_start; j < (next_window_start + WINDOW_SIZE); j++) {
      next_window_sum += depths[j];
    }

    if (next_window_sum > current_window_sum) depth_increases += 1;

    next_window_sum = 0;
    current_window_sum = 0;
  }

  return depth_increases;
}
