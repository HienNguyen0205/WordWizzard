export default class Constants {
  constructor() {
    this.LEVEL_1 = 0;
    this.LEVEL_2 = 500;
    this.LEVEL_3 = 1500;
    this.LEVEL_4 = 2500;
    this.LEVEL_5 = 4000;
    this.LEVEL_6 = 5000;
    this.LEVEL_7 = 6500;
    this.LEVEL_8 = 7500;
    this.LEVEL_9 = 9000;
    this.LEVEL_10 = 10000;
    this.LEVEL_11 = 11500;
    this.LEVEL_12 = 12000;
    this.LEVEL_13 = 13500;
    this.LEVEL_14 = 14250;
    this.LEVEL_15 = 15000;
  }
  getUserLevel(score) {
    if (score >= this.LEVEL_15) {
      return 15;
    } else if (score >= this.LEVEL_14) {
      return 14;
    } else if (score >= this.LEVEL_13) {
      return 13;
    } else if (score >= this.LEVEL_12) {
      return 12;
    } else if (score >= this.LEVEL_11) {
      return 11;
    } else if (score >= this.LEVEL_10) {
      return 10;
    } else if (score >= this.LEVEL_9) {
      return 9;
    } else if (score >= this.LEVEL_8) {
      return 8;
    } else if (score >= this.LEVEL_7) {
      return 7;
    } else if (score >= this.LEVEL_6) {
      return 6;
    } else if (score >= this.LEVEL_5) {
      return 5;
    } else if (score >= this.LEVEL_4) {
      return 4;
    } else if (score >= this.LEVEL_3) {
      return 3;
    } else if (score >= this.LEVEL_2) {
      return 2;
    } else if (score >= this.LEVEL_1) {
      return 1;
    } else {
      return 0;
    }
  }
}
