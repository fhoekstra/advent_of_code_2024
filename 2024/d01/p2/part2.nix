with builtins;
let
  pkgs = import <nixpkgs> { };
  str = pkgs.lib.strings;
  lst = pkgs.lib.lists;
  getLines = fullContent: str.splitString "\n" fullContent;
  processLines = lines: foldl' sum_ 0 (getSim lines);
  processStr = s: processLines (getLines s);

  sum_ = x: y: x + y;
  getSim = lines: compareColumns (parseLines lines);
  parseLines = lines: getColumns (map getNumbers lines);

  getNumbers =
    line:
    if stringLength line == 0 then
      [
        0
        0
      ]
    else
      map str.toInt (filter (s: s != "") (str.splitString " " line));

  getColumns =
    listOfTuples:
    let
      first = x: elemAt x 0;
      second = x: elemAt x 1;
    in
    {
      first = map first listOfTuples;
      second = map second listOfTuples;
    };

  compareColumns =
    columnSet:
    let
      sort = lst.sort (a: b: a < b);

      colSim =
        x: y:
        let
          scoreTimesInY = num: num * lst.count (m: m == num) y;
        in
        map scoreTimesInY x;

    in
    colSim columnSet.first columnSet.second;

in
{
  processStr = processStr;
  processFile = p: processStr (readFile p);
}
