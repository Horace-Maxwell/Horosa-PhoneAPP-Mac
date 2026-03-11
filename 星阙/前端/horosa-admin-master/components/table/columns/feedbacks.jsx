"use client"

import * as React from "react"
// import { Checkbox } from "@/components/ui/checkbox"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Button } from "@/components/ui/button";
import { DataTableColumnHeader } from "../data-table-column-header"
import { DeleteComfirm } from "@/components/feedback/delete-comfirm";

export const columns = ({ actions }) => ([
  // {
  //   id: "select",
  //   header: ({ table }) => (
  //     <Checkbox
  //       checked={
  //         table.getIsAllPageRowsSelected() ||
  //         (table.getIsSomePageRowsSelected() && "indeterminate")
  //       }
  //       onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
  //       aria-label="Select all"
  //       className="translate-y-[2px]"
  //     />
  //   ),
  //   cell: ({ row }) => (
  //     <Checkbox
  //       checked={row.getIsSelected()}
  //       onCheckedChange={(value) => row.toggleSelected(!!value)}
  //       aria-label="Select row"
  //       className="translate-y-[2px]"
  //     />
  //   ),
  //   enableSorting: false,
  //   enableHiding: false,
  // },
  {
    accessorKey: "create_time",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="反馈时间" />
    ),
    cell: ({ row }) => <div>{row.getValue("create_time")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "name",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="用户昵称" />
    ),
    cell: ({ row }) => <div>{row.getValue("name")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "content",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="反馈内容" />
    ),
    cell: ({ row }) => (
      <div className="max-w-80">
        <p className="text-sm inline-block">{`${row.getValue("content").slice(0, 20)}...`}</p>
        <Dialog>
          <DialogTrigger asChild>
            <Button
              variant="ghost"
              size="sm"
              className="inline-block text-blue-500"
            >
              查看更多
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[560px]">
            <DialogHeader>
              <DialogTitle>{`${row.getValue("name")}的反馈内容`}</DialogTitle>
              <DialogDescription>
                {`反馈时间：${row.getValue("create_time")}`}
              </DialogDescription>
            </DialogHeader>
            <p className="text-sm min-h-72">{row.getValue("content")}</p>
          </DialogContent>
        </Dialog>
      </div>
    ),
    enableSorting: false,
    enableHiding: false,
  },
  {
    id: "actions",
    header: () => <span>操作</span>,
    cell: ({ row }) => <DeleteComfirm actions={actions} row={row} />,
  }
]);