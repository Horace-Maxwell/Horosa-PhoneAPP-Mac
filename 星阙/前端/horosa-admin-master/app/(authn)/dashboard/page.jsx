"use client";

import { ToolUsage, AppUsage, RegionUsage } from "@/components/dashboard"
import {
  Card,
  CardContent,
  CardHeader,
} from "@/components/ui/card"

export default function DashboardPage() {

  return (
    <div className="w-full">
      <Card>
        <CardHeader className="p-0" />
        <CardContent className="p-0">
          <ToolUsage />
          <AppUsage />
          <RegionUsage />
        </CardContent>
      </Card>
    </div>
  )
}
