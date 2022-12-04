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

function findCommonItem(a: string[], b: string[]) {
  const cOneItems = new Set();

  for (let i in a) {
    cOneItems.add(a[i]);
  }

  const common = b.find((i) => cOneItems.has(i));

  if (!common) {
    console.log(`No common element found in ${a} and ${b}`);
    throw new Error('No commont item found');
  }

  return common;
}

export function part2() {}
export function processInput(input: string) {
  return input.trim().split('\n');
}
