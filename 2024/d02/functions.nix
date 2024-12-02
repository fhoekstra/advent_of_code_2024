with builtins;
with import <nixpkgs> { };
with {
  str = lib.strings;
  lst = lib.lists;
  abs = x: if x < 0 then -x else x;
  positive = x: x > 0;
  negative = x: x < 0;
  anyElement = l: (length l) > 0;
};
let
  parse =
    filePath:
    lib.pipe (readFile filePath) [
      (str.removeSuffix "\n")
      (str.splitString "\n")
      (map (line: map str.toInt (str.splitString " " line)))
    ];
  getDiffs =
    report:
    let
      diff = a: b: b - a;
      upToLast = lst.take ((length report) - 1) report;
      fromSecond = lst.drop 1 report;
    in
    assert (length upToLast) == (length fromSecond);
    lst.zipListsWith diff upToLast fromSecond;
  isDiffsSafe =
    diffs:
    let
      allIncreasing = lst.all positive diffs;
      allDecreasing = lst.all negative diffs;
      gradual = x: ((abs x) <= 3);
      allGradual = lst.all gradual diffs;
    in
    (allIncreasing || allDecreasing) && allGradual;
  isReportSafeWithRemovedLevel =
    report:
    let
      reportLength = length report;
      lastIndex = reportLength - 1;
      allChangedReports = map removeLevelAtIdx allIndices;
      allIndices = lst.range 0 (length report);
      removeLevelAtIdx =
        idx:
        if idx == 0 then
          (lst.drop 1 report)
        else
          (
            if idx == lastIndex then
              (lst.take (reportLength - 1) report)
            else
              ((lst.take idx report) ++ (lst.drop (idx + 1) report))
          );
    in
    lst.any isReportSafe allChangedReports;
  isReportSafeWithDampener = report: (isReportSafe report) || (isReportSafeWithRemovedLevel report);
  countSafeReports =
    { reports, isSafeFunc }:
    lib.pipe (reports) [
      (filter isSafeFunc)
      (length)
    ];
  isReportSafe = report: isDiffsSafe (getDiffs report);
in
{
  getDiffs = getDiffs;
  isSafe = isDiffsSafe;
  countSafeReports =
    reports:
    countSafeReports {
      reports = reports;
      isSafeFunc = isReportSafe;
    };
  part1 =
    path:
    countSafeReports {
      reports = (parse path);
      isSafeFunc = isReportSafe;
    };
  part2 =
    path:
    countSafeReports {
      reports = (parse path);
      isSafeFunc = isReportSafeWithDampener;
    };
}
