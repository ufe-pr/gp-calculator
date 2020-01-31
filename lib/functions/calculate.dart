double calculateGP(List scores) {
  int totUnits = 0;
  for (var score in scores) {
    totUnits += score['units'];
  }

  double gp = 0;
  for (var score in scores) {
    gp += partial(score, totUnits);
  }
  
  return (gp * 100).round() / 100;
}

const gradeMap = {
  'A': 5,
  'B': 4,
  'C': 3,
  'D': 2,
  'E': 1,
  'F': 0,  
};

double partial(Map score, int totUnits) {
  return gradeMap[score['grade']] * score['units'] / totUnits;
}
