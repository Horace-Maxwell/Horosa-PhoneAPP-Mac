"use client";

import * as React from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import DateRange from "./date-range";
import { HorosaBarChart } from "@/components/bar-chart"
import { formatDateToString, getDateRange } from "@/lib/formatter";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";
import { getProvinceByAdcode } from "@/lib/region";

export function RegionUsage() {

  const [range, setRange] = React.useState(0);
  const [statistic , setStatistic ] = React.useState({});

  const getRegionUsage = ({ from, to }) => {
    fetch('https://api.horosa.com/admin/data/user_region', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: JSON.stringify({ start_time: formatDateToString(from), end_time: formatDateToString(to) }),
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        console.log(res.data)
        setStatistic(res.data)
      }
    })
  }

  const convert2ChartData= (statis) => {
    return Object.entries(statis).map(([province, data]) => ({ province: getProvinceByAdcode(province).abbr, data }));
  }

  React.useEffect(() => {
    getRegionUsage(getDateRange(0))
  }, [])

  return (
    <Card className="border-none shadow-none">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
        <CardTitle className="font-bold">APP 用户地区概况</CardTitle>
        <DateRange
          value={range}
          onChange={({ value, from, to }) => {
            console.log(value, from, to)
            if (value !== null) {
              setRange(value)
            }
            getRegionUsage({ from, to })
          }} />
      </CardHeader>
      <CardContent>
        <HorosaBarChart data={convert2ChartData(statistic)} />
      </CardContent>
    </Card>
  )
}
