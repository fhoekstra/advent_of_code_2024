with builtins;
with import <nixpkgs> { };
with {
  str = lib.strings;
  lst = lib.lists;
  sum = foldl' (a: b: (a + b)) 0;
  upToLast = l: lib.lists.take ((length l) - 1) l;
  getElem = idx: l: elemAt l idx;
  isTrue = x: x == true;
};
let
  parse =
    filePath:
    lib.pipe (readFile filePath) [
      (lib.trim)
      (str.splitString "\n\n")
      (
        blocks:
        assert length blocks == 2;
        {
          rules = parseRules (elemAt blocks 0);
          updates = parseUpdates (elemAt blocks 1);
        }
      )
    ];
  parseUpdates =
    updatesString:
    lib.pipe (updatesString) [
      (str.splitString "\n")
      (map (
        update:
        lib.pipe update [
          (str.splitString ",")
          (
            e: # trace (elemAt e 1)
            (map str.toInt e)
          )
        ]
      ))
    ];
  parseRules =
    l:
    lib.pipe l [
      (str.splitString "\n")
      (map (str.splitString "|"))
      (map (map str.toInt))
      (map (
        pair:
        let
          before = elemAt pair 0;
          after = elemAt pair 1;
        in
        {
          btoa = [
            [
              before
              after
            ]
          ];
          atob = [
            [
              after
              before
            ]
          ];
        }
      ))
      (foldl'
        (leftMap: rightMap: {
          btoa = (leftMap.btoa ++ rightMap.btoa);
          atob = (leftMap.atob ++ rightMap.atob);
        })
        {
          btoa = [ ];
          atob = [ ];
        }
      )
    ];
  part1 =
    { rules, updates }:
    lib.pipe updates [
      (filter (isOrderedUpdate rules))
      (map getMiddleElem)
      sum
    ];
  part2 =
    { rules, updates }:
    lib.pipe updates [
      (filter (update: !(isOrderedUpdate rules update)))
      (map (sortUpdate rules))
      (map getMiddleElem)
      sum
    ];
  isOrderedUpdate =
    rules: pages:
    let
      isOrdered =
        idx: el:
        let
          leftSide = lst.take (idx) pages;
          leftSideIsNotOrdered = lib.pipe el [
            (getMatchingFromRules rules.btoa)
            (any (e: elem e leftSide))
          ];
          rightSide = lst.drop (idx + 1) pages;
          rightSideIsNotOrdered = lib.pipe el [
            (getMatchingFromRules rules.atob)
            (any (e: elem e rightSide))
          ];
        in
        !(rightSideIsNotOrdered || leftSideIsNotOrdered);
    in
    all isTrue (lst.imap0 isOrdered pages);
  getMatchingFromRules =
    rulesMap: e:
    lib.pipe rulesMap [
      (filter (p: (getElem 0 p) == e))
      (map (getElem 1))
    ];
  getMiddleElem = l: elemAt l ((length l) / 2);
  sortUpdate =
    rules: pages:
    let
      appearingInRules = p: any (pageinrules: p == pageinrules) (lst.flatten rules.atob);
      pagesAppearingInRules = filter appearingInRules pages;
      otherPages = filter (p: !(appearingInRules p)) pages;
      sortedRulesPages = sort comparator pagesAppearingInRules;
      comparator =
        left: right:
        let
          thingsThatShouldGoAfterLeft = getMatchingFromRules rules.btoa left;
        in
        (elem right thingsThatShouldGoAfterLeft);
    in
    # trace (sortedRulesPages)
    (sortedRulesPages ++ otherPages);
in
{
  part1 = path: part1 (parse path);
  part2 = path: part2 (parse path);
}
