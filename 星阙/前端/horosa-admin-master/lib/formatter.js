export function formatDateToString(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

export function parseStringToDate(dateString) {
  const [datePart, timePart] = dateString.split(' ');
  const [year, month, day] = datePart.split('-').map(Number);
  const [hours, minutes, seconds] = timePart.split(':').map(Number);

  return new Date(year, month - 1, day, hours, minutes, seconds);
}

export function getDateRange(daysDiff) {
  if (daysDiff == null) return;
  
  const now = new Date();

  // 初始化 from 和 to 时间
  let from, to;

  if (daysDiff >= 0) {
    // 正数：计算从过去到今天的范围
    const targetDate = new Date(now);
    targetDate.setDate(now.getDate() - daysDiff);

    from = new Date(targetDate);
    from.setHours(0, 0, 0, 0);

    to = new Date(targetDate);
    to.setHours(23, 59, 59, 999);
  } else {
    // 负数：计算从今天到过去某一天的范围
    to = new Date(now);
    to.setHours(23, 59, 59, 999);

    const targetDate = new Date(now);
    targetDate.setDate(now.getDate() + daysDiff); // daysDiff 是负数，这里是加

    from = new Date(targetDate);
    from.setHours(0, 0, 0, 0);
  }

  return { from, to };
}