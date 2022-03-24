
String dt2mmyy(DateTime dt) {
  if (dt.year == DateTime.now().year) return '${dt.month}月${dt.day}日';
  return '${dt.year}年${dt.month}月${dt.day}日';
}