enum Outcome {
  L = 0,
  D = 3,
  W = 6,
}

interface Playable {
  against(m: Move): Outcome;
  value: number;
}

interface Rock extends Playable {
  kind: 'rock';
}
interface Paper extends Playable {
  kind: 'paper';
}
interface Scissors extends Playable {
  kind: 'scissors';
}

// Unions all types together to get exhaustive checking on kind.
// https://www.typescriptlang.org/docs/handbook/2/narrowing.html#exhaustiveness-checking
type Move = Rock | Paper | Scissors;

class Rock implements Rock {
  value = 1;
  constructor() {
    this.kind = 'rock';
  }
  public against(m: Move) {
    switch (m.kind) {
      case this.kind:
        return Outcome.D;
      case 'paper':
        return Outcome.L;
      case 'scissors':
        return Outcome.W;
      default:
        let _exhaustive: never = m;
        return _exhaustive;
    }
  }
}

class Paper implements Paper {
  value = 2;
  constructor() {
    this.kind = 'paper';
  }
  public against(m: Move) {
    switch (m.kind) {
      case this.kind:
        return Outcome.D;
      case 'scissors':
        return Outcome.L;
      case 'rock':
        return Outcome.W;
      default:
        let _exhaustive: never = m;
        return _exhaustive;
    }
  }
}

class Scissors implements Scissors {
  value = 3;
  constructor() {
    this.kind = 'scissors';
  }
  public against(m: Move) {
    switch (m.kind) {
      case this.kind:
        return Outcome.D;
      case 'rock':
        return Outcome.L;
      case 'paper':
        return Outcome.W;
      default:
        let _exhaustive: never = m;
        return _exhaustive;
    }
  }
}

export function part1(input: string[]) {
  const mapper = (roundMoves: string) => {
    const moves = parseMoves(roundMoves);
    return round(...moves);
  };

  return input.map(mapper).reduce((x, y) => x + y, 0);
}

export function part2(input: string[]) {
  const mapper = (strategy: string) => {
    const parsedStrategy = parseStrategy(strategy);
    const me = determineMove(...parsedStrategy);
    const [opp, ..._rest] = parsedStrategy;

    return round(opp, me);
  };

  return input.map(mapper).reduce((x, y) => x + y, 0);
}

export function processInput(input: string) {
  return input.trim().split('\n');
}

function round(opp: Move, me: Move): number {
  const outcome = me.against(opp);

  return me.value + outcome;
}

function determineMove(opp: Move, outcome: Outcome): Move {
  const move = [Rock, Paper, Scissors].find((m) => new m().against(opp) === outcome);

  if (!move) {
    throw new Error('Could not determine move');
  }

  return new move();
}

function parseStrategy(s: string): [Move, Outcome] {
  const [opp, outcome] = s.split(' ');
  return [normalizeMove(opp), normalizeOutcome(outcome)];
}

function parseMoves(moves: string): [Move, Move] {
  return moves.split(' ').map(normalizeMove) as [Move, Move];
}

function normalizeOutcome(outcome: string): Outcome {
  switch (outcome) {
    case 'X':
      return Outcome.L;
    case 'Y':
      return Outcome.D;
    case 'Z':
      return Outcome.W;
    default:
      console.log(`Could not normalize outcome of ${outcome}`);
      throw new Error('Could not normalize outcome');
  }
}

function normalizeMove(move: string): Move {
  switch (move) {
    case 'A':
    case 'X':
      return new Rock();
    case 'B':
    case 'Y':
      return new Paper();
    case 'C':
    case 'Z':
      return new Scissors();
    default:
      console.log(`Unsupported Move ${move}`);
      throw new Error('Unsupported Move');
  }
}
