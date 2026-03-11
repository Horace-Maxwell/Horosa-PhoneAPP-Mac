"use client";

import * as React from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import DateRange from "./date-range";
import { IconNumbers, IconAppStore, IconUserGroup, IconUserAdd, IconUserStar } from "@/components/icons"
import { formatDateToString, getDateRange } from "@/lib/formatter";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export function AppUsage() {
  const [range, setRange] = React.useState(0);
  const [statistic , setStatistic ] = React.useState({});

  const getAppUsage = ({ from, to }) => {
    fetch('https://api.horosa.com/admin/data/app_user', {
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

  React.useEffect(() => {
    getAppUsage(getDateRange(0))
  }, [])

  return (
    <Card className="border-none shadow-none">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
        <CardTitle className="font-bold">APP 用户活跃概况</CardTitle>
        <DateRange
          value={range}
          onChange={({ value, from, to }) => {
            console.log(value, from, to)
            if (value !== null) {
              setRange(value)
            }
            getAppUsage({ from, to })
          }} />
      </CardHeader>
      <CardContent>
        <div className="w-full grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                APP 打开次数
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconAppStore className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{statistic?.open ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                累计用户数
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconUserGroup className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{statistic?.users ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                新增用户数
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconUserAdd className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{statistic?.addUser ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                活跃用户数
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconUserStar className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{statistic?.openUser ?? 0}</span>
              </div>
            </CardContent>
          </Card>
        </div>
      </CardContent>
    </Card>
  )
}
