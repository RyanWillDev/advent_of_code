import fs from 'fs';
import {NonEmptyArr} from './types';

const path = process.argv.indexOf('-t') > 0 ? 'test_input.txt' : 'input.txt';

export default function (delimiter: string): NonEmptyArr<string> {
  return fs.readFileSync(path, 'utf8').split(delimiter) as NonEmptyArr<string>;
}
