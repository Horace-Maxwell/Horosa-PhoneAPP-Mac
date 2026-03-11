"use client";

import * as React from "react";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import DateRange from "./date-range";
import { IconTimer, IconNumbers } from "@/components/icons";
import { formatDateToString, getDateRange } from "@/lib/formatter";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export function ToolUsage() {
  const [range, setRange] = React.useState(0);
  const [usages, setUsages] = React.useState({});

  const getToolUsage = ({ from, to }) => {
    fetch('https://api.horosa.com/admin/data/tools_use', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: JSON.stringify({ start_time: formatDateToString(from), end_time: formatDateToString(to) }),
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        console.log(res.data)
        setUsages(res.data)
      }
    })
  }

  React.useEffect(() => {
    getToolUsage(getDateRange(0))
  }, [])

  return (
    <Card className="border-none shadow-none">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
        <CardTitle className="font-bold">工具使用概况</CardTitle>
        <DateRange
          value={range}
          onChange={({ value, from, to }) => {
            console.log(value, from, to)
            if (value !== null) {
              setRange(value)
            }
            getToolUsage({ from, to })
          }} />
      </CardHeader>
      <CardContent>
        <div className="w-full grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                八字使用人次
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconTimer className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{usages?.['trigram-bazi']?.count ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                六爻使用人次
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconTimer className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{usages?.['trigram-sixline']?.count ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                六壬使用人次
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconTimer className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{usages?.['trigram-liuren']?.count ?? 0}</span>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0">
              <CardTitle className="text-sm font-semibold">
                奇门使用人次
              </CardTitle>
              <IconNumbers className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <IconTimer className="h-5 w-5 text-muted-foreground" />
                <span className="text-2xl font-bold">{usages?.['trigram-qimen']?.count ?? 0}</span>
              </div>
            </CardContent>
          </Card>
        </div>
      </CardContent>
    </Card>
  )
}
