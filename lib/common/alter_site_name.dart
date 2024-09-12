String alterSiteName(String siteName) {
  String newSiteName = '';
  if (siteName.startsWith('www.') || siteName.startsWith('https://www')) {
    List l1 = siteName.split('.');
    newSiteName = l1[1];
    return newSiteName;
  }
  if (siteName.startsWith('http')) {
    List l1 = siteName.split('//');
    l1 = l1[1].split('.');
    newSiteName = l1[0];
    return newSiteName;
  }
  return siteName;
}
