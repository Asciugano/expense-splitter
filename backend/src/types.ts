export enum SplitStrategy {
  EQUAL = "EQUAL",
  EXACT = "EXACT",
  PERCENTAGE = "PERCENTAGE",
  RATIO = "RATIO",
}

export type SplitDetail =
  | {
      strategy: SplitStrategy.EQUAL;
    }
  | {
      strategy: SplitStrategy.EXACT;
      splits: {
        userId: string;
        amount: number;
      }[];
    }
  | {
      strategy: SplitStrategy.RATIO;
      splits: {
        userId: string;
        shares: number;
      }[];
    };
