import { NonEmptyArr } from '../types';

type Acc = [number[], number[]];

export function part1(input: NonEmptyArr<string>) {
  return solve(input, 1);
}

export function part2(input: NonEmptyArr<string>) {
  return solve(input, 3);
}

export function processInput(input: string) {
 return input.split('\n');
}

function solve(i: NonEmptyArr<string>, n: number): number {
  const counts = i
    .reduce(
      ([chunk, counts]: Acc, calorieCount: string): Acc => {
        if (calorieCount === '') {
          let c = chunk.reduce((x, y) => x + y, 0);
          return [[], counts.concat(c)];
        }
        const calories = Number(calorieCount);
        return [chunk.concat(calories), counts];
      },
      [[], []]
    )
    .pop() as NonEmptyArr<number>;

  return counts
    .sort((a, b) => (a > b ? -1 : 1))
    .slice(0, n)
    .reduce((x, y) => x + y, 0);
}
