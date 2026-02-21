export const SplitStrategy = {
  EQUAL: "EQUAL",
  EXACT: "EXACT",
  PERCENTAGE: "PERCENTAGE",
  RATIO: "RATIO",
} as const;

export type SplitStrategy = (typeof SplitStrategy)[keyof typeof SplitStrategy];

export type SplitDetail =
  | {
      strategy: typeof SplitStrategy.EQUAL;
    }
  | {
      strategy: typeof SplitStrategy.EXACT;
      splits: {
        userId: string;
        amount: number;
      }[];
    }
  | {
      strategy: typeof SplitStrategy.RATIO;
      splits: {
        userId: string;
        shares: number;
      }[];
    };
