"use client"

import { Bar, BarChart, CartesianGrid, XAxis } from "recharts"

import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "@/components/ui/chart"

// const chartData = [
//   { province: "山东", percent: 186 },
//   { province: "河南", percent: 305 },
//   { province: "北京", percent: 237 },
//   { province: "上海", percent: 73 },
//   { province: "广东", percent: 209 },
//   { province: "重庆", percent: 214 },
//   { province: "湖北", percent: 214 },
//   { province: "湖南", percent: 214 },
//   { province: "广西", percent: 214 },
//   { province: "浙江", percent: 214 },
// ]

const chartConfig = {
  data: {
    label: "数据",
    color: "hsl(var(--chart-1))",
  },
}

export function HorosaBarChart({ data = [] }) {
  return (
    <Card className="border-none shadow-none">
      <CardHeader>
        <CardTitle>地区概况</CardTitle>
      </CardHeader>
      <CardContent className="h-96">
        <ChartContainer config={chartConfig} className="w-full h-full">
          <BarChart accessibilityLayer data={data}>
            <CartesianGrid vertical={false} />
            <XAxis
              dataKey="province"
              tickLine={false}
              tickMargin={10}
              axisLine={false}
              tickFormatter={(value) => value.slice(0, 3)}
            />
            <ChartTooltip
              cursor={false}
              content={<ChartTooltipContent indicator="line" />}
            />
            <Bar dataKey="data" fill="var(--color-desktop)" radius={8} />
          </BarChart>
        </ChartContainer>
      </CardContent>
    </Card>
  )
}
