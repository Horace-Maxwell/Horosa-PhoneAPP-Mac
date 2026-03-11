"use client";

import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { CalendarDateRangePicker } from "@/components/date-range-picker"
import { getDateRange } from "@/lib/formatter";

export default function DateRange({ value = 0, onChange }) {
  return (
    <div className="flex items-center space-x-2">
      <span className="text-sm mr-2">时间</span>
      <Tabs
        defaultValue={value}
        onValueChange={val => {
          onChange?.({
            value: val,
            ...getDateRange(val),
          })
        }}>
        <TabsList>
          <TabsTrigger value={0}>今天</TabsTrigger>
          <TabsTrigger value={1}>昨天</TabsTrigger>
          <TabsTrigger value={-7}>最近7天</TabsTrigger>
          <TabsTrigger value={-30}>最近30天</TabsTrigger>
        </TabsList>
      </Tabs>
      <CalendarDateRangePicker
        value={getDateRange(value)}
        onChange={(args) => {
        onChange?.({ ...args, value: null })
      }} />
    </div>
  )
}
