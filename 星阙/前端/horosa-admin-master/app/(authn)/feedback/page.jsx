"use client";

import {
  Card,
  CardContent,
  CardHeader,
} from "@/components/ui/card"
import { FeedbackTable } from "@/components/feedback/table";


/** 用户反馈 */
export default function FeedbackPage() {

  return (
    <Card className="h-full">
      <CardHeader className="p-4">
        <h2 className="text-2xl font-bold tracking-tight">用户反馈</h2>
      </CardHeader>
      <CardContent className="p-4">
        <FeedbackTable />
      </CardContent>
    </Card>
  )
}
