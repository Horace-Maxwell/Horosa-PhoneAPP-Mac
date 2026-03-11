import {
  Card,
  CardContent,
  CardHeader,
} from "@/components/ui/card"
import { UserTable } from "@/components/user"


/** 用户管理 */
export default function UsersPage() {

  return (
    <Card className="h-full">
      <CardHeader className="p-4">
        <h2 className="text-2xl font-bold tracking-tight">用户管理</h2>
      </CardHeader>
      <CardContent className="p-4">
        <UserTable />
      </CardContent>
    </Card>
  )
}
