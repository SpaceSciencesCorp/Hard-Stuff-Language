BEGIN {
  tabSize = 8;
}
{
  str = $0;
  idx = index(str, "\t");
  while (idx > 0) {
    left = substr(str, 0, idx - 1);
    right = substr(str, idx + 1);
    spaces = sprintf("% " ((tabSize + 1) - (idx % tabSize)) "s", "");
    str = left spaces right;
    idx = index(str, "\t");
  }
  print str;
}
