import * as React from "react"
import { DockTable } from "@/components/dock"
import {
  Card,
  CardContent,
  CardHeader,
} from "@/components/ui/card"


/** 金刚区 */
export default function DockPage() {

  return (
    <Card className="h-full">
      <CardHeader className="p-4">
        <h2 className="text-2xl font-bold tracking-tight">金刚区管理</h2>
      </CardHeader>
      <CardContent className="p-4">
        <DockTable />
      </CardContent>
    </Card>
  )
}
