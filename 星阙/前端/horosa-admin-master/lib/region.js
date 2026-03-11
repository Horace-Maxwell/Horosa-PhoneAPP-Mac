"use client";

import regions from "@/assets/regions.json";

// 根据 adcode 获取行政区划信息
export function getRegionStrByAdcode(p, c, d) {
  if (p !== 0 && c !== 0 && d !== 0) {
    const province = regions.find((item) => item.adcode === p);
    const city = province?.children.find((item) => item.adcode === c);
    const district = city?.children.find((item) => item.adcode === d);
    return `${province?.name},${city?.name},${district?.name}`;
  } else {
    return `${regions[0].name},${regions[0].children[0].name},${regions[0].children[0].children[0].name}`;
  }
}

export function getProvinceByAdcode(p) {
  if (Boolean(p)) {
    const province = regions.find((item) => String(item.adcode).substring(0, 2) === String(p).substring(0, 2));
    return province;
  } else {
    return regions[0];
  }
}