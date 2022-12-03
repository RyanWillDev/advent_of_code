import fs from 'fs';

const day = process.argv[2];
const useTestInput = process.argv.indexOf('-t') > 0;

const input = fs.readFileSync(useTestInput ? `day${day}/test_input.txt` : `day${day}/input.txt`, { encoding: 'ascii' });

const { processInput, part1, part2 } = require(`./day${day}/day${day}`);

const processedInput = processInput(input);

const part1Answer = part1(processedInput);
const part2Answer = part2(processedInput);

console.log(`Answer for day ${day} part1: ${part1Answer}`);
console.log(`Answer for day ${day} part2: ${part2Answer}`);
