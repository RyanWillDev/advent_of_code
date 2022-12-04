import { PRIORITIES } from './pritorities';

export function part1(input: string[]) {
  return input.map(checkRucksack).reduce((x, y) => x + y, 0);
}

function checkRucksack(input: string) {
  const items = input.split('');
  const compartment1 = items.slice(0, items.length / 2);
  const compartment2 = items.slice(items.length / 2);
  const common = findCommonItem(compartment1, compartment2);
  return getPriority(common);
}

function getPriority(char: string): number {
  const priority = PRIORITIES.indexOf(char);

  if (priority < 0) throw new Error('Unable to find priority');

  return priority + 1;
}

function findCommonItem<T>(a: T[], ...rest: T[][]): T {
  const collections = rest.map((c) => {
    const s = new Set();
    for (let i of c) {
      s.add(i);
    }
    return s;
  });

  const common = a.find((i) => collections.every((c) => c.has(i)));

  if (!common) {
    console.log(`No common element found in ${a} and ${rest}`);
    throw new Error('No common item found');
  }

  return common;
}

export function part2() {}
export function processInput(input: string) {
  return input.trim().split('\n');
}
